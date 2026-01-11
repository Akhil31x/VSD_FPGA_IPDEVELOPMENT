module pwm_ip (
    input  wire        clk,
    input  wire        rst_n,

    input  wire        bus_we,
    input  wire [31:0] bus_addr,
    input  wire [31:0] bus_wdata,
    output reg  [31:0] bus_rdata,

    output reg         pwm_out
);

    localparam CTRL   = 32'h00;
    localparam PERIOD = 32'h04;
    localparam DUTY   = 32'h08;
    localparam STATUS = 32'h0C;

    reg        en;
    reg        pol;
    reg [31:0] period_reg;
    reg [31:0] duty_reg;
    reg [31:0] cnt;

    // Register write
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en         <= 0;
            pol        <= 0;
            period_reg <= 1;
            duty_reg   <= 0;
        end else if (bus_we) begin
            case (bus_addr)
                CTRL: begin
                    en  <= bus_wdata[0];
                    pol <= bus_wdata[1];
                end
                PERIOD: if (bus_wdata >= 1)
                    period_reg <= bus_wdata;
                DUTY:
                    duty_reg <= bus_wdata;
            endcase
        end
    end

    // PWM counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 0;
        else if (!en)
            cnt <= 0;
        else if (cnt == period_reg - 1)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end

    // PWM output
    always @(*) begin
        if (!en)
            pwm_out = pol ? 1'b1 : 1'b0;
        else if (cnt < duty_reg)
            pwm_out = pol ? 1'b0 : 1'b1;
        else
            pwm_out = pol ? 1'b1 : 1'b0;
    end

    // Register read
    always @(*) begin
        case (bus_addr)
            CTRL:   bus_rdata = {30'd0, pol, en};
            PERIOD: bus_rdata = period_reg;
            DUTY:   bus_rdata = duty_reg;
            STATUS: bus_rdata = cnt;
            default: bus_rdata = 32'd0;
        endcase
    end

endmodule
