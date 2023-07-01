SHELL := /bin/bash

src/cad/main.scad:
	docker compose run cad openscad-build write-main cad/scanner

render:
	docker compose run cad openscad-build render cad/render.yaml --output-dir parts

firmware:
	docker compose run firmware arduino-cli compile --fqbn arduino:avr:leonardo --build-path build firmware

format:
	docker compose run format sh -c \
		'clang-format $(if $(check),--dry-run --Werror,) -i firmware/*.ino && \
		openscad-format $(if $(check),--dry-run --Werror,) -i $$(find cad/scanner -type f -name "*.scad")'
	docker compose run dev black $(if $(check),--check,) tests

test-cad:
	docker compose run test pytest tests/cad

clean:
	rm -rf src/cad/main.scad
	rm -rf output
