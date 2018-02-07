`ifndef mydmem_H
`define mydmem_H
//haven't added valid flag
module mydmem_mod(
        address,      // address of data
        clock  ,             // may need to invert the clock
        data   , // data you want to write
        wren   ,    // write enable
        value  ,
        q        // data from dmem
    );
parameter wid=32;
input [11:0] address;
input clock,wren;
input [31:0] data,value;
output [31:0] q;

reg [31:0] q;
wire [5*wid-1:0] value;

// `ifdef test


// assign value[31:0]=1;
// assign value[63:32]=2;
// assign value[3*wid-1:2*wid]=3;
// assign value[4*wid-1:3*wid]=4;
// assign value[5*wid-1:4*wid]=5;
// `endif

	initial begin
		q=0;
	end
	always @(*) begin
		casex(address)
			12'd0: begin:case0
				q = 0;
			end
			12'd1: begin:case1
				q = value[31:0];
			end
			12'd2: begin:case2
				q = value[63:32];
			end
			12'd3: begin:case3
				q = value[3*wid-1:2*wid];
			end
			12'd4: begin:case4
				q = value[4*wid-1:3*wid];
			end
			12'd5: begin:case5
				q = value[5*wid-1:4*wid];
			end
			default: begin: dcase
				q=0;
			end
		endcase

	end
endmodule
`endif