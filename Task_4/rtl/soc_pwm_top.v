module soc_pwm_top (
    input  wire clk,
    input  wire rst_n,
    output wire led
);

    // Simple fixed bus values for demo
    wire pwm_out;

    pwm_ip u_pwm (
        .clk(clk),
        .rst_n(rst_n),
        .bus_we(1'b1),          // always enabled
        .bus_addr(32'h00),      // CTRL
        .bus_wdata(32'h01),     // EN = 1
        .bus_rdata(),
        .pwm_out(pwm_out)
    );

    assign led = pwm_out;

endmodule
