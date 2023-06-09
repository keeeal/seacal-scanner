
src/cad/main.scad:
	docker compose run openscad openscad-build write-main cad/scanner

render:
	docker compose run openscad openscad-build render cad/render.yaml \
		$(if $(render-quality),--render-quality=$(render-quality),) \
		--output-dir=parts --log

firmware:
	docker compose run arduino arduino-cli compile --fqbn arduino:avr:leonardo --build-path build firmware

format:
	docker compose run dev sh -c \
		'clang-format $(if $(check),--dry-run --Werror,) -i firmware/*.ino && \
		openscad-format $(if $(check),--dry-run --Werror,) -i $$(find cad/scanner -type f -name "*.scad") && \
		isort $(if $(check),--check,) tests && \
		black $(if $(check),--check,) tests'

test-cad:
	docker compose run dev pytest tests/cad

clean:
	rm -rf src/cad/main.scad
	rm -rf output
