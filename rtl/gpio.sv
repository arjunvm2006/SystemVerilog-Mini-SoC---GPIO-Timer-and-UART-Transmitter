`timescale 1ns/1ps

module gpio #(
    parameter int WIDTH = 8
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic             write_enable,
    input  logic [WIDTH-1:0] write_data,
    input  logic             read_enable,
    input  logic [WIDTH-1:0] gpio_in,
    output logic [WIDTH-1:0] gpio_out,
    output logic [WIDTH-1:0] read_data
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            gpio_out <= '0;
        else if (write_enable)
            gpio_out <= write_data;
    end

    always_comb begin
        read_data = '0;
        if (read_enable)
            read_data = gpio_in;
    end

endmodule