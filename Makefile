VERILOG_FILES = video.v
PCF_FILE = video.pcf

bin/toplevel.json: ${VERILOG_FILES}
	mkdir -p bin
	yosys -q -p "synth_ice40 -json bin/toplevel.json" ${VERILOG_FILES}

bin/toplevel.asc: ${PCF_FILE} bin/toplevel.json
	nextpnr-ice40 --freq 25 --hx8k --package tq144:4k --json bin/toplevel.json --pcf ${PCF_FILE} --asc bin/toplevel.asc --opt-timing

bin/toplevel.bin: bin/toplevel.asc
	icepack bin/toplevel.asc bin/toplevel.bin

.PHONY: time
time: bin/toplevel.bin
	icetime -tmd hx8k bin/toplevel.asc

.PHONY: upload
upload: bin/toplevel.bin
	stty -f /dev/cu.usbmodem00000000001A1 raw 
	cat bin/toplevel.bin >/dev/cu.usbmodem00000000001A1

.PHONY: clean
clean:
	rm -rf bin
