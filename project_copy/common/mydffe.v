//low reset signal resets/clears
//thus clrn
`ifndef mydffe_H
`define mydffe_H
module mydffe(d, clk, clrn, prn, ena, q);
    input d, clk, ena, clrn, prn;
    wire clr;
    wire pr;

    output q;
    reg q;

    assign clr = ~clrn;
    assign pr = ~prn;

    initial
    begin
        q = 1'b0;
    end

    always @(posedge clk or posedge clr) begin
        if (q == 1'bx) begin
            q = 1'b0;
        end else if (clr) begin
            q <= 1'b0;
        end else if (ena) begin
            q <= d;
        end
    end
endmodule
`endif