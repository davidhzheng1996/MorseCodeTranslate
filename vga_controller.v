module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 morse);

	
input iRST_n;
input iVGA_CLK;
input [31:0] morse;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;                        
///////// ////                     
reg [18:0] ADDR, ADDR1, ADDR2, ADDR3;
reg [18:0] ADDR4, ADDR7, ADDR10, ADDR13;
reg [18:0] ADDR5, ADDR8, ADDR11, ADDR14;
reg [18:0] ADDR6, ADDR9, ADDR12, ADDR15;
reg [18:0] ADDR16, ADDR18, ADDR20, ADDR22;
reg [18:0] ADDR17, ADDR19, ADDR21, ADDR23;
reg [18:0] ADDR24, ADDR25, ADDR26;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
//wire [7:0] indexE, indexF, indexG, indexH;
//wire [7:0] indexI, indexJ, indexK, indexL;
//wire [7:0] indexM;
//wire [7:0] indexN, indexO, indexP, indexQ;
//wire [7:0] indexR, indexS, indexT, indexU;
//wire [7:0] indexV, indexW, indexX, indexY;
//wire [7:0] indexZ;
wire [23:0] bgr_data_raw;
//wire [23:0] bgr_data1, bgr_data_rawE, bgr_data_rawF, bgr_data_rawG;
//wire [23:0] bgr_data_rawH, bgr_data_rawI, bgr_data_rawJ, bgr_data_rawK;
//wire [23:0] bgr_data_rawL, bgr_data_rawM;
//wire [23:0] bgr_data_rawN, bgr_data_rawO, bgr_data_rawP, bgr_data_rawQ;
//wire [23:0] bgr_data_rawR, bgr_data_rawS, bgr_data_rawT;
//wire [23:0] bgr_data_rawU, bgr_data_rawV, bgr_data_rawW, bgr_data_rawX;
//wire [23:0] bgr_data_rawY, bgr_data_rawZ;
wire cBLANK_n,cHS,cVS,rst;
////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
////
////Addresss generator
//always@(posedge iVGA_CLK,negedge iRST_n)
//begin
//  if (!iRST_n)
//     ADDR<=19'd0;
//  else if (cHS==1'b0 && cVS==1'b0)
//     ADDR<=19'd0;
//  else if (cBLANK_n==1'b1)
//     ADDR<=ADDR+1;
//	  ADDR1<=ADDR/16;
//end

always@(posedge iVGA_CLK,negedge iRST_n) //A
begin
  if (!iRST_n)
     ADDR1<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR1<=19'd0;
  else if (cBLANK_n==1'b1&&ADDR1<19'h44A0)
     ADDR1<=ADDR1+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //B
begin
  if (!iRST_n)
     ADDR2<=19'h4100;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR2<=19'h4100;
  else if (cBLANK_n==1'b1&&ADDR2<19'h59FF) 
     ADDR2<=ADDR2+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //C
begin
  if (!iRST_n)
     ADDR3<=19'h5A00;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR3<=19'h5A00;
  else if (cBLANK_n==1'b1&&ADDR3<19'h847F)
     ADDR3<=ADDR3+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //D
begin
  if (!iRST_n)
     ADDR4<=19'h8480;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR4<=19'h8480;
  else if (cBLANK_n==1'b1&&ADDR4<19'hAEFF)
     ADDR4<=ADDR4+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //E
begin
  if (!iRST_n)
     ADDR5<=19'hAF00;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR5<=19'hAF00;
  else if (cBLANK_n==1'b1&&ADDR5<19'hD97F)
     ADDR5<=ADDR5+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //F
begin
  if (!iRST_n)
     ADDR6<=19'hD980;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR6<=19'hD980;
  else if (cBLANK_n==1'b1&&ADDR6<19'h117FF)
     ADDR6<=ADDR6+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //G
begin
  if (!iRST_n)
     ADDR7<=19'h11800;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR7<=19'h11800;
  else if (cBLANK_n==1'b1&&ADDR7<19'h12E7F) 
     ADDR7<=ADDR7+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //H
