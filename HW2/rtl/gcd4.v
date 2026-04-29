`timescale 1ns/1ps

module gcd4 (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       start,
    input  wire [3:0] in_a,
    input  wire [3:0] in_b,
    output reg  [3:0] gcd,
    output reg        done
);
    localparam [1:0] S_IDLE = 2'd0;
    localparam [1:0] S_RUN  = 2'd1;
    localparam [1:0] S_DONE = 2'd2;

    reg [1:0] state;
    reg [3:0] a_reg;
    reg [3:0] b_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_IDLE;
            a_reg <= 4'd0;
            b_reg <= 4'd0;
            gcd   <= 4'd0;
            done  <= 1'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        a_reg <= in_a;
                        b_reg <= in_b;
                        state <= S_RUN;
                    end
                end

                S_RUN: begin
                    if (a_reg == 4'd0) begin
                        gcd   <= b_reg;
                        done  <= 1'b1;
                        state <= S_DONE;
                    end else if (b_reg == 4'd0) begin
                        gcd   <= a_reg;
                        done  <= 1'b1;
                        state <= S_DONE;
                    end else if (a_reg == b_reg) begin
                        gcd   <= a_reg;
                        done  <= 1'b1;
                        state <= S_DONE;
                    end else if (a_reg > b_reg) begin
                        a_reg <= a_reg - b_reg;
                    end else begin
                        b_reg <= b_reg - a_reg;
                    end
                end

                S_DONE: begin
                    if (!start) begin
                        done  <= 1'b0;
                        state <= S_IDLE;
                    end
                end

                default: begin
                    state <= S_IDLE;
                    done  <= 1'b0;
                end
            endcase
        end
    end
endmodule
