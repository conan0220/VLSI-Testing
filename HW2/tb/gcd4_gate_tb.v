`timescale 1ns / 1ps

module testbench;
    parameter period = 2;
    parameter delay = 1;

    reg [3:0] number1, number2;
    reg clk, rst_n, start;
    wire [3:0] gcd_out;
    wire done;

    integer pass_count;
    integer fail_count;

    gcd4 u1 (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .in_a(number1),
        .in_b(number2),
        .gcd(gcd_out),
        .done(done)
    );

    initial begin
        $sdf_annotate("results/dc/gcd4_syn.sdf", u1);
        $dumpfile("results/gcd4_syn.vcd");
        $dumpvars(0, testbench);
`ifdef FSDB
        $fsdbDumpfile("results/gcd4_syn.fsdb");
        $fsdbDumpvars;
`endif
    end

    always #(period / 2) clk = ~clk;

    task run_case;
        input [3:0] a;
        input [3:0] b;
        input [3:0] expected;
        begin
            @(posedge clk);
            #(delay) start = 1;
            number1 = a;
            number2 = b;
            #(period) start = 0;

            @(posedge done);
            if (gcd_out !== expected) begin
                fail_count = fail_count + 1;
                $display("FAIL: gcd(%0d,%0d) expected %0d got %0d",
                         a, b, expected, gcd_out);
            end else begin
                pass_count = pass_count + 1;
                $display("PASS: gcd(%0d,%0d) = %0d", a, b, gcd_out);
            end

            @(negedge done);
        end
    endtask

    initial begin
        clk = 1;
        rst_n = 1;
        start = 0;
        number1 = 0;
        number2 = 0;
        pass_count = 0;
        fail_count = 0;

        #(period + delay) rst_n = 0;
        #(period * 2) rst_n = 1;

        run_case(4'd12, 4'd8,  4'd4);
        run_case(4'd15, 4'd10, 4'd5);
        run_case(4'd7,  4'd3,  4'd1);
        run_case(4'd9,  4'd9,  4'd9);
        run_case(4'd1,  4'd15, 4'd1);
        run_case(4'd14, 4'd6,  4'd2);

        @(posedge clk);
        #(delay * 3) rst_n = 0;
        #(period * 8);

        $display("SUMMARY: %0d passed, %0d failed", pass_count, fail_count);
        if (fail_count != 0) begin
            $display("Gate-level simulation failed");
        end
        $finish;
    end

    initial begin
        #200;
        $display("Simulation timeout");
        $finish;
    end
endmodule
