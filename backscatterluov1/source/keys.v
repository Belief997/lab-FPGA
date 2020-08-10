/********************************************************
   module: keys
   author: xyr
   date: 7/31/2020
   
********************************************************/

module keys (
	input wire clk,
	input wire key0,key1,key2,
	output wire k0,k1,k2

);
	reg [19:0] cnt_10ms;
	initial cnt_10ms = 20'b0;

	always@(posedge clk) begin		
			if(cnt_10ms < 20'd1000_000) cnt_10ms <= cnt_10ms + 20'b1;//20'd100 
			else cnt_10ms <= 20'b0;
	end

	reg key_0_smp, key_1_smp,key_2_smp;
	initial begin
	key_0_smp = 0;
	key_1_smp = 0;
	key_2_smp = 0;

	end

	always@(posedge clk) begin
		if(cnt_10ms == 20'd000) begin
			key_0_smp <= key0;
			key_1_smp <= key1;
			key_2_smp <= key2;

		end
	end

	reg k0_dly, k1_dly,k2_dly ;
	always@(posedge clk) begin
		k0_dly = key_0_smp;
		k1_dly <= key_1_smp;
		k2_dly <= key_2_smp;
	end

	assign k0= ({key_0_smp, k0_dly} == 2'b10);
	assign k1= ({key_1_smp, k1_dly} == 2'b10);
	assign k2= ({key_2_smp, k2_dly} == 2'b10);

endmodule
