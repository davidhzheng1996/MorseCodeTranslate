`ifndef decoder32_H
`define decoder32_H//to prevent repeated include
module decoder32(select, out);
	input [4:0] select;
	wire [4:0] select,neg_select;

//generate not signals of the select;
    genvar c;
      generate
      for (c = 0; c <= 4; c = c + 1) begin: loop1
      		not n(neg_select[c],select[c]);
      end
    endgenerate	

	output [31:0] out;

	and a0(out[0],  neg_select[4],neg_select[3],neg_select[2],neg_select[1],neg_select[0]);
    and a1(out[1],  neg_select[4],neg_select[3],neg_select[2],neg_select[1],    select[0]);
    and a2(out[2],  neg_select[4],neg_select[3],neg_select[2],    select[1],neg_select[0]);
    and a3(out[3],  neg_select[4],neg_select[3],neg_select[2],    select[1],    select[0]);
    and a4(out[4],  neg_select[4],neg_select[3],    select[2],neg_select[1],neg_select[0]);
    and a5(out[5],  neg_select[4],neg_select[3],    select[2],neg_select[1],    select[0]);
    and a6(out[6],  neg_select[4],neg_select[3],    select[2],    select[1],neg_select[0]);
    and a7(out[7],  neg_select[4],neg_select[3],    select[2],    select[1],    select[0]);
    and a8(out[8],  neg_select[4],    select[3],neg_select[2],neg_select[1],neg_select[0]);
    and a9(out[9],  neg_select[4],    select[3],neg_select[2],neg_select[1],    select[0]);
    and a10(out[10],neg_select[4],    select[3],neg_select[2],    select[1],neg_select[0]);
    and a11(out[11],neg_select[4],    select[3],neg_select[2],    select[1],    select[0]);
    and a12(out[12],neg_select[4],    select[3],    select[2],neg_select[1],neg_select[0]);
    and a13(out[13],neg_select[4],    select[3],    select[2],neg_select[1],    select[0]);
    and a14(out[14],neg_select[4],    select[3],    select[2],    select[1],neg_select[0]);
    and a15(out[15],neg_select[4],    select[3],    select[2],    select[1],    select[0]);
    and a16(out[16],    select[4],neg_select[3],neg_select[2],neg_select[1],neg_select[0]);
    and a17(out[17],    select[4],neg_select[3],neg_select[2],neg_select[1],    select[0]);
    and a18(out[18],    select[4],neg_select[3],neg_select[2],    select[1],neg_select[0]);
    and a19(out[19],    select[4],neg_select[3],neg_select[2],    select[1],    select[0]);
    and a20(out[20],    select[4],neg_select[3],    select[2],neg_select[1],neg_select[0]);
    and a21(out[21],    select[4],neg_select[3],    select[2],neg_select[1],    select[0]);
    and a22(out[22],    select[4],neg_select[3],    select[2],    select[1],neg_select[0]);
    and a23(out[23],    select[4],neg_select[3],    select[2],    select[1],    select[0]);
    and a24(out[24],    select[4],    select[3],neg_select[2],neg_select[1],neg_select[0]);
    and a25(out[25],    select[4],    select[3],neg_select[2],neg_select[1],    select[0]);
    and a26(out[26],    select[4],    select[3],neg_select[2],    select[1],neg_select[0]);
    and a27(out[27],    select[4],    select[3],neg_select[2],    select[1],    select[0]);
    and a28(out[28],    select[4],    select[3],    select[2],neg_select[1],neg_select[0]);
    and a29(out[29],    select[4],    select[3],    select[2],neg_select[1],    select[0]);
    and a30(out[30],    select[4],    select[3],    select[2],    select[1],neg_select[0]);
    and a31(out[31],    select[4],    select[3],    select[2],    select[1],	select[0]);
endmodule
`endif