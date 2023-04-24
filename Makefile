
RENDER_QUALITY ?= 256

build:
	docker compose build

firmware:
	mkdir -p output/build
	docker compose run firmware arduino-cli compile --fqbn arduino:avr:leonardo /firmware --build-path /build

part:
	mkdir -p output/parts
	docker compose run cad openscad -o /parts/$(part).stl -D '$$fn=$(RENDER_QUALITY)' -D 'part="$(part)"' /cad/main.scad

all-parts:
	make part part="plate-gear"
	make part part="base-gear"
	make part part="base"

clean:
	rm -rf output
