`timescale 1ns/1ps

module gcd4_tb;
    reg        clk;
    reg        rst_n;
    reg        start;
    reg  [3:0] in_a;
    reg  [3:0] in_b;
    wire [3:0] gcd;
    wire       done;

    integer pass_count;
    integer fail_count;
    integer cycles;

    gcd4 dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .in_a(in_a),
        .in_b(in_b),
        .gcd(gcd),
        .done(done)
    );

    always #5 clk = ~clk;

    task run_case;
        input [3:0] a;
        input [3:0] b;
        input [3:0] expected;
        begin
            @(negedge clk);
            in_a = a;
            in_b = b;
            start = 1'b1;

            @(negedge clk);
            start = 1'b0;

            cycles = 0;
            while (!done && cycles < 32) begin
                @(negedge clk);
                cycles = cycles + 1;
            end

            if (!done) begin
                fail_count = fail_count + 1;
                $display("FAIL: gcd(%0d,%0d) timed out", a, b);
            end else if (gcd !== expected) begin
                fail_count = fail_count + 1;
                $display("FAIL: gcd(%0d,%0d) expected %0d got %0d",
                         a, b, expected, gcd);
            end else begin
                pass_count = pass_count + 1;
                $display("PASS: gcd(%0d,%0d) = %0d in %0d cycles",
                         a, b, gcd, cycles);
            end

            @(negedge clk);
        end
    endtask

    initial begin
        $dumpfile("results/gcd4_tb.vcd");
        $dumpvars(0, gcd4_tb);

        clk = 1'b0;
        rst_n = 1'b0;
        start = 1'b0;
        in_a = 4'd0;
        in_b = 4'd0;
        pass_count = 0;
        fail_count = 0;
        cycles = 0;

        repeat (3) @(negedge clk);
        rst_n = 1'b1;

        run_case(4'd12, 4'd8,  4'd4);
        run_case(4'd15, 4'd10, 4'd5);
        run_case(4'd7,  4'd3,  4'd1);
        run_case(4'd9,  4'd9,  4'd9);
        run_case(4'd1,  4'd15, 4'd1);
        run_case(4'd14, 4'd6,  4'd2);

        $display("SUMMARY: %0d passed, %0d failed", pass_count, fail_count);
        if (fail_count != 0) begin
            $fatal(1, "GCD testbench failed");
        end
        $finish;
    end
endmodule
