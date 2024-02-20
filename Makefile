cad-build-dir ?= build/parts
firmware-build-dir ?= build/firmware

cad-root-dir := src/cad/scanner
firmware-dir := src/firmware
render-config := src/cad/render.yaml

cad-root-files := $(shell find $(cad-root-dir) -type f -name "*.scad")
firmware-files := $(shell \
	find $(firmware-dir) -type f -name "*.ino" -o -name "*.cpp" -o -name "*.h" \
)

main.scad: $(cad-root-files)
	docker compose run openscad openscad-build write-main $(cad-root-dir) main.scad

render:
	mkdir -p $(cad-build-dir)
	docker compose run openscad openscad-build render $(render-config) \
		$(if $(render-quality),--render-quality=$(render-quality),) \
		--output-dir=$(cad-build-dir) --log

firmware:
	mkdir -p $(firmware-build-dir)
	docker compose run arduino arduino-cli compile \
		--fqbn arduino:avr:leonardo \
		--warnings all \
		--build-property compiler.cpp.extra_flags="-Werror -Wno-unused-parameter -Wno-reorder" \
		--build-path $(firmware-build-dir) \
		$(firmware-dir)

format:
	docker compose run dev sh -c \
		'clang-format $(if $(check),--dry-run --Werror,) -i $(firmware-files) && \
		openscad-format $(if $(check),--dry-run --Werror,) -i $(cad-root-files) && \
		isort $(if $(check),--check,) tests && \
		black $(if $(check),--check,) tests'

test-cad:
	docker compose run dev pytest tests/cad

clean:
	git clean -Xdf
