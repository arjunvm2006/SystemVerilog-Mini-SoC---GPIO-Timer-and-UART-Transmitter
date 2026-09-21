`timescale 1ns/1ps

module tb_soc_top;

    logic clk = 0;
    logic rst_n;

    logic       gpio_write_enable;
    logic [7:0] gpio_write_data;
    logic       gpio_read_enable;
    logic [7:0] gpio_in;
    logic [7:0] gpio_out;
    logic [7:0] gpio_read_data;

    logic        timer_enable;
    logic        timer_clear;
    logic        timer_read_enable;
    logic [31:0] timer_count;
    logic [31:0] timer_read_data;

    logic       uart_start;
    logic [7:0] uart_data;
    logic       uart_tx;
    logic       uart_busy;

    soc_top dut (
        .clk,
        .rst_n,
        .gpio_write_enable,
        .gpio_write_data,
        .gpio_read_enable,
        .gpio_in,
        .gpio_out,
        .gpio_read_data,
        .timer_enable,
        .timer_clear,
        .timer_read_enable,
        .timer_count,
        .timer_read_data,
        .uart_start,
        .uart_data,
        .uart_tx,
        .uart_busy
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("soc_top.vcd");
        $dumpvars(0, tb_soc_top);

        rst_n              = 0;
        gpio_write_enable  = 0;
        gpio_write_data    = 0;
        gpio_read_enable   = 0;
        gpio_in            = 0;
        timer_enable       = 0;
        timer_clear        = 0;
        timer_read_enable  = 0;
        uart_start         = 0;
        uart_data          = 0;

        #12 rst_n = 1;

        // GPIO write and timer start.
        gpio_write_enable = 1;
        gpio_write_data   = 8'hC3;
        timer_enable      = 1;

        #10;
        assert (gpio_out == 8'hC3)
            else $fatal(1, "SoC GPIO write integration test failed");

        assert (timer_count == 32'd1)
            else $fatal(1, "SoC timer integration test failed");

        // GPIO read.
        gpio_write_enable = 0;
        gpio_in           = 8'h5A;
        gpio_read_enable  = 1;

        #1;
        assert (gpio_read_data == 8'h5A)
            else $fatal(1, "SoC GPIO read integration test failed");

        // UART transmission.
        @(negedge clk);
        uart_data  = 8'hA5;
        uart_start = 1;

        @(negedge clk);
        uart_start = 0;

        wait (uart_busy == 1'b1);
        assert (uart_tx == 1'b0)
            else $fatal(1, "SoC UART start integration test failed");

        wait (uart_busy == 1'b0);
        assert (uart_tx == 1'b1)
            else $fatal(1, "SoC UART stop integration test failed");

        // Pause and clear timer.
        timer_enable = 0;

        @(negedge clk);
        timer_clear = 1;

        @(negedge clk);
        timer_clear = 0;

        assert (timer_count == 32'd0)
            else $fatal(1, "SoC timer clear integration test failed");

        $display("PASS: Mini-SoC integration verified.");
        $finish;
    end

endmodule