SHELL := /bin/bash

src/cad/main.scad:
	docker compose run openscad openscad-build write-main cad/scanner

render:
	docker compose run openscad openscad-build render \
		$(if $(render-quality),--render-quality=$(render-quality),) \
		--output-dir=parts cad/render.yaml

firmware:
	docker compose run arduino arduino-cli compile --fqbn arduino:avr:leonardo --build-path build firmware

format:
	docker compose run format sh -c \
		'clang-format $(if $(check),--dry-run --Werror,) -i firmware/*.ino && \
		openscad-format $(if $(check),--dry-run --Werror,) -i $$(find cad/scanner -type f -name "*.scad")
		black $(if $(check),--check,) tests'

test-cad:
	docker compose run test pytest tests/cad

clean:
	rm -rf src/cad/main.scad
	rm -rf output
