module backscatterv1 (
	clk,rst_n,
	clkout1,clkout2,clkout3,clkout4,clkp,
	key0,led0
	);
 
        input 	clk,rst_n;                       //输入信号，其中clk连接到FPGA的C1脚，频率为12MHz
        output	clkout1,clkout2,clkout3,clkout4,clkp;  //输出信号，可以连接到LED观察分频的时钟
		  
		  input key0;
		  output led0;
		  
		  wire clk0; // 12 M
		  wire clk1; // 39 M
//		  wire[1:0] clk2;
		  
		  assign clkout1 = clk1; // M4

     ppl m1(.inclk0(clk),
				.c0(clk0),
				.c1(clk1)
//				.c2(clk2)
				);
				
				
		
//process the_proc(
//	 .clk(clk1), .rst_n(rst_n), 
//	 .sig(clkout1), .ctrl1(clkout2), .pwm(clkout3)
//);    

endmodule
