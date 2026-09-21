`timescale 1ns/1ps

module tb_uart_tx;

    localparam int CLKS_PER_BIT = 4;
    localparam int CLK_PERIOD   = 10;

    logic clk = 0;
    logic rst_n;
    logic start;
    logic [7:0] data_in;
    logic tx;
    logic busy;

    integer i;

    uart_tx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) dut (
        .clk,
        .rst_n,
        .start,
        .data_in,
        .tx,
        .busy
    );

    always #(CLK_PERIOD / 2) clk = ~clk;

    initial begin
        $dumpfile("uart_tx.vcd");
        $dumpvars(0, tb_uart_tx);

        rst_n   = 0;
        start   = 0;
        data_in = 8'h00;

        #12 rst_n = 1;

        // Transmit 0xA5: binary 1010_0101, sent LSB first.
        @(negedge clk);
        data_in = 8'hA5;
        start   = 1;

        @(negedge clk);
        start = 0;

        wait (busy == 1'b1);
        assert (tx == 1'b0)
            else $fatal(1, "UART start bit test failed");

        #(CLKS_PER_BIT * CLK_PERIOD / 2);
        assert (tx == 1'b0)
            else $fatal(1, "UART start bit timing failed");

        for (i = 0; i < 8; i = i + 1) begin
            #(CLKS_PER_BIT * CLK_PERIOD);
            assert (tx == data_in[i])
                else $fatal(1, "UART data bit test failed");
        end

        #(CLKS_PER_BIT * CLK_PERIOD);
        assert (tx == 1'b1)
            else $fatal(1, "UART stop bit test failed");

        wait (busy == 1'b0);

        $display("PASS: UART transmitter verified.");
        $finish;
    end

endmodul\ 