`timescale 1 ns/ 100 ps
module processor_tb();
	
	//inputs to or gate are wire types.
	reg clock, reset, morse;
	wire[31:0] ASCII_out;
	wire decode_end;
//	wire[31:0] multA, multB;
//	wire[31:0] aluout, wdata1, multout;
//	wire [31:0] dmemcheck, regval;
//	wire[31:0] xdataB, pcout, /*executepctest,*/ xdataA;
//	//wire branchsuc, bnetest;
//	wire multdetect, multreadynow;
//	//wire testex, setxsuc;
//	wire [31:0] finstruction;
	wire[31:0] cur_PC,result,imem_instruction,imem_instruction1;
	// wire msgend;
	// processor my_processor(clock, reset, morse, data_in, data_address, pcout, bsuc, msgend);
	processor my_processor(clock, reset, morse, ASCII_out, decode_end);


	assign cur_PC=my_processor.current_pc;
	assign result = my_processor.alu_result;
	assign imem_instruction= my_processor.imem_instruction;
	assign imem_instruction1= my_processor.imem_instruction1;
	
	parameter wid=32;
	wire [wid-1:0] value0,value1,value2,value3,value4;
assign value0 = my_processor.my_morse_rec.value[31:0];
assign value1 = my_processor.my_morse_rec.value[63:32];
assign value2 = my_processor.my_morse_rec.value[3*wid-1:2*wid];
assign value3 = my_processor.my_morse_rec.value[4*wid-1:3*wid];
assign value4 = my_processor.my_morse_rec.value[5*wid-1:4*wid];
	
	wire branch_success=my_processor.branch_success;
	wire [31:0] data_write_register;
	assign data_write_register=my_processor.D_WR;
	wire [31:0] A,B;
	assign A=my_processor.rs_val_x_b;
	assign B=my_processor.B_x;
	wire [4:0] reg_A,reg_B;
	assign reg_A=my_processor.rs_x;
	assign reg_B=my_processor.r_reg2_x;
//	r_reg2
//	rs_val_d, rt_or_rd_val_d
	initial 

//	
	begin
			$dumpfile("processor_wave.vcd");
			$dumpvars(0, processor_tb);
        $display("<< Test processor >>");	
        // $monitor("time=%3d, alu/exe_result=%c",$time,result);
        $monitor("time=%3d, decoded letter is =%c",$time,result);	  		  
        clock = 1'b0; 
		  morse = 1'b0; 
		  reset = 1'b1;
		  #11
		  reset = 1'b0;
		  #120
		  morse = 1'b1;
		  #2400
		  morse = 1'b0;
		  #100
		  morse = 1'b1;
		  #2400
		  morse = 1'b0;
		  #100
		  morse = 1'b1;
		  #2400
		  morse = 1'b0;
		  #100
		  morse = 1'b1;
		  #2400
		  morse = 1'b0;
		  #100
		  morse = 1'b1;
		  #2400
		  morse = 1'b0;
		  #4000
		  

        $stop;
    end

	 
	 // Clock generator
    always
    #10     clock = ~clock;
	
endmodule
