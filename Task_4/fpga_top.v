module fpga_top (
    output wire led
);

    // Internal oscillator
    wire clk;
    SB_HFOSC #(
        .CLKHF_DIV("0b10") // ~12 MHz
    ) hfosc (
        .CLKHFEN(1'b1),
        .CLKHFPU(1'b1),
        .CLKHF(clk)
    );

    // Simple blink to verify clock works
    reg [23:0] cnt = 0;

    always @(posedge clk) begin
        cnt <= cnt + 1;
    end

    // Toggle LED slowly
    assign led = cnt[23];

endmodule
