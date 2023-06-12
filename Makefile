SHELL := /bin/bash

src/cad/main.scad:
	./scripts/make-main-scad.sh src/cad/scanner

%.stl: src/cad/main.scad
	mkdir -p output/logs
	docker compose run cad sh -c \
		'openscad -o /parts/$@ --hardwarnings \
			-D "\$$fn=$$(yq eval ".$(basename $@).render-quality" /cad/parts.yaml)" \
			-D "part=\"$(basename $@)\"" \
			/cad/main.scad \
		2> /logs/$(basename $@).log'

parts: src/cad/main.scad
	mkdir -p output/logs
	docker compose run cad sh -c \
		'yq eval "keys" /cad/parts.yaml | while read -r part; do \
			openscad -o /parts/$${part#- }.stl --hardwarnings \
				-D "\$$fn=$$(yq eval ".$${part#- }.render-quality" /cad/parts.yaml)" \
				-D "part=\"$${part#- }\"" \
				/cad/main.scad \
			2> /logs/$${part#- }.log; \
		done'

firmware:
	docker compose run firmware arduino-cli compile --fqbn arduino:avr:leonardo --build-path /build /firmware

format:
	docker compose run format sh -c \
		'clang-format $(if $(check),--dry-run --Werror,) -i /firmware/*.ino && \
		./openscad-format.sh $(if $(check),--dry-run --Werror,) -i $$(find /cad/scanner -type f -name "*.scad")'

test-cad:
	docker compose run test pytest /tests/cad

clean:
	rm -rf src/cad/main.scad
	rm -rf output
