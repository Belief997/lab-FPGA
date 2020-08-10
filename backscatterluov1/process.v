/*
	module: tag ctrl
	author:xyr
	date: 08/10/2020
*/
module process (
	input clk, rst_n,
	output sig, ctrl1,
	output reg pwm
);
// clk 100M

parameter DATA = 20'b1010111_0010_0000_1010_1;
reg [19:0] data = DATA;


// pwm 500k
reg [31:0] cnt_500k;
initial begin 
	cnt_500k = 'b0;
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		cnt_500k <= 'b0;
	end
	else begin
		// 1M
		if(cnt_500k >= 32'd100 - 'b1)begin
			cnt_500k <= 'b0;
		end
		else begin
			cnt_500k <= cnt_500k + 32'd1;
		end
	end
end 
wire En_500k = (cnt_500k == 32'd100 - 'b1);

// pwm
initial begin 
	pwm = 'b0;
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		pwm <= 'b0;
	end
	else begin
		if(En_500k)begin
			pwm <= ~pwm;
		end	
		else begin
			pwm <= pwm;
		end
	end
end




// en 1ms
reg [31:0] cnt_1ms;
initial begin
	cnt_1ms = 'b0;
end
always@(posedge clk or negedge rst_n) begin
	if (!rst_n)begin
		cnt_1ms <= 'b0;
	end
	else begin
		if(cnt_1ms < 32'd100_000 - 32'd1)begin
			cnt_1ms <= cnt_1ms + 32'd1;
		end
		else begin
			cnt_1ms <= 'b0;
		end
	end
end
wire En_1ms = (cnt_1ms == 32'd100_000 - 32'd1);


always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		data <= DATA;
	end
	else begin
		if(En_1ms)begin
			data <= {data[18:0], data[19]};
		end
		else begin
			data <= data;
		end
	end
end

assign sig = data[19];
assign ctrl1 = sig & pwm;

endmodule