begin
  if (!iRST_n)
     ADDR8<=19'h12E80;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR8<=19'h12E80;
  else if (cBLANK_n==1'b1&&ADDR8<19'h15DFF)
     ADDR8<=ADDR8+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //I
begin
  if (!iRST_n)
     ADDR9<=19'h15E00;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR9<=19'h15E00;
  else if (cBLANK_n==1'b1&&ADDR9<19'h18FFF)
     ADDR9<=ADDR9+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //J
begin
  if (!iRST_n)
     ADDR10<=19'h19000;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR10<=19'h19000;
  else if (cBLANK_n==1'b1&&ADDR10<19'h1C1FF)
     ADDR10<=ADDR10+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //K
begin
  if (!iRST_n)
     ADDR11<=19'h1C200;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR11<=19'h1C200;
  else if (cBLANK_n==1'b1&&ADDR11<19'h1EC7F)
     ADDR11<=ADDR11+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //L
begin
  if (!iRST_n)
     ADDR12<=19'h1EC80;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR12<=19'h1EC80;
  else if (cBLANK_n==1'b1&&ADDR12<19'h216FF)
     ADDR12<=ADDR12+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //M
begin
  if (!iRST_n)
     ADDR13<=19'h21700;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR13<=19'h21700;
  else if (cBLANK_n==1'b1&&ADDR13<19'h2417F)
     ADDR13<=ADDR13+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //N
begin
  if (!iRST_n)
     ADDR14<=19'h24180;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR14<=19'h24180;
  else if (cBLANK_n==1'b1&&ADDR14<19'h2697F)
     ADDR14<=ADDR14+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //O
begin
  if (!iRST_n)
     ADDR15<=19'h26980;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR15<=19'h26980;
  else if (cBLANK_n==1'b1&&ADDR15<19'h2917F)
     ADDR15<=ADDR15+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //P
begin
  if (!iRST_n)
     ADDR16<=19'h29180;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR16<=19'h29180;
  else if (cBLANK_n==1'b1&&ADDR16<19'h2B17F)
     ADDR16<=ADDR16+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //R
begin
  if (!iRST_n)
     ADDR17<=19'h2E180;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR17<=19'h2E180;
  else if (cBLANK_n==1'b1&&ADDR17<19'h3097F)
     ADDR17<=ADDR17+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //S
begin
  if (!iRST_n)
     ADDR18<=19'h30980;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR18<=19'h30980;
  else if (cBLANK_n==1'b1&&ADDR18<19'h3317F)
     ADDR18<=ADDR18+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //T
begin
  if (!iRST_n)
     ADDR19<=19'h33180;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR19<=19'h33180;
  else if (cBLANK_n==1'b1&&ADDR19<19'h3597F)
     ADDR19<=ADDR19+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //U
begin
  if (!iRST_n)
     ADDR20<=19'h35980;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR20<=19'h35980;
  else if (cBLANK_n==1'b1&&ADDR20<19'h3817F)
     ADDR20<=ADDR20+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //V
begin
  if (!iRST_n)
     ADDR21<=19'h38180;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR21<=19'h38180;
  else if (cBLANK_n==1'b1&&ADDR21<19'h3A97F)
     ADDR21<=ADDR21+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //W
begin
  if (!iRST_n)
     ADDR22<=19'h3A980;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR22<=19'h3A980;
  else if (cBLANK_n==1'b1&&ADDR22<19'h3D3FF)
     ADDR22<=ADDR22+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //X
begin
  if (!iRST_n)
     ADDR23<=19'h3D400;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR23<=19'h3D400;
  else if (cBLANK_n==1'b1&&ADDR23<19'h400FF)
     ADDR23<=ADDR23+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //Y
begin
  if (!iRST_n)
     ADDR24<=19'h40100;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR24<=19'h40100;
  else if (cBLANK_n==1'b1&&ADDR24<19'h42B7F)
     ADDR24<=ADDR24+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //Z
begin
  if (!iRST_n)
     ADDR25<=19'h42B80;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR25<=19'h42B80;
  else if (cBLANK_n==1'b1&&ADDR25<19'h4AAFF)
     ADDR25<=ADDR25+1;
