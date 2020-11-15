module top
(
	input clk_in, //clk_in = 12 MHz 
	input rst_n_in, //rst_n_in, active low 
	output led1, //led1 output 
	output led2, //led2 output 
	output CW_1, // 1953.125
	output reg CW_2, // 976.5625
	output CW_11,
	output CW_21,
	output reg SW_TEST // 0.5 Hz
); 
wire clk_12M;
wire clk_1;
wire clk_2;


// freq shift
assign CW_1 = clk_1;
assign CW_11 = CW_1;
assign CW_21 = CW_2;


initial CW_2 = 'b0;
always@(posedge clk_2 or negedge rst_n_in)begin
	if(!rst_n_in) begin
		CW_2 <= 'b0;
	end
	else begin
		CW_2 <= ~CW_2;
	end

end



// demo
parameter CLK_DIV_PERIOD = 12_000_000; 

reg clk_div=0; //wire led1,led2; 
assign led1 = clk_div; 
assign led2 = ~clk_div; //clk_div = clk_in/CLK_DIV_PERIOD 
reg[24:0] cnt=0; 

always@(posedge clk_12M or negedge rst_n_in) begin 
	if(!rst_n_in) begin 
		cnt<=0; clk_div<=0; 
	end 
	else begin 
		if(cnt==(CLK_DIV_PERIOD-1)) 
			cnt <= 0; 
		else 
			cnt <= cnt + 1'b1; 
			
		if(cnt<(CLK_DIV_PERIOD>>1)) 
			clk_div <= 0; 
		else 
			clk_div <= 1'b1; 
	end 
end

// Switch
reg [31:0] sw_cnt;
initial begin 
	sw_cnt = 'b0;
	SW_TEST = 'b0;
end
always@(posedge clk_12M or negedge rst_n_in) begin 
	if(!rst_n_in) begin 
		sw_cnt<=0; 
	end 
	else begin 
		if(sw_cnt==(CLK_DIV_PERIOD-1)) 
			sw_cnt <= 0; 
		else 
			sw_cnt <= sw_cnt + 1'b1; 
			
		if(sw_cnt==(CLK_DIV_PERIOD - 1)) 
			SW_TEST <= !SW_TEST; 
		else 
			SW_TEST <= SW_TEST; 
	end 
end



pll the_pll(
	.inclk0(clk_in),  // 12M
	.c0(clk_12M),		// 12M
	.c1(clk_1),		// 1953.125
	.c2(clk_2),		// 1953.125
	.locked());
endmodule
