INCLUDE_FILES = lib/*.v lib/*.hex
TOP_LEVEL = video.v
PCF_FILE = video.pcf
TARGET_FREQ = 50

bin/toplevel.bin: bin/toplevel.asc
	icepack bin/toplevel.asc bin/toplevel.bin

bin/toplevel.asc: ${PCF_FILE} bin/toplevel.json
	nextpnr-ice40 --freq ${TARGET_FREQ} --hx8k --package tq144:4k \
				  --json bin/toplevel.json --pcf ${PCF_FILE} \
				  --asc bin/toplevel.asc --opt-timing

bin/toplevel.json: ${TOP_LEVEL} ${INCLUDE_FILES}
	mkdir -p bin
	yosys -q -p "synth_ice40 -json bin/toplevel.json" ${TOP_LEVEL} 

.PHONY: stat
stat: bin/toplevel.asc
	icebox_stat -v bin/toplevel.asc

.PHONY: timing
timing: bin/toplevel.bin
	icetime -tmd hx8k bin/toplevel.asc

.PHONY: upload
upload: bin/toplevel.bin
	stty -f /dev/cu.usbmodem00000000001A1 raw 
	cat bin/toplevel.bin >/dev/cu.usbmodem00000000001A1

.PHONY: clean
clean:
	rm -rf bin