end

always@(posedge iVGA_CLK,negedge iRST_n) //Q
begin
  if (!iRST_n)
     ADDR26<=19'h2B180;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR26<=19'h2B180;
  else if (cBLANK_n==1'b1&&ADDR26<19'h2E17F)
     ADDR26<=ADDR26+1;
end


always@(*)
begin
  if (morse===32'd65)
     ADDR<=ADDR1;
  else if (morse===32'd66)
     ADDR<=ADDR2;
  else if (morse===32'd67)
     ADDR<=ADDR3;
  else if (morse===32'd68)
     ADDR<=ADDR4;
	else if (morse===32'd69)
     ADDR<=ADDR5;
	else if (morse===32'd70)
     ADDR<=ADDR6;
	else if (morse===32'd71)
     ADDR<=ADDR7;
	else if (morse===32'd72)
     ADDR<=ADDR8;  
	else if (morse===32'd73)
     ADDR<=ADDR9; 
	else if (morse===32'd74)
     ADDR<=ADDR10; 
	else if (morse===32'd75)
     ADDR<=ADDR11; 
	else if (morse===32'd76)
     ADDR<=ADDR12;
	else if (morse===32'd77)
     ADDR<=ADDR13;  
	else if (morse===32'd78)
     ADDR<=ADDR14; 
	else if (morse===32'd79)
     ADDR<=ADDR15; 
	else if (morse===32'd80)
     ADDR<=ADDR16; 
	else if (morse===32'd82)
     ADDR<=ADDR17; 
	else if (morse===32'd83)
     ADDR<=ADDR18; 
	else if (morse===32'd84)
     ADDR<=ADDR19; 
	else if (morse===32'd85)
     ADDR<=ADDR20;
	else if (morse===32'd86)
     ADDR<=ADDR21; 
	else if (morse===32'd87)
     ADDR<=ADDR22; 
	else if (morse===32'd88)
     ADDR<=ADDR23;
	else if (morse===32'd89)
     ADDR<=ADDR24; 
	else if (morse===32'd90)
     ADDR<=ADDR25; 
	else if (morse===32'd81)
     ADDR<=ADDR26;
end

//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
	
//img_dataB	img_data_instB (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexB )
//	);
//	
//img_dataC	img_data_instC (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexC )
//	);
//	
//img_dataD	img_data_instD (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexD )
//	);
//	
//img_dataE	img_data_instE (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexE )
//	);
//	
//img_dataF	img_data_instF (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexF )
//	);
//	
//img_dataG	img_data_instG (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexG )
//	);	
//	
//img_dataH	img_data_instH (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexH )
//	);
//	
//img_dataI	img_data_instI (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexI )
//	);
//	
//img_dataJ	img_data_instJ (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexJ )
//	);
//	
//img_dataK	img_data_instK (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexK )
//	);
//	
//img_dataL	img_data_instL (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexL )
//	);
//	
//img_dataM	img_data_instM (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexM )
//	);
//	
//img_dataN	img_data_instN (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexN )
//	);
//	
//img_dataO	img_data_instO (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexO )
//	);
//	
//img_dataQ	img_data_instQ (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexQ )
//	);
//	
//img_dataR	img_data_instR (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexR )
//	);
//	
//img_dataS	img_data_instS (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexS )
//	);
//	
//img_dataT	img_data_instT (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexT )
//	);
//	
//img_dataU	img_data_instU (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexU )
//	);
//	
//img_dataV	img_data_instV (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexV )
//	);
//	
//img_dataW	img_data_instW (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexW )
//	);
//	
//img_dataX	img_data_instX (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexX )
//	);
//	
//img_dataY	img_data_instY (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexY )
//	);
//	
//img_dataZ	img_data_instZ (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexZ )
//	);

/////////////////////////
//////Add switch-input logic here
	
//////Color table output
wire[23:0] bgr_data_help;

img_index	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw)
	);	
	
//img_indexB	img_index_instB (
//	.address ( indexB ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawB)
//	);
//
//img_indexC	img_index_instC (
//	.address ( indexC ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawC)
//	);
//	
//img_indexD	img_index_instD (
//	.address ( indexD ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawD)
//	);
//	
//img_indexE	img_index_instE (
//	.address ( indexE ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawE)
//	);
//	
//img_indexF	img_index_instF (
//	.address ( indexF ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawF)
//	);	
//	
//img_indexG	img_index_instG (
//	.address ( indexG ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawG)
//	);	
//	
//img_indexH	img_index_instH (
//	.address ( indexH ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawH)
//	);	
//	
//img_indexI	img_index_instI (
//	.address ( indexI ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawI)
//	);	
//	
//img_indexJ	img_index_instJ (
//	.address ( indexJ ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawJ)
//	);	
//	
//img_indexK	img_index_instK (
//	.address ( indexK ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawK)
//	);	
//
//img_indexL	img_index_instL (
//	.address ( indexL ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawL)
//	);	
//	
//img_indexM	img_index_instM (
//	.address ( indexM ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawM)
//	);	
//	
//img_indexN	img_index_instN (
//	.address ( indexN ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawN)
//	);	
//	
//img_indexO	img_index_instO (
//	.address ( indexO ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawO)
//	);
//
//img_indexP	img_index_instP (
//	.address ( indexP ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawP)
//	);
//	
//img_indexQ	img_index_instQ (
//	.address ( indexQ ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawQ)
//	);
//	
//img_indexR	img_index_instR (
//	.address ( indexR ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawR)
//	);
//	
//img_indexS	img_index_instS (
//	.address ( indexS ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawS)
//	);	
//	
//img_indexT	img_index_instT (
//	.address ( indexT ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawT)
//	);	
//	
//img_indexU	img_index_instU (
//	.address ( indexU ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawU)
//	);	
//	
//img_indexV	img_index_instV (
//	.address ( indexV ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawV)
//	);	
//	
//img_indexW	img_index_instW (
//	.address ( indexW ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawW)
//	);	
//	
//img_indexX	img_index_instX (
//	.address ( indexX ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawX)
//	);	
//
//img_indexY	img_index_instY (
//	.address ( indexY ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawY)
//	);	
//	
//img_indexZ	img_index_instZ (
//	.address ( indexZ ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_rawZ)
//	);	

//307200 words

//assign bgr_data1 = (morse===32'd65) ? bgr_data_raw:
//						 (morse===32'd66) ? bgr_data_rawB:	
//						 (morse===32'd67) ? bgr_data_rawC:	
//						 (morse===32'd68) ? bgr_data_rawD: 
//						 (morse===32'd69) ? bgr_data_rawE: 
//						 (morse===32'd70) ? bgr_data_rawF:
//						 (morse===32'd71) ? bgr_data_rawG:
//						 (morse===32'd72) ? bgr_data_rawH:
//						 (morse===32'd73) ? bgr_data_rawI:
//						 (morse===32'd74) ? bgr_data_rawJ:
//						 (morse===32'd75) ? bgr_data_rawK:
//						 (morse===32'd76) ? bgr_data_rawL:
//						 (morse===32'd77) ? bgr_data_rawM:
//						 (morse===32'd78) ? bgr_data_rawN:
//						 (morse===32'd79) ? bgr_data_rawO:	
//						 (morse===32'd80) ? bgr_data_rawP:	
//						 (morse===32'd81) ? bgr_data_rawQ: 
//						 (morse===32'd82) ? bgr_data_rawR: 
//						 (morse===32'd83) ? bgr_data_rawS:
//						 (morse===32'd84) ? bgr_data_rawT:
//						 (morse===32'd85) ? bgr_data_rawU:
//						 (morse===32'd86) ? bgr_data_rawV:
//						 (morse===32'd87) ? bgr_data_rawW:
//						 (morse===32'd88) ? bgr_data_rawX:
//						 (morse===32'd89) ? bgr_data_rawY:
//						 (morse===32'd90) ? bgr_data_rawZ:23'd0;
//////
//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) bgr_data <= bgr_data_raw;
assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0]; 
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
 	















