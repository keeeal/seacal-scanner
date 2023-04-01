
render_quality ?= 256

part:
	docker compose run cad openscad -o /cad/$(part).stl -D '$$fn=$(render_quality)' -D 'part="$(part)"' /cad/main.scad

all-parts:
	make part part="plate-gear"
	make part part="base-gear"
	make part part="base"

clean:
	rm **/*.stl
