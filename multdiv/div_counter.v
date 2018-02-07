//32-bit counter used for division
//when set is high, change value to st_amt
`ifndef div_counter_H
`define div_counter_H//to prevent repeated include
`include "common/mydffe.v"
module div_counter(clk, set, st_amt, ct, c_end);//32 counter
     input clk, set;
     input [4:0] st_amt;//start count
     output [4:0] ct;//current count
     output c_end;//the counter reached 31

     reg[4:0] next;
     reg c_end,been_set;
//if set is high, set next to st_amt
     // wire [4:0] next;
     // integer next_int;
     // assign next=next_int;
     mydffe dff0(next[0],clk, , set, 1'b1, ct[0]);
     mydffe dff1(next[1],clk, , set, 1'b1, ct[1]);
     mydffe dff2(next[2],clk, , set, 1'b1, ct[2]);
     mydffe dff3(next[3],clk, , set, 1'b1, ct[3]);
     mydffe dff4(next[4],clk, , set, 1'b1, ct[4]);

// ~(set&st_amt[0]) ,set&st_amt[0]
// ~(set&st_amt[1]) ,set&st_amt[1]
// ~(set&st_amt[2]) ,set&st_amt[2]
// ~(set&st_amt[3]) ,set&st_amt[3]
// ~(set&st_amt[4]) ,set&st_amt[4]
     //@reset high, reset
     //@clk rise/ct changes, count++
     //default: next=ct+1
     integer x;
     reg set_high;
     initial
     begin
         x=0;
         c_end=0;
         next=0;
         set_high=0;
     end


     always@(*) begin
          casex({set, ct})
               6'b1xxxxx: begin:crst
                    if(st_amt!==5'bx) begin
                    next=st_amt;
                    end
                    
                    c_end=0;
               end
               6'd0: begin:cas0
                    if(next==0) begin
                    next=0;
                    c_end=1;
                    end
               end
               default: next = next-1;
          endcase
     end

     //x&set high
     // always @(posedge clk or set) begin
     //      if(set==1) begin
     //           x=0;
     //           c_end=0;
     //           set_high=1;
     //      end
     //      if (set==0) begin
     //           if(st_amt!==5'bx) begin
     //                next=st_amt;
     //           end
     //           if (set_high==1) begin
     //                x=1;
     //           end
     //           set_high=0;
     //      end
     //      if (clk==1) begin
     //           casex(next)
     //           5'd0: 
     //           begin: c0
     //                if (x==1) begin
     //                     c_end=1;
     //                end
     //                next=0;                
     //           end
     //           default: 
     //           begin: defcase
     //                next=next-1;
     //           end
     //           endcase
     //      end

     // end
     //version 1
//      always@(set) begin
//           if(set==1) begin
//                x=0;
               
//           end
//           if(set==0&&set_high==1) begin
//                x=1;
//           end
//           set_high=set;
//           // x=~set;
//      end
//      //c_end
//      always@(posedge set or posedge clk) begin
//           if (set==1) begin
//                c_end=0;
//           end
//           if (x==1&&next==5'd0) begin
//                c_end=1;
               
//           end
//      end

// //next
//      always@(negedge set or posedge clk) begin
//           if(st_amt!==5'bx&&set==0) begin
//                next=st_amt;
//           end
//           if(clk==1) begin
//           casex(next)
//                5'd0: 
//                begin: c0
//                     next=0;                
//                end
//                default: 
//                begin: defcase
//                     next=next-1;
//                end
//           endcase
//           end
//      end
     
     // assign set_high = set;
     // always@(posedge set) begin
     //     x=0;
     //     c_end=0;
     //      if (set==1) begin
     //           set_high=1;
     //      end
     // end
     // always@(negedge set) begin
     //      // if(set==1'b1) begin
     //      if(st_amt!==5'bx) begin
     //           next=st_amt;
     //      end
          
     //      if (set_high==1) begin
     //           x=1;
     //      end
     //      set_high=0;
     //                // end
          
     // end
     // always@(posedge clk) begin
     //                casex(next)
     //                     5'd0: 
     //                     begin: c0
     //                          if (x==1) begin
     //                               c_end=1;
     //                          end
                              
     //                          next=0;
                              
     //                     end
     //                     default: 
     //                     begin: defcase
     //                          next=next-1;
     //                     end
     //                endcase
     //      // casex(x)
     //      //      // 0://do nothing
     //      //      1: begin:x1//next=st_amt,ct=0
     //      //      //started iterating
     //      //           if(ct!=5'd0) begin
     //      //                x=2;

     //      //           end
     //      //           if(next==ct) begin
     //      //                x=2;

     //      //           end


                    
     //      //      end
     //      //      2: begin:x2//where ct!=0
     //      //           casex(ct)
     //      //                5'd0: 
     //      //                begin: c0
     //      //                     c_end=1;
     //      //                     // next=0;
                              
     //      //                end
     //      //                default: 
     //      //                begin: defcase
     //      //                     next=next-1;
     //      //                end
     //      //           endcase
     //      //      end
               
     //      // endcase
     // end
          // 

     // always@(*) begin
     //      casex(ct)
     //           5'd0: begin: c0
     //                // next = 0;
     //                casex(x)
     //                2: c_end=1;
     //                1: x=2;
     //                // if(x==2) begin
     //                //      // next = 0;
     //                //      c_end=1;
     //                // end
     //                // if (x==1) begin
     //                //      x=2;
     //                // end
     //                endcase
     //           end
     //           // default: next_int = next_int+1;
     //           default: begin: def
     //                if(ct==next)begin
     //                     next = next-1;
     //                     x=2;
     //                end
     //           end
     //      endcase
     // end
endmodule
`endif