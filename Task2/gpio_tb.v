`timescale 1ns/1ps

module gpio_tb;

    reg clk, rst;
    reg [31:0] addr, write_data;
    reg write_enable, read_enable, chip_select;
    wire [31:0] read_data, gpio_out;

    gpio_output_ip dut (
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .chip_select(chip_select),
        .gpio_out(gpio_out)
    );

    always #5 clk = ~clk;   // 10 ns clock

    initial begin
        clk = 0;
        rst = 1;
        addr = 32'h2000_0000;
        write_data = 32'h0;
        write_enable = 0;
        read_enable = 0;
        chip_select = 1;

        $display("=== GPIO IP TEST START ===");

        #20 rst = 0;   // deassert reset

        // Test 1
        #10;
        write_enable = 1;
        write_data = 32'h12345678;
        #10 write_enable = 0;

        #10;
        read_enable = 1;
        #10;
        $display("TEST1: read_data=%h gpio_out=%h", read_data, gpio_out);
        read_enable = 0;

        // Test 2
        #10;
        write_enable = 1;
        write_data = 32'hDEADBEEF;
        #10 write_enable = 0;

        #10;
        read_enable = 1;
        #10;
        $display("TEST2: read_data=%h gpio_out=%h", read_data, gpio_out);
        read_enable = 0;

        // Finish
        #20;
        $display("=== GPIO IP TEST END ===");
        $finish;
    end

endmodule
