SHELL := /bin/bash

RENDER_QUALITY ?= 256

build:
	docker compose build $(service)

src/cad/__main__.scad:
	./scripts/make-main-scad.sh

%.stl: src/cad/__main__.scad
	docker compose run cad \
		openscad --hardwarnings -o /parts/$@ -D '$$fn=$(RENDER_QUALITY)' -D 'part="$(basename $@)"' /cad/__main__.scad

cad:
	for f in src/cad/*.scad; do \
		if [[ $$(basename $$f .scad) == __*__ ]]; then continue; fi; \
		make $$(basename $$f .scad).stl || exit 1; \
	done; \

firmware:
	mkdir -p output/build
	docker compose run firmware arduino-cli compile --fqbn arduino:avr:leonardo --build-path /build /firmware

format:
	docker compose run format sh -c \
		"clang-format --style=microsoft $(if $(check),--dry-run --Werror,) -i /cad/*.scad /firmware/*.ino"

clean:
	rm -rf output
	rm -rf src/cad/__main__.scad
