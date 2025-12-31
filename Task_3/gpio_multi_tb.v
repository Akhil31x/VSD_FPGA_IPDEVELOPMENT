`timescale 1ns/1ps

module gpio_tb;

    reg clk, rst;
    reg [31:0] addr, write_data;
    reg write_enable, read_enable, chip_select;
    reg [31:0] gpio_in;
    wire [31:0] read_data, gpio_out;

    gpio_control_ip dut (
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .chip_select(chip_select),
        .gpio_in(gpio_in),
        .gpio_out(gpio_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        gpio_in = 32'h0000_0000;
        write_enable = 0;
        read_enable = 0;
        chip_select = 1;

        $display("\n=== GPIO CONTROL IP TEST ===\n");

        #20 rst = 0;

        // TEST 1: Set GPIO direction (all output)
        #10;
        $display("[TEST 1] Setting GPIO_DIR to 0xFFFFFFFF (all output)");
        addr = 32'h2000_0004;    // GPIO_DIR offset 0x04
        write_data = 32'hFFFF_FFFF;
        write_enable = 1;
        #10 write_enable = 0;

        // Verify direction was written
        #10;
        read_enable = 1;
        #10;
        $display("         GPIO_DIR readback: 0x%h (expected: 0xFFFFFFFF)", read_data);
        read_enable = 0;

        // TEST 2: Write data to GPIO_DATA
        #10;
        $display("\n[TEST 2] Writing 0x12345678 to GPIO_DATA");
        addr = 32'h2000_0000;    // GPIO_DATA offset 0x00
        write_data = 32'h1234_5678;
        write_enable = 1;
        #10 write_enable = 0;

        // Verify data was written
        #10;
        read_enable = 1;
        #10;
        $display("         GPIO_DATA readback: 0x%h (expected: 0x12345678)", read_data);
        $display("         GPIO_OUT signal: 0x%h (expected: 0x12345678, since all output)", gpio_out);
        read_enable = 0;

        // TEST 3: Read GPIO_READ (should reflect GPIO_DATA since all output)
        #10;
        $display("\n[TEST 3] Reading GPIO_READ register");
        addr = 32'h2000_0008;    // GPIO_READ offset 0x08
        read_enable = 1;
        #10;
        $display("         GPIO_READ: 0x%h (expected: 0x12345678, reflects output pins)", read_data);
        read_enable = 0;

        // TEST 4: Set GPIO direction (lower half input, upper half output)
        #10;
        $display("\n[TEST 4] Setting GPIO_DIR to 0xFFFF0000 (upper half output, lower half input)");
        addr = 32'h2000_0004;    // GPIO_DIR
        write_data = 32'hFFFF_0000;
        write_enable = 1;
        #10 write_enable = 0;

        #10;
        read_enable = 1;
        #10;
        $display("         GPIO_DIR readback: 0x%h", read_data);
        read_enable = 0;

        // TEST 5: Write new data to GPIO_DATA
        #10;
        $display("\n[TEST 5] Writing 0xABCD_EF00 to GPIO_DATA");
        addr = 32'h2000_0000;    // GPIO_DATA
        write_data = 32'hABCD_EF00;
        write_enable = 1;
        #10 write_enable = 0;

        // TEST 6: Apply external input on lower half
        #10;
        $display("\n[TEST 6] Applying external input 0x0000DEAD on lower 16 bits");
        gpio_in = 32'h0000_DEAD;

        #10;
        addr = 32'h2000_0008;    // GPIO_READ
        read_enable = 1;
        #10;
        $display("         GPIO_READ: 0x%h", read_data);
        $display("         Expected: 0xABCDDEAD (upper from data=0xABCD, lower from input=0xDEAD)");
        read_enable = 0;

        // TEST 7: Verify GPIO_OUT reflects only output pins
        #10;
        $display("\n[TEST 7] GPIO_OUT should only reflect output pins");
        $display("         GPIO_OUT: 0x%h", gpio_out);
        $display("         Expected: 0xABCD0000 (only upper bits, since only upper are output)");

        #20;
        $display("\n=== ALL TESTS COMPLETE ===\n");
        $finish;
    end

endmodule
