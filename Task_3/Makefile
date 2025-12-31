.PHONY: all sim wave clean

SIM_DIR = sim_results
RTL = gpio_multi_reg.v
TB = gpio_multi_tb.v

all: sim

sim: $(RTL) $(TB)
	mkdir -p $(SIM_DIR)
	iverilog -o $(SIM_DIR)/sim.vvp $(RTL) $(TB)
	cd $(SIM_DIR) && vvp sim.vvp | tee simulation.log
	@echo "Waveform ready: $(SIM_DIR)/waveform.vcd"

wave:
	gtkwave $(SIM_DIR)/waveform.vcd &

clean:
	rm -rf $(SIM_DIR)
