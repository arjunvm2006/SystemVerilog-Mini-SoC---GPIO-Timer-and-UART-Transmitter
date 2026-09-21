`timescale 1ns/1ps

module soc_top (
    input  logic        clk,
    input  logic        rst_n,

    // GPIO peripheral interface
    input  logic        gpio_write_enable,
    input  logic [7:0]  gpio_write_data,
    input  logic        gpio_read_enable,
    input  logic [7:0]  gpio_in,
    output logic [7:0]  gpio_out,
    output logic [7:0]  gpio_read_data,

    // Timer peripheral interface
    input  logic        timer_enable,
    input  logic        timer_clear,
    input  logic        timer_read_enable,
    output logic [31:0] timer_count,
    output logic [31:0] timer_read_data,

    // UART transmitter interface
    input  logic        uart_start,
    input  logic [7:0]  uart_data,
    output logic        uart_tx,
    output logic        uart_busy
);

    gpio #(
        .WIDTH(8)
    ) gpio_inst (
        .clk          (clk),
        .rst_n        (rst_n),
        .write_enable (gpio_write_enable),
        .write_data   (gpio_write_data),
        .read_enable  (gpio_read_enable),
        .gpio_in      (gpio_in),
        .gpio_out     (gpio_out),
        .read_data    (gpio_read_data)
    );

    timer #(
        .WIDTH(32)
    ) timer_inst (
        .clk         (clk),
        .rst_n       (rst_n),
        .enable      (timer_enable),
        .clear       (timer_clear),
        .read_enable (timer_read_enable),
        .count       (timer_count),
        .read_data   (timer_read_data)
    );

    uart_tx #(
        .CLKS_PER_BIT(4)
    ) uart_inst (
        .clk     (clk),
        .rst_n   (rst_n),
        .start   (uart_start),
        .data_in (uart_data),
        .tx      (uart_tx),
        .busy    (uart_busy)
    );

endmodule