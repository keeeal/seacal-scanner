cad-build-dir ?= build/parts
firmware-build-dir ?= build/firmware
pcb-build-dir ?= build/gerbers

cad-root-dir := src/cad/scanner
firmware-dir := src/firmware
render-config := src/cad/render.yaml
pcb-file := src/pcb/seacal-scanner.kicad_pcb
sch-file := src/pcb/seacal-scanner.kicad_sch
layers-config := src/pcb/layers.csv

cad-root-files := $(shell find $(cad-root-dir) -type f -name "*.scad")
firmware-files := $(shell \
	find $(firmware-dir) -type f -name "*.ino" -o -name "*.cpp" -o -name "*.h" \
)
pcb-layers := $(shell cat $(layers-config) | tr -s '[:space:]' ',')

main.scad: $(cad-root-files)
	docker compose run openscad openscad-build write-main $(cad-root-dir) main.scad

render:
	mkdir -p $(cad-build-dir)
	docker compose run openscad openscad-build render \
		$(render-config) \
		$(if $(render-quality),--render-quality=$(render-quality),) \
		--log --output-dir=$(cad-build-dir)

firmware:
	mkdir -p $(firmware-build-dir)
	docker compose run arduino arduino-cli compile \
		--fqbn arduino:avr:leonardo \
		--warnings all \
		--build-property \
			compiler.cpp.extra_flags="-Werror -Wno-unused-parameter -Wno-reorder" \
		--build-path $(firmware-build-dir) \
		$(firmware-dir)

gerbers:
	mkdir -p $(pcb-build-dir)
	docker compose run kicad sh -c \
		'kicad-cli pcb export gerbers \
			--layers $(pcb-layers) \
			--output $(pcb-build-dir) \
			$(pcb-file) && \
		kicad-cli pcb export drill \
			--output $(pcb-build-dir)/ \
			$(pcb-file) && \
		kicad-cli pcb drc \
			--severity-error \
			--output $(pcb-build-dir)/drc.rpt \
			$(pcb-file) && \
		kicad-cli sch erc \
			--severity-error \
			--output $(pcb-build-dir)/erc.rpt \
			$(sch-file)'

format:
	docker compose run dev sh -c \
		'clang-format $(if $(check),--dry-run --Werror,) -i $(firmware-files) && \
		openscad-format $(if $(check),--dry-run --Werror,) -i $(cad-root-files) && \
		isort $(if $(check),--check,) tests && \
		black $(if $(check),--check,) tests'

test-cad:
	docker compose run dev pytest tests/cad

test-firmware:
	docker compose run dev pytest tests/firmware

test-pcb:
	docker compose run dev pytest tests/pcb

test:
	docker compose run dev pytest tests

clean:
	git clean -Xdf
