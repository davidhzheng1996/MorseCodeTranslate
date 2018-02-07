
//test change_Reset
//ischanged is high for one clock period when ctrl is asserted at clk rises
//if ctrl asserted not at clk rise, this will take 1.5 clock period
//20171108 fixed bug of reset declaring for 2 cycles
`ifndef changed_new_H
`define changed_new_H//to prevent repeated include

module changed_cycle(ctrl, clk,ischanged);

    input ctrl, clk;
    output ischanged;
    reg ischanged;
	 wire temp;
    // wire ctrl,clrn, prn, ena, ctrl_stored,ctrl_stored_mid,reset;

    // mydffe st(ctrl,clk, , , 1'b1, ctrl_stored_mid);
    // mydffe s(ctrl_stored_mid,clk, , , 1'b1, ctrl_stored);
    // xor axor(ischanged,ctrl,ctrl_stored_mid);
    // and rand(reset,ischanged,ctrl);
    reg [2:0] state;
    initial begin
    	ischanged=0;
    	state=0;
    end

	 or(temp, clk, ~ctrl);
	 
    always @(clk or ctrl) begin
	 //or(temp, clk, ~ctrl);
    	if (temp) begin
    		ischanged=0;
    	end

    	casex(state)
    			2'd0: begin:idle
    				
    				if (ctrl) begin
    					state=1;
    					ischanged=1;
    				end
    			end
    			2'd1: begin:highed
    				if(~ctrl) begin
    					state=0;
    				end
    			end

    	endcase

		
    end
endmodule
`endif