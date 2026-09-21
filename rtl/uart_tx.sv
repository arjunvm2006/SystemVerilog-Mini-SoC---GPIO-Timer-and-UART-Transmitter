`timescale 1ns/1ps

module uart_tx #(
    parameter int CLKS_PER_BIT = 4
) (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       start,
    input  logic [7:0] data_in,
    output logic       tx,
    output logic       busy
);

    localparam int COUNT_WIDTH = (CLKS_PER_BIT <= 1) ? 1 : $clog2(CLKS_PER_BIT);

    typedef enum logic [1:0] {
        IDLE,
        START_BIT,
        DATA_BITS,
        STOP_BIT
    } state_t;

    state_t state;
    logic [COUNT_WIDTH-1:0] baud_count;
    logic [2:0] bit_index;
    logic [7:0] data_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= IDLE;
            tx         <= 1'b1;
            busy       <= 1'b0;
            baud_count <= '0;
            bit_index  <= '0;
            data_reg   <= '0;
        end else begin
            case (state)
                IDLE: begin
                    tx         <= 1'b1;
                    busy       <= 1'b0;
                    baud_count <= '0;
                    bit_index  <= '0;

                    if (start) begin
                        data_reg <= data_in;
                        tx       <= 1'b0;
                        busy     <= 1'b1;
                        state    <= START_BIT;
                    end
                end

                START_BIT: begin
                    if (baud_count == CLKS_PER_BIT - 1) begin
                        baud_count <= '0;
                        bit_index  <= '0;
                        tx         <= data_reg[0];
                        state      <= DATA_BITS;
                    end else begin
                        baud_count <= baud_count + 1'b1;
                    end
                end

                DATA_BITS: begin
                    if (baud_count == CLKS_PER_BIT - 1) begin
                        baud_count <= '0;

                        if (bit_index == 3'd7) begin
                            tx    <= 1'b1;
                            state <= STOP_BIT;
                        end else begin
                            bit_index <= bit_index + 1'b1;
                            tx        <= data_reg[bit_index + 1'b1];
                        end
                    end else begin
                        baud_count <= baud_count + 1'b1;
                    end
                end

                STOP_BIT: begin
                    if (baud_count == CLKS_PER_BIT - 1) begin
                        baud_count <= '0;
                        tx         <= 1'b1;
                        busy       <= 1'b0;
                        state      <= IDLE;
                    end else begin
                        baud_count <= baud_count + 1'b1;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule