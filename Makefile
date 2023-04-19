
RENDER_QUALITY ?= 256

part:
	mkdir -p output/parts
	docker compose run cad openscad -o /parts/$(part).stl -D '$$fn=$(RENDER_QUALITY)' -D 'part="$(part)"' /cad/main.scad

all-parts:
	make part part="plate-gear"
	make part part="base-gear"
	make part part="base"

clean:
	rm -rf output
