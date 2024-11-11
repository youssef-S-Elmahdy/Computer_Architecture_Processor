
module full_adder(input A, input B, input cin, output P, output cout);
    assign {cout,P} = A + B + cin;
endmodule