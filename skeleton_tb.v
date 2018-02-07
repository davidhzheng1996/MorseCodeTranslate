`timescale 1 ns/ 100 ps
module skeleton_tb();

	reg clock, reset, morse;
	wire [31:0] ascii, pcout;
	wire decodeend;
	
	skeleton my_skel(.cpuclock(clock), .resetn(reset), .morse(morse),
	.asciiout(ascii), .pcout(pcout), .decodeend(decodeend));
	
	initial
	begin
        $display("<< Test processor >>");	
        // $monitor("time=%3d, alu/exe_result=%c",$time,result);
       // $monitor("time=%3d, decoded letter is =%c",$time,result);	  		  
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
