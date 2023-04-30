SHELL := /bin/bash

RENDER_QUALITY ?= 256

build:
	docker compose build

firmware:
	mkdir -p output/build
	docker compose run firmware arduino-cli compile --fqbn arduino:avr:leonardo /firmware --build-path /build

src/cad/__main__.scad:
	./scripts/make-main-scad.sh

%.stl: src/cad/__main__.scad
	docker compose run cad openscad --hardwarnings -o /parts/$@ -D '$$fn=$(RENDER_QUALITY)' -D 'part="$(basename $@)"' /cad/__main__.scad

all-parts:
	for f in src/cad/*.scad; do \
		if [[ $$(basename $$f .scad) == __*__ ]]; then continue; fi; \
		make $$(basename $$f .scad).stl || exit 1; \
	done; \

clean:
	rm -rf output
	rm -rf src/cad/__main__.scad
