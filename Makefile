SHELL := /bin/bash

render_quality ?= 256

build:
	docker compose build $(service)

main-scad:
	./scripts/make-main-scad.sh

%.stl: main-scad
	mkdir -p output/logs
	docker compose run cad \
		openscad -o /parts/$@ --hardwarnings -D '$$fn=$(render_quality)' -D 'part="$(basename $@)"' /cad/__main__.scad \
	>& output/logs/$(basename $@).log

# |& grep "Volumes:" | tail -c 2 | xargs test 2 -eq

parts:
	for f in src/cad/*.scad; do \
		if [[ $$(basename $$f .scad) == __*__ ]]; then continue; fi; \
		make $$(basename $$f .scad).stl || exit 1; \
	done; \

test-cad:
	docker compose run test pytest /tests/cad

binaries:
	docker compose run firmware arduino-cli compile --fqbn arduino:avr:leonardo --build-path /build /firmware

format:
	docker compose run format sh -c \
		"clang-format --style=microsoft $(if $(check),--dry-run --Werror,) -i /cad/*.scad /firmware/*.ino"

clean:
	rm -rf output
	rm -rf src/cad/__main__.scad
