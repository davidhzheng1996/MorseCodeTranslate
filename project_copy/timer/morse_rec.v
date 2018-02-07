//record the time for the incoming morse signal/
//up to five value outputs
`ifndef morse_recorder_H
`define morse_recorder_H//to prevent repeated include
`include "paramd_reg/reg_n.v"
`include "timer/tim_counter.v"
module morse_rec(clk, sig_in, reset, m_end,value, valid);//32 counter
parameter wid=32;//width of register that holds the timer counts
    input clk, reset,sig_in;
    output m_end;//high after detecting the end of a morse message
    output valid;
    output [5*wid-1:0] value; 
    //output [wid-1:0] ct;//current count
    
    wire [wid-1:0] tim_ct,tim_ct_plus_1;
    assign tim_ct_plus_1 = tim_ct+1;
    reg m_end,valid,man_rst,man_WE;

    wire rst;
    assign rst = man_rst|reset;
    //reset timer counter when there's a outside reset 
    //or a inside manual reset
    tim_counter tc(clk, rst, tim_ct);

    reg [2:0] sig_ct;//count which register to write to
    wire [4:0] decoded_sig_ct=1'b1<<sig_ct;


    wire [5*wid-1:0] value;
    //5 registers
    genvar i1;
      generate
      for (i1 = 0; i1 <= 4; i1 = i1 + 1) begin: loopi1

        wire local_we;
        assign local_we = decoded_sig_ct[i1]&man_WE;
        reg_n #(.N(wid)) a_reg_32(~clk,~reset,local_we,tim_ct_plus_1, value[wid*(i1+1)-1:wid*i1]);//maybe neg clk here
      end
    endgenerate

    reg[1:0] state;
    reg highed;
    reg [wid-1:0] stop_time;

    initial begin
        sig_ct  <=0;
        valid   <=0;
        state   <=0;
        man_rst <=0;
        man_WE  <=0;
        m_end<=0;
        stop_time<=0;
    end
    //state 0 idle
    //reset timers/counters and change to state 1 at sig_in rises

    //state 1 recording sig duration
    //do nothing, maybe if ct > max, set flag to invalid
    //transit to state 2 at sig_in fall

    //state 2 waiting for next pulse
    //at sig_in rises, reset and transit to state 1 unless the delay is too small
    //at delay greater than delay_max, set end disable everything

    //state 3 finished
    //wait for reset, if reset, reenable everything
    wire sig_in_d;//sig_in_delayed with negtive clock
    reg_n #(.N(1)) delay_sig_in(~clk,~reset,1'b1,sig_in, sig_in_d);
    wire sig_in_d_pos;//sig_in_delayed

    reg_n #(.N(1)) delay_sig_in_negclk(clk,~reset,1'b1,sig_in, sig_in_d_pos);
    

    always @(sig_in or clk or reset) begin

        casex(state)
            2'd0: begin:idle
                //a signal start detected
                // if (sig_in&~highed) begin
                //no need of highed with a state machine
                if (sig_in) begin
                //
                    // reset timer counter
                    man_rst=1;
                    state=1;
                    //highed=1;
                end
            end
            2'd1: begin:rec_sig_duration
                //set rst low shortly after sig_in rises
                //***********loss of potentially 1 cycle
                if (~clk&sig_in_d) begin
                    man_rst=0;
                end

                //end of signal detected
                if (~sig_in) begin
                    man_WE=1;//write data
                    state=2;
                    stop_time=tim_ct;
                end
                //do nothing, maybe if ct > max, set flag to invalid
            end
            2'd2: begin:wait_next_pulse
                //set WE low shortly after sig_in falls
                if (~clk&~sig_in_d) begin
                    man_WE=0;
                end
                //at sig_in rises, reset the timer and transit to state 1 unless the delay is too small
                if (sig_in) begin
                    //if delay < delay_min, invalid spacing
                        //to be added
                    man_rst=1;
                    state=1;
                    sig_ct=sig_ct+1;//write to the next address
                end
                //at delay greater than delay_max, 
                //set end, disable everything
                //transit to state3
                if (tim_ct-stop_time>30) begin
                    state=3;
                    m_end=1;
                end

            end
            //state 3 finished
            //wait for reset, if reset, reenable everything
            default: begin: finished//also state 3
                
            end

        endcase
        if (reset) begin//non-blocking
            sig_ct  <=0;
            valid   <=0;
            state   <=0;
            man_rst <=0;
            man_WE  <=0;
        end
    end


endmodule
`endif