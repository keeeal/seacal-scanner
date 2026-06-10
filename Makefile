# board = arduino:renesas_uno:unor4wifi
board = arduino:renesas_uno:minima
# board = arduino:avr:leonardo

all: app firmware cad pcb

app:
	cargo build

run:
	cargo run

firmware:
	arduino-cli compile \
		--fqbn $(board) \
		--warnings all \
		--build-path build \
		src/firmware

upload:
	arduino-cli upload \
		--port /dev/ttyACM0 \
		--fqbn $(board) \
		--input-dir build

pcb:
	for pcb in $$(basename -a src/pcb/*/); do \
		kicad-cli pcb export gerbers \
			--layers $$(cat src/pcb/layers.txt | tr -s '[:space:]' ',') \
			--output gerbers/$$pcb \
			src/pcb/$$pcb/$$pcb.kicad_pcb; \
		kicad-cli pcb export drill \
			--output gerbers/$$pcb \
			src/pcb/$$pcb/$$pcb.kicad_pcb; \
	done

format: format-app format-firmware

format-app:
	cargo fmt $(if $(check),--check,)

format-firmware:
	clang-format $(if $(check),--dry-run --Werror,-i) src/firmware/*.ino src/firmware/*.h

test: test-app test-firmware test-cad test-pcb

test-app:
	cargo clippy -- --deny warnings && \
	cargo test

test-firmware: googletest
	mkdir -p build && \
	clang++ -std=gnu++17 -pthread \
		-Igoogletest/googlemock -Igoogletest/googlemock/include \
		-Igoogletest/googletest -Igoogletest/googletest/include \
		$$(find ~/Arduino/libraries -maxdepth 1 -printf '-I%p ') \
		-Isrc/firmware \
		googletest/googlemock/src/gmock-all.cc \
		googletest/googletest/src/gtest-all.cc \
		tests/firmware/__main__.cpp \
		-o build/tests && \
	./build/tests

test-cad:
	pytest tests/cad

test-pcb:
	pytest tests/pcb

install: arduino-cli

arduino-cli:
	curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
	arduino-cli core install arduino:renesas_uno
	xargs -a src/firmware/requirements.txt arduino-cli lib install

googletest:
	git clone --branch v1.17.0  https://github.com/google/googletest

clean:
	git clean -Xdf
