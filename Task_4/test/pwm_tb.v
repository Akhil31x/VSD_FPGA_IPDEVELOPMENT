`timescale 1ns/1ps
module pwm_tb;

reg clk = 0;
reg rst_n = 0;
reg bus_we;
reg [31:0] bus_addr;
reg [31:0] bus_wdata;
wire pwm_out;

always #5 clk = ~clk;  // 100 MHz clock

pwm_ip dut (
    .clk(clk),
    .rst_n(rst_n),
    .bus_we(bus_we),
    .bus_addr(bus_addr),
    .bus_wdata(bus_wdata),
    .bus_rdata(),
    .pwm_out(pwm_out)
);

task write;
input [31:0] addr, data;
begin
    bus_addr  = addr;
    bus_wdata = data;
    bus_we    = 1;
    #10 bus_we = 0;
end
endtask

initial begin
    $dumpfile("pwm.vcd");
    $dumpvars(0, pwm_tb);

    #20 rst_n = 1;

    write(32'h04, 20); // PERIOD = 20
    write(32'h08, 10); // DUTY   = 10 (50%)
    write(32'h00, 1);  // CTRL.EN = 1

    #400;
    $finish;
end

endmodule
