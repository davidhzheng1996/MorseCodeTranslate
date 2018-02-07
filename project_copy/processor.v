/**
 * The processor takes in two inputs and returns two outputs
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Outputs
 * dmem_data_in: this should connect to the wire that feeds in data to your dmem
 * dmem_address: this should be the address of data that you write data to
 *
 * Notes
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
`ifndef Processor_H
`define Processor_H//to prevent repeated include
//`include "common/"
`include "alu/alu.v"
`include "common/changed.v"
`include "paramd_reg/reg_n.v"
`include "reg_file/regfile.v"
`include "multdiv/multdiv.v"
`include "timer/morse_rec.v"
`include "common/changed_cycle.v"
`include "mydmem.v"
module processor(clock, reset, morse, ASCII_out, decode_end);
    input clock, reset, morse;


	output [31:0] ASCII_out;
	output decode_end;
//reg_n #(.N(32)) a32(clk,rst,A, result);
    wire [31:0] next_pc,current_pc,ASCII_out;
    wire nrst,clk,rst,decode_end;
    assign rst = reset;
    assign nrst = ~rst;
    assign clk = clock ;



//wire declaration in advance

//************
//fetch stage
    wire [31:0] imem_instruction,fd_instruction;
    //PC handling for fd latch, next pc and cur pc for the fd latch
    wire [31:0] next_pc_fd,current_pc_fd, 
            fd_PC_in,fd_PC_out;
    wire [20:0] decoded_instr_f;
    wire j_f,jal_f;
	wire [31:0] jr_f29, jal_f29;
    wire [26:0] T_f;
	wire msg_end, m_end;
	wire valid_morse;
	// assign msg_end = 1'b0;
//************
//decode stage
    wire [20:0] decoded_instr_d;
    wire R_type_d,addi_d,sw_d,lw_d,j_d,bne_d,jal_d,jr_d,blt_d,bex_d,setx_d;

    wire c_WE;//write enable from the writeback
    wire [4:0] c_WR;
    //c_WR, ctrl_writeregister is assigned in writeback stage
    wire [31:0] D_WR, dataout_29, temp;
    
	 assign temp = 32'b0;
    //data to write to register, determined in the writeback stage
    wire WE_d;
    wire [4:0] rs_d,rt_d,rd_d,r_reg2,opcode_d;
    wire [31:0] rs_val_d,rt_or_rd_val_d,rt_val_d,rd_val_d;
    wire reg2_is_rt,reg2_is_rd;
    wire [26:0] T_d;

    wire[4:0] alu_code_d;
    wire two_md;
    wire nop_to_dx;
    wire mult_d,div_d;
//************
//execute stage
    wire [20:0] decoded_instr_x;
    wire R_type_x,addi_x,sw_x,lw_x,j_x,bne_x,jal_x,jr_x,blt_x,bex_x,setx_x;
    
    wire WE_x;
    wire[4:0] rs_x,rd_x,rt_x;
    wire [26:0] T_x;
    wire [31:0] PC_x;
    wire [31:0] rs_val_x,rt_val_x,rd_val_x;

    wire isNotEqual, isLessThan, overflow;
    wire [4:0] alu_code,shftamt;
    wire [31:0] B_x,alu_result,exe_result,result_x,result_m;
    wire [31:0] N;//sign extended
    
    //for multdiv
    wire ctrl_MULT, ctrl_DIV,is_RDY,md_exception;
    wire [31:0] data_A,data_B,data_result;
    //controls
    wire stall_for_md,stall_for_mult,stall_for_div,is_RDY_delayed;
    wire mult_x,div_x;


//************
//memory stage
    wire [20:0] decoded_instr_m;
    wire R_type_m,addi_m,sw_m,lw_m,j_m,bne_m,jal_m,jr_m,blt_m,bex_m,setx_m; 
    
    wire WE_m;
    wire read_mem,write_mem;
    wire [4:0] rd_m;
    wire [31:0] mem_data_m;
    wire [31:0] rd_val_m;
    //wire [31:0] mem_data;

//************
//writeback stage
    wire [20:0] decoded_instr_w;
    wire R_type_w,addi_w,sw_w,lw_w,j_w,bne_w,jal_w,jr_w,blt_w,bex_w,setx_w; 

    wire WE_w;
    wire [4:0] rd_w;
    wire [31:0] result_w,mem_data_w;
    
//************
//global
wire branch_success;
//branch_success indicates a jump action
assign branch_success=(bne_x&isNotEqual)|(blt_x&(~isLessThan)&isNotEqual);
assign bsuc = branch_success;
// isNotEqual, is($rs)LessThan($rd), overflow
//so $rd<$rs = (!($rs<$rd))&isNotEqual
wire stall_f,stall_d;
//stall logic for fetch stage and decode stage
//if stall in a stage, pass nop to next stage
wire stall_logic;
wire data_dependency, hazard;
// assign branch_or_j = 1'b0;
wire [31:0] j_PC;

wire stop_PC_latch, stop_fd_latch, stop_dx_latch;
assign stop_PC_latch = stop_fd_latch;
assign stop_fd_latch = stop_dx_latch|two_md;
assign stop_dx_latch = stall_for_md;//or mem dependency

//should actaully be call stall
assign data_dependency = 1'b0;
                        // ((rd_x!==0)&&((rs_d===rd_x)||(r_reg2===rd_x)))||
                        // ((rd_m!==0)&&((rs_d===rd_m)||(r_reg2===rd_m)));

//******************* Fetch 
//*****************good for now
//change PC to corresponding
    pc_reg cur_next_pc(clock,nrst,next_pc,current_pc,stop_PC_latch);
    wire[31:0] imem_instruction1;
    //imeme is instruction in and fd is instruction out
    //get imem_instr based on pc
    imem myimem(
        .address    (current_pc[11:0]),       // address of data
        .clken      (1'b1),      // clock enable (optional)
        .clock      (~clock),                  // may need to invert the clock
        .q          (imem_instruction1) // the raw instruction
    );
	 
	wire [5*32-1:0] value;
	morse_rec my_morse_rec(clk, morse, reset, m_end,value, valid_morse);
	
	changed_cycle my_changed_cycle(m_end, clk, msg_end);
	
	assign jal_f29 = 32'b00011000000000000000000001100100;
    //jal 100?
	assign imem_instruction = msg_end ? jal_f29: imem_instruction1;
	// assign msgend = msg_end;
    //determin if current op is j or jal, if so jump
    op_decoder op_decoder_f_stage(imem_instruction[31:27],decoded_instr_f);
    assign j_f      = decoded_instr_f[4];
    assign jal_f    = decoded_instr_f[6];
    assign T_f      = imem_instruction[26:0];
	assign jr_f29 	  = 32'b0010011101;
	
	 
    //calculate current pc+1
    wire [31:0] cur_PC_plus_1;
    Adder32 add_currentPC_and_1(current_pc,32'd1,1'b0,cur_PC_plus_1,);
    //calculate pcx+N
    wire [31:0] PCX_plus_N;
    Adder32 add_pcx_and_N(PC_x,N,1'b0,PCX_plus_N,);
    // assign N = {5'b0,T_f};
    //covered every case except stall implementation
    //but doesn't matter cuz stall just stops the latches
    assign next_pc = branch_success?(PCX_plus_N):
                    jr_d?rd_val_d:
                    (j_f|jal_f)?{5'b0,T_f}:
                    cur_PC_plus_1;
	assign pcout = next_pc;
    //j_PC:fd_PC_in;//(current_pc+1);
    assign fd_PC_in = cur_PC_plus_1;//this is fine with hazard
    //replace PC+1 with adder

    wire [31:0] fd_instruction_in;
	 wire random = 1'b1;
    //if data_dependency|jr_d|branch_success do nop
    assign fd_instruction_in = (jr_d|branch_success)? 32'd0:
                               imem_instruction;
    //wire f_instruction
    fd_latch fd_latch0(clk,nrst,fd_PC_in,fd_PC_out,
                fd_instruction_in,fd_instruction,stop_fd_latch);

//******************* Decode
//need a opcode decoder DONE
//WE_d,WE_x,
//rstatus
    
    assign opcode_d = fd_instruction[31:27];
    assign T_d = fd_instruction[26:0];
    assign rd_d = fd_instruction[26:22];
    assign rs_d = fd_instruction[21:17];
    assign rt_d = fd_instruction[16:12];
    
    //decode instruction
    //need a opcode decoder
    op_decoder op_decoder_d_stage(opcode_d,decoded_instr_d);
    
    assign R_type_d = decoded_instr_d[0];
    assign addi_d   = decoded_instr_d[1];
    assign sw_d     = decoded_instr_d[2];
    assign lw_d     = decoded_instr_d[3];
    assign j_d      = decoded_instr_d[4];
    assign bne_d    = decoded_instr_d[5];
    assign jal_d    = decoded_instr_d[6];
    assign jr_d     = decoded_instr_d[7];
    assign blt_d    = decoded_instr_d[8];
    assign bex_d    = decoded_instr_d[9];
    assign setx_d   = decoded_instr_d[10];


    //first register to read is always rs
    //second register to read is 
    //rt if opcode is 00000 (R-type)
    //rd if operation is sw|lw|bne|blt|jr
            //opcode is 00100 00111 01000 00010 00110
    //rstatus if bex
    assign reg2_is_rd = (sw_d|lw_d|bne_d|blt_d|jr_d);
    assign reg2_is_rt = R_type_d;
    assign r_reg2 = reg2_is_rt?rt_d:
                    reg2_is_rd?rd_d:
                    bex_d?5'd30:5'bzzzzz;
    assign rt_val_d = reg2_is_rt?rt_or_rd_val_d:32'bz;
    assign rd_val_d = reg2_is_rd?rt_or_rd_val_d:32'bz;

    //data write register, rs val rt val
    regfile rf(~clk,c_WE,rst, c_WR,
            rs_d, r_reg2, D_WR,
            rs_val_d, rt_or_rd_val_d, temp, dataout_29);

//morse code related data output
    assign ASCII_out = {1'b0,dataout_29};
    assign decode_end = dataout_29[31];

    assign alu_code_d = T_d[6:2];
    assign mult_d = (alu_code_d===5'b00110);
    assign div_d = (alu_code_d===5'b00111);

    //need to write to register if the operation is 
    //R or addi or lw or jal or setx
    assign WE_d= R_type_d|addi_d|lw_d|jal_d|setx_d;
    
    //if both op_d & op_x are mult/div, insert nop
    assign two_md = (mult_x&mult_d)|(div_d&div_x);
    //if data_dependency|branch_success, write nop to latch
    assign nop_to_dx = two_md|branch_success;

    wire [20:0] decoded_instr_d_in;
    wire WE_d_in;
    wire [4:0] rd_d_in;
    wire [31:0] rs_val_d_in,rt_val_d_in,rd_val_d_in;
    wire [26:0] T_d_in;

    assign  rd_d_in     = nop_to_dx?5'd0 :rd_d ;
    assign  T_d_in      = nop_to_dx?27'd0:T_d ;
    assign  rs_val_d_in = nop_to_dx?32'd0:rs_val_d;
    assign  rt_val_d_in = nop_to_dx?32'd0:rt_val_d;
    assign  rd_val_d_in = nop_to_dx?32'd0:rd_val_d;
    assign  WE_d_in     = nop_to_dx?1'd0 :WE_d ;
    assign  decoded_instr_d_in = nop_to_dx?21'd1:decoded_instr_d;

    dx_latch dx_latch0(clk,nrst,  fd_PC_out,PC_x,
                rd_d_in,rd_x,  T_d_in,T_x,
                rs_val_d_in,rs_val_x,   rt_val_d_in,rt_val_x,
                rd_val_d_in,rd_val_x,   WE_d_in,WE_x,
                decoded_instr_d_in,decoded_instr_x,stop_dx_latch);

//******************* eXecute
//need to use isNotEqual, isLessThan, overflow;
    assign R_type_x = decoded_instr_x[0];
    assign addi_x   = decoded_instr_x[1];
    assign sw_x     = decoded_instr_x[2];
    assign lw_x     = decoded_instr_x[3];
    assign j_x      = decoded_instr_x[4];
    assign bne_x    = decoded_instr_x[5];
    assign jal_x    = decoded_instr_x[6];
    assign jr_x     = decoded_instr_x[7];
    assign blt_x    = decoded_instr_x[8];
    assign bex_x    = decoded_instr_x[9];
    assign setx_x   = decoded_instr_x[10];
    //Operand A for alu is always $rs
    //Operand B for alu is
        //N if lw|sw|addi
        //$rt if R type
        //$rd if bne|blt

//----------------------------------
    wire [4:0] r_reg1_x,r_reg2_x;
    assign r_reg1_x = T_x[21:17];//rs
    // assign rd_x = T_x[26:22];
    //rd_x has been declared previously, and is latchedhere as well
    assign rs_x = T_x[21:17];
    assign rt_x = T_x[16:12];
    //not really needed
    assign r_reg2_x = R_type_x?rt_x:
                        (sw_x|lw_x|bne_x|blt_x|jr_x)?
                        rd_x:bex_x?5'd30:5'bzzzzz;

    //bypassed version of A
    wire [31:0] rt_val_x_b,rd_val_x_b,rs_val_x_b;
    wire R_or_addi_m;
    assign R_or_addi_m = R_type_m|addi_m;
    wire R_or_addi_w;
    assign R_or_addi_w = R_type_w|addi_w;
	 
//	 wire R_or_addi_or_lw_m;
//    assign R_or_addi_or_lw_m = R_type_m|addi_m|lw_m;
//	 
//	 wire R_or_addi_or_lw_w;
//    assign R_or_addi_or_lw_w = R_type_w|addi_w|lw_w;

///**/**************
///**/these by pass only supports R/Addi in m/w, 
///**/does not support lw

    assign rs_val_x_b = (R_or_addi_m&&(rs_x===rd_m))?result_m:
                        (lw_m&(rs_x===rd_m))?mem_data_m:
                        (c_WE&&(rs_x===c_WR))?D_WR:
                        rs_val_x;

    assign rt_val_x_b = (R_or_addi_m&&(rt_x===rd_m))?result_m:
                        (lw_m&(rt_x===rd_m))?mem_data_m:
                        (c_WE&&(rt_x===c_WR))?D_WR:
                        rt_val_x;

    assign rd_val_x_b = (R_or_addi_m&&(rd_x===rd_m))?result_m:
                        (lw_m&(rd_x===rd_m))?mem_data_m:
                        (c_WE&&(rd_x===c_WR))?D_WR:
                        rd_val_x;

    assign N = {{16{T_x[16]}},T_x[15:0]};
    assign B_x = R_type_x?rt_val_x_b:
            (bne_x|blt_x)?rd_val_x_b:
            (lw_x|sw_x|addi_x)?N:32'b0;

    // assign B_x = R_type_x?rt_val_x:
    //          (bne_x|blt_x)?rd_val_x:
    //          (lw_x|sw_x|addi_x)?N:32'b0;

    assign alu_code = (addi_x|sw_x|lw_x)? 5'd00000:T_x[6:2];
    assign shftamt = T_x[11:7];
    alu alu_1(rs_val_x_b, B_x, alu_code, shftamt,
        alu_result, isNotEqual, isLessThan, overflow);

