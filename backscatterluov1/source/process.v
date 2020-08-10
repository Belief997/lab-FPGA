/*
	module: tag ctrl
	author:xyr
	date: 07/31/2020
*/
module process (
	input clk, rst_n, clk_1000, clk_40, clk_80,
	output ctrl1, ctrl2, ctrl3, ctrl4, clkp,
	input key0,
	output reg led0
);
// clk 12M, clk_1000 1M, clk_40, clk_80 80M


// 80 MHz clock source
	parameter CNT_MINI_CYCLE_1 = 80 * 10; // 10  us
	parameter CNT_MINI_CYCLE_2 = 80 * 100; // 100 us
	parameter CNT_COLD_DOWN    = 80 * 100; // 100 us
	parameter TAG_NUM = 4;
//	parameter CNT_CYCLE	= 32'd;    //

	reg [31:0] cnt_cycle;
	initial begin
		cnt_cycle = 'b0;
	end

	wire k0;
	initial begin
		led0 = 'b0;
	end
	always@(posedge clk_80 or negedge rst_n) begin
		if(!rst_n)begin
			led0 = 'b0;
		end
		else begin
			if(k0)begin
				led0 <= led0 + 1'b1;
			end
			else begin
				led0 <= led0;
			end
		end
	end

	// on: cycle_2, off: cycle_1
	wire [31:0] miniCycleSelect = (led0==1) ? CNT_MINI_CYCLE_2 : CNT_MINI_CYCLE_1;
	always@(posedge clk_80 or negedge rst_n or posedge k0) begin
		if(!rst_n || k0)begin
			cnt_cycle <= 'b0;
		end
		else begin
			if(cnt_cycle >= 4 * miniCycleSelect + CNT_COLD_DOWN - 1) begin
				cnt_cycle <= 'b0;
			end
			else begin
				cnt_cycle <= cnt_cycle + 1'b1;
			end
		end
	end

	reg [TAG_NUM - 1 : 0]tag_En;
	initial begin
		tag_En = 'b0;
	end
	always@(posedge clk_80 or negedge rst_n or posedge k0) begin
		if(!rst_n || k0)begin
			tag_En <= 'b0;
		end
		else begin
			if(cnt_cycle < miniCycleSelect) begin
				tag_En <= 'h1;
			end
			else if(cnt_cycle < 2 * miniCycleSelect) begin
				tag_En <= 'h2;
			end
			else if(cnt_cycle < 3 * miniCycleSelect) begin
				tag_En <= 'h4;
			end
			else if(cnt_cycle < 4 * miniCycleSelect) begin
				tag_En <= 'h8;
			end
			else begin
				tag_En <= 'h0;
			end
		end
	end


//	always@(posedge clk_80 or negedge rst_n) begin
//		if(!rst_n)begin
//			ctrl1 <= 'b0;
//			ctrl2 <= 'b0;
//			ctrl3 <= 'b0;
//			ctrl4 <= 'b0;
//		end
//		else begin
//			ctrl1 <= tag_En[0];
//			ctrl2 <= tag_En[1];
//			ctrl3 <= tag_En[2];
//			ctrl4 <= tag_En[3];
//		end
//	end

assign ctrl1 = tag_En[0];      
assign ctrl2 = tag_En[1];     
assign ctrl3 = tag_En[2];     
assign ctrl4 = tag_En[3]; 
assign clkp = clk_40;


keys the_keys(
	.clk(clk_80),
	.key0(key0), .key1(), .key2(),
	.k0(k0), .k1(), .k2()
);


endmodule
