
render_quality ?= 128

inner-cog:
	docker compose run cad openscad -o /cad/inner-cog.stl -D '$$fn=$(render_quality)' -D 'part="inner-cog"' /cad/main.scad

clean:
	rm **/*.stl
