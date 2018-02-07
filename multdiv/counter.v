//32-bit counter
//high "reset" resets the counter 
`ifndef counter_H
`define counter_H//to prevent repeated include
`include "common/mydffe.v"
module counter(clk, reset, ct, c_end);//32 counter
     input clk, reset;
     output [4:0] ct;//current count
     output c_end;//the counter reached 31
     reg[4:0] next;
     reg c_end;
     // wire [4:0] next;
     // integer next_int;
     // assign next=next_int;
     mydffe dff0(next[0],clk,~reset , , 1'b1, ct[0]);
     mydffe dff1(next[1],clk,~reset , , 1'b1, ct[1]);
     mydffe dff2(next[2],clk,~reset , , 1'b1, ct[2]);
     mydffe dff3(next[3],clk,~reset , , 1'b1, ct[3]);
     mydffe dff4(next[4],clk,~reset , , 1'b1, ct[4]);


     //@reset high, reset
     //@clk rise/ct changes, count++
     //default: next=ct+1


     always@(*) begin
          casex({reset, ct})
               6'b1xxxxx: {next,c_end}=0;
               // 6'b1xxx: next_int = 0;//set 0 when reset is high
               // 6'd0: next = 1;
               // 6'd1: next = 2;
               // 6'd2: next = 3;
               // 6'd3: next = 4;
               // 6'd4: next = 5;
               // 6'd5: next = 6;
               // 6'd6: next = 7;
               // 6'd7: next = 8;
               // 6'd8: next = 9;
               // 6'd9: next = 10;
               // 6'd10: next = 11;
               // 6'd11: next = 12;
               // 6'd12: next = 13;
               // 6'd13: next = 14;
               // 6'd14: next = 15;
               // 6'd15: next = 16;
               // 6'd16: next = 17;
               // 6'd17: next = 18;
               // 6'd18: next = 19;
               // 6'd19: next = 20;
               // 6'd20: next = 21;
               // 6'd21: next = 22;
               // 6'd22: next = 23;
               // 6'd23: next = 24;
               // 6'd24: next = 25;
               // 6'd25: next = 26;
               // 6'd26: next = 27;
               // 6'd27: next = 28;
               // 6'd28: next = 29;
               // 6'd29: next = 30;
               // 6'd30: next = 31;
               6'd31: 
                    begin: c31 
                    next = 31;
                    c_end=1;
                    end
               // default: next_int = next_int+1;
               default: next = next+1;
          endcase
     end
endmodule
`endif