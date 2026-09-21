module timer #(
    parameter int WIDTH = 32
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic             enable,
    input  logic             clear,
    input  logic             read_enable,
    output logic [WIDTH-1:0] count,
    output logic [WIDTH-1:0] read_data
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= '0;
        else if (clear)
            count <= '0;
        else if (enable)
            count <= count + 1'b1;
    end

    always_comb begin
        read_data = '0;
        if (read_enable)
            read_data = count;
    end

endmodule