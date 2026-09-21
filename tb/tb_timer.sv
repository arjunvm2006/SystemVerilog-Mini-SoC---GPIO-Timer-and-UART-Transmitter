`timescale 1ns/1ps


module tb_timer;

    logic clk = 0;
    logic rst_n;
    logic enable;
    logic clear;
    logic read_enable;
    logic [31:0] count;
    logic [31:0] read_data;

    timer #(.WIDTH(32)) dut (
        .clk,
        .rst_n,
        .enable,
        .clear,
        .read_enable,
        .count,
        .read_data
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("timer.vcd");
        $dumpvars(0, tb_timer);

        rst_n = 0;
        enable = 0;
        clear = 0;
        read_enable = 0;

        #12 rst_n = 1;

        enable = 1;
        #20;
        assert (count == 32'd2)
            else $fatal(1, "Timer count test failed");

        enable = 0;
        #10;
        assert (count == 32'd2)
            else $fatal(1, "Timer pause test failed");

        clear = 1;
        #10;
        clear = 0;
        assert (count == 32'd0)
            else $fatal(1, "Timer clear test failed");

        read_enable = 1;
        #1;
        assert (read_data == 32'd0)
            else $fatal(1, "Timer read test failed");

        enable = 1;
        #10;
        assert (count == 32'd1)
            else $fatal(1, "Timer restart test failed");

        $display("PASS: Timer peripheral verified.");
        $finish;
    end

endmodule