//multidiv part
    assign data_A = rs_val_x_b;
    assign data_B = rt_val_x_b;
    assign mult_x = R_type_x&(alu_code===5'b00110);
    assign div_x = R_type_x&(alu_code===5'b00111);
    //use is changed to produce ctrl_mult
    //ctrl_mult asserts high for one cycle as soon as mult_x is asserted
    changed ch(mult_x, clk, ,ctrl_MULT);
    assign ctrl_DIV = 1'b0;
    //is_RDY_delayed is one cycle after is_RDY
    reg_n #(.N(1)) ctrl_mult_reg(clk,nrst,1'b1,is_RDY, is_RDY_delayed);

    assign stall_for_md = (stall_for_mult|stall_for_div)===1'b1;
    assign stall_for_mult=((ctrl_MULT|(~is_RDY_delayed))&mult_x)===1'b1;

    multdiv multdiv_ut(data_A, data_B, ctrl_MULT, ctrl_DIV, clk,
        data_result, md_exception, is_RDY);


//ignore multdiv for now, so result is just alu result
    assign exe_result = ~(mult_x|div_x)?alu_result:data_result;
    assign result_x = jal_x?PC_x:exe_result;
    //if jal, pass over PC+1
    //if setx, pass over TBD
    xm_latch xm_latch0(clk,nrst, result_x,result_m,
                        rd_val_x,rd_val_m, rd_x,rd_m, WE_x,WE_m,
                        decoded_instr_x,decoded_instr_m);


//******************* Memory
    
    assign R_type_m = decoded_instr_m[0];
    assign addi_m   = decoded_instr_m[1];
    assign sw_m     = decoded_instr_m[2];
    assign lw_m     = decoded_instr_m[3];
    assign j_m      = decoded_instr_m[4];
    assign bne_m    = decoded_instr_m[5];
    assign jal_m    = decoded_instr_m[6];
    assign jr_m     = decoded_instr_m[7];
    assign blt_m    = decoded_instr_m[8];
    assign bex_m    = decoded_instr_m[9];
    assign setx_m   = decoded_instr_m[10];

    assign read_mem = lw_m;
    assign write_mem = sw_m;

    //dmem element
    assign dmem_address = result_m[11:0];
    assign dmem_data_in = B_x;


    mydmem_mod mydmem1(
        .address    (result_m[11:0]),       // address of data
        .clock      (~clock),                  // may need to invert the clock
        .data       (rd_val_m),    // data you want to write
        .wren       (write_mem),      // write enable
        .value(value),
        .q          (mem_data_m)    // data from dmem
    );

    mw_latch mw_latch0(clk,nrst, mem_data_m,mem_data_w, 
                        result_m,result_w, rd_m,rd_w,
                        WE_m,WE_w, decoded_instr_m,decoded_instr_w);
//******************* Writeback
    assign R_type_w = decoded_instr_w[0];
    assign addi_w   = decoded_instr_w[1];
    assign sw_w     = decoded_instr_w[2];
    assign lw_w     = decoded_instr_w[3];
    assign j_w      = decoded_instr_w[4];
    assign bne_w    = decoded_instr_w[5];
    assign jal_w    = decoded_instr_w[6];
    assign jr_w     = decoded_instr_w[7];
    assign blt_w    = decoded_instr_w[8];
    assign bex_w    = decoded_instr_w[9];
    assign setx_w   = decoded_instr_w[10];

    assign c_WE = WE_w;
    //register to write assume rd for now
    //a selection is needed;
    //could also be r30(rstatus) or 
    //r31(ra) if jal
    assign c_WR = jal_w?5'd31:rd_w;

    //data to write is 
    //result if
    //mem_data if lw_w
    assign D_WR =lw_w?mem_data_w:result_w;
//-----------------------------------@!#%!%@#!$#%!@!%#%!#@%#@!

endmodule

module pc_reg(clk,nrst,PC_in,PC_out,data_dependency);//always enabled
    input clk,nrst,data_dependency;
    input [31:0] PC_in;
    output [31:0] PC_out;
    //enable the latch only at cases without data_denpendency
    reg_n #(.N(32)) reg_for_pc(clk,nrst,~data_dependency,PC_in,PC_out);
endmodule

module op_decoder(opcode,decoded_instruction);
    input [4:0] opcode;
    output [20:0] decoded_instruction;
    //do not necessarily need this many wires but for future
    assign decoded_instruction[0]= opcode==5'b00000;
    //R-type

    assign decoded_instruction[1]= opcode==5'b00101;
    //addi

    assign decoded_instruction[2]= opcode==5'b00111;
    //sw​ ​$rd,​ ​N($rs)  00111  I  MEM[$rs​ ​+​ ​N]​ ​=​ ​$rd

    assign decoded_instruction[3]= opcode==5'b01000;
    //lw​ ​$rd,​ ​N($rs)  01000  I  $rd​ ​=​ ​MEM[$rs​ ​+​ ​N]

    assign decoded_instruction[4]= opcode==5'b00001;
    //j​ ​T  00001  JI  PC​ ​=​ ​T

    assign decoded_instruction[5]= opcode==5'b00010;
    // bne​ ​$rd,​ ​$rs,​ ​N  00010  I  if​ ​($rd​ ​!=​ ​$rs)​ ​PC​ ​=​ ​PC​ ​+​ ​1​ ​+​ ​N
    
    assign decoded_instruction[6]= opcode==5'b00011;
    // jal​ ​T  00011  JI  $r31​ ​=​ ​PC​ ​+​ ​1,​ ​PC​ ​=​ ​T
    
    assign decoded_instruction[7]= opcode==5'b00100;
    // jr​ ​$rd  00100  JII  PC​ ​=​ ​$rd
    
    assign decoded_instruction[8]= opcode==5'b00110;
    // blt​ ​$rd,​ ​$rs,​ ​N  00110  I  if​ ​($rd​ ​<​ ​$rs)​ ​PC​ ​=​ ​PC​ ​+​ ​1​ ​+​ ​N
    
    assign decoded_instruction[9]= opcode==5'b10110;
    // bex​ ​T  10110  JI  IF​ ​($rstatus​ ​!=​ ​0)​ ​PC​ ​=​ ​T
    
    assign decoded_instruction[10]=opcode==5'b10101;
    // setx​ ​T  10101  JI  $rstatus​ ​=​ ​T
    
    assign decoded_instruction[11]= opcode==5'b11111;
    // custom​ ​...  xxxxx+  X  Whatever​ ​custom​ ​instructions​ ​you

endmodule

module fd_latch(clk,nrst,PC_in,PC_out,instruction_in,
                instruction_out,data_dependency);
    input clk,nrst,data_dependency;
    input [31:0] PC_in;
    output [31:0] PC_out;
    input [31:0] instruction_in;
    output [31:0] instruction_out;
    //output [4:0] rs,rt,rd;
    // output [26:0] T;
    // output [4:0] opcode;
    //reg_n #(.N(12)) a32(clk,nrst,A, result);
    pc_reg fd_pc(clk,nrst,PC_in,PC_out,data_dependency);
    reg_n #(.N(32)) a32(clk,nrst,~data_dependency,instruction_in,instruction_out);//always enabled
endmodule

module dx_latch(clk,nrst,  PC_in,PC_out,
                rd_d,rd_x,  T_d,T_x,
                rs_val_d,rs_val_x,   rt_val_d,rt_val_x,
                rd_val_d,rd_val_x,   WE_d,WE_x,
                decoded_instr_d,decoded_instr_x,stop_dx_latch);
    input clk,nrst,WE_d,stop_dx_latch;
    output WE_x;
    input [31:0] PC_in;
    output [31:0] PC_out;
    input [4:0] rd_d;
    output [4:0] rd_x;
    input [20:0]  decoded_instr_d;
    output [20:0] decoded_instr_x;
    input [26:0]  T_d;
    output [26:0] T_x;
    input [31:0] rs_val_d,rt_val_d,rd_val_d;
    output [31:0] rs_val_x,rt_val_x,rd_val_x;
    pc_reg dx_pc(clk,nrst,PC_in,PC_out,stop_dx_latch);
    reg_n #(.N(1)) WE_dx(clk,nrst,~stop_dx_latch,WE_d,WE_x);
    reg_n #(.N(5)) rd_dx(clk,nrst,~stop_dx_latch,rd_d,rd_x);
    reg_n #(.N(21)) decoded_instr_dx(clk,nrst,~stop_dx_latch,decoded_instr_d,decoded_instr_x);
    reg_n #(.N(27)) T_dx(clk,nrst,~stop_dx_latch,T_d,T_x);
    reg_n #(.N(32)) rs_val_dx(clk,nrst,~stop_dx_latch,rs_val_d,rs_val_x);
    reg_n #(.N(32)) rt_val_dx(clk,nrst,~stop_dx_latch,rt_val_d,rt_val_x);
    reg_n #(.N(32)) rd_val_dx(clk,nrst,~stop_dx_latch,rd_val_d,rd_val_x);
endmodule

module xm_latch(clk,nrst, result_x,result_m,
                        rd_val_x,rd_val_m, rd_x,rd_m, WE_x,WE_m,
                        decoded_instr_x,decoded_instr_m);
    input clk,nrst,WE_x;
    output WE_m;
    input [4:0] rd_x;
    output [4:0] rd_m;
    input [20:0]  decoded_instr_x;
    output [20:0] decoded_instr_m;
    input [31:0]  result_x,rd_val_x;
    output [31:0] result_m,rd_val_m;
    reg_n #(.N(1)) WE_xm(clk,nrst,1'b1,WE_x,WE_m);
    reg_n #(.N(5)) rd_xm(clk,nrst,1'b1,rd_x,rd_m);
    reg_n #(.N(21)) decoded_instr_xm(clk,nrst,1'b1,decoded_instr_x,decoded_instr_m);
    // reg_n #(.N(27)) T_xm(clk,nrst,1'b1,T_x,T_m);
    reg_n #(.N(32)) result_xm(clk,nrst,1'b1,result_x,result_m);
    reg_n #(.N(32)) rd_val_xm(clk,nrst,1'b1,rd_val_x,rd_val_m);

endmodule

module mw_latch(clk,nrst, mem_data_m,mem_data_w, 
                        result_m,result_w, rd_m,rd_w,
                        WE_m,WE_w, decoded_instr_m,decoded_instr_w);
    input clk,nrst,WE_m;
    output WE_w;
    input [4:0] rd_m;
    output [4:0] rd_w;
    input [20:0]  decoded_instr_m;
    output [20:0] decoded_instr_w;
    input [31:0]  result_m,mem_data_m;
    output [31:0] result_w,mem_data_w;

    reg_n #(.N(1)) WE_mw(clk,nrst,1'b1,WE_m,WE_w);
    reg_n #(.N(5)) rd_mw(clk,nrst,1'b1,rd_m,rd_w);
    reg_n #(.N(21)) decoded_instr_mw(clk,nrst,1'b1,decoded_instr_m,decoded_instr_w);
    reg_n #(.N(32)) result_mw(clk,nrst,1'b1,result_m,result_w);
    reg_n #(.N(32)) mem_data_mw(clk,nrst,1'b1,mem_data_m,mem_data_w);

endmodule
`endif