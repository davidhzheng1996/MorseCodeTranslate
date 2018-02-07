//multiplier/divider module
`ifndef multidiv_H
`define multidiv_H//to prevent repeated include
`include "multdiv/multi.v"
`include "common/mydffe.v"
// `include "div.v"
`include "multdiv/div_debug.v"
module multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, 
    clock, data_result, data_exception, data_resultRDY);//,A_abs,B_org,divisor,cur_rem,next_rem,ct,to_store);
    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;

    // output [31:0] B_org,A_abs,divisor,cur_rem,next_rem,to_store;
    // output [4:0] ct;
    output data_exception, data_resultRDY;
    // output data_inputRDY;
    wire clk;
    assign clk=clock;
    //Handles​ ​signed​ ​integers​ ​in​ ​two’s​ ​complement​ ​(e.g.​ ​naive​ ​multiplier,​ ​Booth’s,​ ​
    		//or​ ​modified Booth’s)
	//Handles​ ​32-bit​ ​integers​ ​and​ ​correctly​ ​asserts​ ​a​ ​
		//data_exception​ ​on​ ​overflow
	//Correctly​ ​asserts​ ​the​ ​data_resultRDY​ ​signal​ ​
		//when​ ​a​ ​correct​ ​result​ ​is​ ​produced
	//Correctly​ ​asserts​ ​a​ ​data_exception​ ​on​ ​a​ ​division​ ​by​ ​zero
//wire declaration
    wire[31:0] multi_res,div_res;
    
    wire multi_ovf,multi_ovf_tmp,div0;

    wire multi_rdy,div_rdy;
    
    wire [31:0] A_abs,B_org,cur_rem,to_store,next_rem,to_sub,divisor;
    wire[4:0] shftamt,ct;
    wire myctrl,s_ctrl,done;
    //stores the current operation
    //if either ctrl's asserted, update stored operation
    //crt_op[0] is multi,crt_op[1] is div
    wire [1:0] crt_op;
    mydffe dff_multi(ctrl_MULT,ctrl_MULT|ctrl_DIV,1'b1, , 1'b1, crt_op[0]);
    mydffe dff_div(ctrl_DIV,ctrl_MULT|ctrl_DIV,1'b1, , 1'b1, crt_op[1]);

    // wire[31:0] multi_res,div_res;
    assign data_result=crt_op[0]?multi_res:32'bz;
    assign data_result=crt_op[1]?div_res:32'bz;
    // assign data_result=div_res;
    // wire multi_ovf,multi_ovf_tmp,div0;
    assign multi_ovf_tmp = 1'b0;
    // assign data_exception = 1'b0;//for now
    assign data_exception = crt_op[0]?multi_ovf:1'bz;
    //multi_ovf:{crt_op[1]?div0:1'b0};
    assign data_exception = crt_op[1]?div0:1'bz;

    // wire multi_rdy,div_rdy;
    assign data_resultRDY= crt_op[0]?multi_rdy:crt_op[1]?div_rdy:1'b0;
    // assign div_res = 32'b0;
    multi mt(data_operandA, data_operandB, ctrl_MULT, clk, multi_res, 
        multi_ovf, multi_rdy);
    // div div_ins(data_operandA, data_operandB, ctrl_DIV, clk, div_res, 
    //     div0, div_rdy);
//******div debug instance
    //div debug wires
    // wire [31:0] A_abs,B_org,cur_rem,to_store,next_rem,to_sub,divisor;
    // wire[4:0] shftamt,ct;
    // wire myctrl,s_ctrl,done;
    div div_debug(data_operandA, data_operandB, ctrl_DIV, clk, div_res, 
    div0, div_rdy, ct,A_abs,B_org,shftamt,myctrl,s_ctrl,cur_rem,done,to_store,next_rem,to_sub,divisor);

endmodule
`endif