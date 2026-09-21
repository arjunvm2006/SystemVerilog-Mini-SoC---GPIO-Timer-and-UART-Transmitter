`timescale 1ns/1ps

module tb_gpio;

    logic clk = 0;
    logic rst_n;
    logic write_enable;
    logic [7:0] write_data;
    logic read_enable;
    logic [7:0] gpio_in;
    logic [7:0] gpio_out;
    logic [7:0] read_data;

    gpio #(.WIDTH(8)) dut (
        .clk,
        .rst_n,
        .write_enable,
        .write_data,
        .read_enable,
        .gpio_in,
        .gpio_out,
        .read_data
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("gpio.vcd");
        $dumpvars(0, tb_gpio);

        rst_n = 0;
        write_enable = 0;
        write_data = 0;
        read_enable = 0;
        gpio_in = 0;

        #12 rst_n = 1;

        write_enable = 1;
        write_data = 8'hA5;
        #10;
        assert (gpio_out == 8'hA5)
            else $fatal(1, "GPIO write test failed");

        write_data = 8'h3C;
        #10;
        assert (gpio_out == 8'h3C)
            else $fatal(1, "Second GPIO write test failed");

        write_enable = 0;
        gpio_in = 8'h5A;
        read_enable = 1;
        #1;
        assert (read_data == 8'h5A)
            else $fatal(1, "GPIO read test failed");

        $display("PASS: GPIO peripheral verified.");
        $finish;
    end

endmodule