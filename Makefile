parts-dir ?= build/parts
firmware-dir ?= build/firmware

main.scad:
	docker compose run openscad openscad-build write-main src/cad/scanner main.scad

render:
	mkdir -p $(parts-dir)
	docker compose run openscad openscad-build render src/cad/render.yaml \
		$(if $(render-quality),--render-quality=$(render-quality),) \
		--output-dir=$(parts-dir) --log

firmware:
	mkdir -p $(firmware-dir)
	docker compose run arduino arduino-cli compile --fqbn arduino:avr:leonardo --build-path $(firmware-dir) src/firmware

format:
	docker compose run dev sh -c \
		'clang-format $(if $(check),--dry-run --Werror,) -i src/firmware/*.ino && \
		openscad-format $(if $(check),--dry-run --Werror,) -i $$(find src/cad/scanner -type f -name "*.scad") && \
		isort $(if $(check),--check,) tests && \
		black $(if $(check),--check,) tests'

test-cad:
	docker compose run dev pytest tests/cad

clean:
	git clean -Xdf
