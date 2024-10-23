module fa (input a, b, cin, output cout, sum);

    wire s1, net1, net2;

    xor (s1, a, b);
    and (net1, a, b);

    xor (sum, s1, cin);
    and (net2, s1, cin);

    or (cout, net1, net2);

endmodule

module tb;
    reg a, b, cin;
    wire cout, sum;
    integer i;

    fa u0 (.a(a), .b(b), .cin(cin), .cout(cout), .sum(sum));

    initial begin
        {a, b, cin} <= 0;

        $monitor ("[T=%0t] a=%0b b=%0b cin=%0b cout=%0b sum=%0b");

        for (i = 0; i < 10; i = i + 1) begin
            #1;
            a <= $random;
            b <= $random;
            cin <= $random;
        end
    end
endmodule