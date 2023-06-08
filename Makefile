SHELL := /bin/bash

render_quality ?= 256

src/cad/main.scad:
	./scripts/make-main-scad.sh

%.stl: src/cad/main.scad
	mkdir -p output/logs
	docker compose run cad \
		openscad -o /parts/$@ --hardwarnings -D '$$fn=$(render_quality)' -D 'part="$(basename $@)"' /cad/main.scad \
	>& output/logs/$(basename $@).log

parts:
	for f in src/cad/parts/*.scad; do \
		make $$(basename $$f .scad).stl || exit 1; \
	done; \

firmware:
	docker compose run firmware arduino-cli compile --fqbn arduino:avr:leonardo --build-path /build /firmware

format:
	docker compose run format sh -c \
		"clang-format $(if $(check),--dry-run --Werror,) -i /firmware/*.ino"
	docker compose run format sh -c \
		"./openscad-format.sh $(if $(check),--dry-run --Werror,) \
		-i /cad/components/*.scad /cad/parts/*.scad /cad/assembly.scad"

test-cad:
	docker compose run test pytest /tests/cad

clean:
	rm -rf src/cad/main.scad
	rm -rf output
