module gpio_output_ip (
    input  clk,
    input  rst,
    input  [31:0] addr,
    input  [31:0] write_data,
    output reg [31:0] read_data,
    input  write_enable,
    input  read_enable,
    input  chip_select,
    output [31:0] gpio_out
);

    reg [31:0] gpio_register;

    // Synchronous write + reset
    always @(posedge clk) begin
        if (rst)
            gpio_register <= 32'h0000_0000;
        else if (chip_select && write_enable)
            gpio_register <= write_data;
    end

    // Combinational read
    always @(*) begin
        if (chip_select && read_enable)
            read_data = gpio_register;
        else
            read_data = 32'h0000_0000;
    end

    assign gpio_out = gpio_register;

endmodule
