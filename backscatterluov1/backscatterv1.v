module backscatterv1 (
	clk,rst_n,
	clkout1,clkout2,clkout3,clkout4,clkp,
	key0,led0
	);
 
        input 	clk,rst_n;                       //输入信号，其中clk连接到FPGA的C1脚，频率为12MHz
        output	clkout1,clkout2,clkout3,clkout4,clkp;  //输出信号，可以连接到LED观察分频的时钟
		  
		  input key0;
		  output led0;
		  
		  wire[1:0] temp1;
		  wire[1:0] temp2;
		  wire[1:0] temp3;
		  
		  

     ppl m1(.inclk0(clk),
				.c0(temp1),
				.c1(temp2),
				.c2(temp3)
				);
				
				
		process the_process(.clk(clk),
		.rst_n(rst_n),
		.clk_40(temp2),
		.clk_1000(temp1),
		.clk_80(temp3),
		.ctrl1(clkout1),
		.ctrl2(clkout2),
		.ctrl3(clkout3),
		.ctrl4(clkout4),
		.clkp(clkp),
		.key0(key0),
		.led0(led0)
		);
        

endmodule
