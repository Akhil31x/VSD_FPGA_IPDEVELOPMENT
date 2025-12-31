module gpio_control_ip (
    input  clk,
    input  rst,
    input  [31:0] addr,
    input  [31:0] write_data,
    output reg [31:0] read_data,
    input  write_enable,
    input  read_enable,
    input  chip_select,
    input  [31:0] gpio_in,           // External GPIO input pins
    output [31:0] gpio_out           // GPIO output pins
);

    // Three internal registers
    reg [31:0] gpio_data_reg;        // Offset 0x00: GPIO output data
    reg [31:0] gpio_dir_reg;         // Offset 0x04: GPIO direction (1=output, 0=input)
    // GPIO_READ at offset 0x08 is combinational, no register needed

    // Address offset decoder
    wire [3:2] addr_offset = addr[3:2];
    
    // Synchronous write logic
    always @(posedge clk) begin
        if (rst) begin
            gpio_data_reg <= 32'h0000_0000;
            gpio_dir_reg  <= 32'h0000_0000;
        end else if (chip_select && write_enable) begin
            case (addr_offset)
                2'b00: gpio_data_reg <= write_data;  // Write to GPIO_DATA
                2'b01: gpio_dir_reg  <= write_data;  // Write to GPIO_DIR
                2'b10: ;                              // GPIO_READ is read-only
                default: ;
            endcase
        end
    end

    // Combinational read logic and GPIO readback
    wire [31:0] gpio_read_value;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : gpio_mux
            // For each pin: if output, use gpio_data; if input, use gpio_in
            assign gpio_read_value[i] = gpio_dir_reg[i] ? gpio_data_reg[i] : gpio_in[i];
        end
    endgenerate

    // Read multiplexer
    always @(*) begin
        if (chip_select && read_enable) begin
            case (addr_offset)
                2'b00: read_data = gpio_data_reg;      // Read GPIO_DATA
                2'b01: read_data = gpio_dir_reg;       // Read GPIO_DIR
                2'b10: read_data = gpio_read_value;    // Read GPIO_READ
                default: read_data = 32'h0000_0000;
            endcase
        end else begin
            read_data = 32'h0000_0000;
        end
    end

    // GPIO output: driven by gpio_data when direction is output
    assign gpio_out = gpio_data_reg & gpio_dir_reg;

endmodule
