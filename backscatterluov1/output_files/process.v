/*
	by:dan
	func:3个tag 每个工作50ms 
*/
module process (	clk,rst_n,clk_1000,clk_40,clk_80,clkout1,clkout2,clkout3,clkp);
		input 	clk,clk_1000,clk_40,clk_80,rst_n;                       //输入信号，其中clk连接到FPGA的C1脚，频率为12MHz
      output	clkout1,clkout2,clkout3,clkp; 

 //parameter是verilog里常数语句
	parameter	WIDTH	= 20;             //计数器的位数，计数的最大值为 2**WIDTH-1
	parameter	N	= 2000;             //分频系数，请确保 N < 2**WIDTH-1，否则计数会溢出
 
	reg 	[WIDTH-1:0]	cnt_p,cnt_n;     //cnt_p为上升沿触发时的计数器，cnt_n为下降沿触发时的计数器
	reg   [4:0] cnt_a;
	reg			clk_p,clk_n;     //clk_p为上升沿触发时分频时钟，clk_n为下降沿触发时分频时钟
	reg	out1,out2,out3;
	//上升沿触发时计数器的控制
	always @ (posedge clk_1000 or negedge rst_n )         //posedge和negedge是verilog表示信号上升沿和下降沿
                                                         //当clk上升沿来临或者rst_n变低的时候执行一次always里的语句
		begin
			if(!rst_n)
				cnt_p<=0;
			else if (cnt_p==(N-1))
				cnt_p<=0;
			else cnt_p<=cnt_p+1;             //计数器一直计数，当计数到N-1的时候清零，这是一个模N的计数器
		end
 
    //上升沿触发的分频时钟输出,如果N为奇数得到的时钟占空比不是50%；如果N为偶数得到的时钟占空比为50%
    always @ (posedge clk_1000 or negedge rst_n)
		begin
			if(!rst_n)
				clk_p<=0;
			else if (cnt_p<(N>>1))          //N>>1表示右移一位，相当于除以2去掉余数
				clk_p<=0;
			else 
				clk_p<=1;               //得到的分频时钟正周期比负周期多一个clk时钟
		end
   //每2ms进行一次计数
 	always @ (posedge clk_p or negedge rst_n)
		begin
			if(!rst_n)
				begin
					cnt_n<=0;
					cnt_a<=0;
				end
			else if(cnt_n<26)
				begin
					cnt_n<=cnt_n+1;
					if(cnt_n==25)
						begin
							cnt_a<=cnt_a+1;
							cnt_n<=0;
						end
					if(cnt_a==4)
						cnt_n<=0;
				end
		end
		
//	always @ (posedge clk or negedge rst_n)
//		begin
//			if(!rst_n)
//				out1<=0;
//			else if(clk_p==1)
//				out1<=1;
//			else if(clk_p==0)
//				out1<=0;
//		end
//		
//	always @ (posedge clk or negedge rst_n)
//		begin
//			if(!rst_n)
//				out2<=0;
//			else if(clk_p==1)
//				out2<=1;
//			else if(clk_p==0)
//				out2<=0;
//		end
 
//assign clkout1 = (cnt_a==0)?(cnt_n==0?clk_40:0):(cnt_n==0?clk_80:0);      //条件判断表达式
//assign clkout2 = (cnt_a==0)?(cnt_n==1?clk_40:0):(cnt_n==1?clk_80:0);      //条件判断表达式
//assign clkout3 = (cnt_a==0)?(cnt_n==2?clk_40:0):(cnt_n==2?clk_80:0);      //条件判断表达式

//assign clkout1 = cnt_a==1?clk_80:0;      //条件判断表达式
//assign clkout2 = cnt_a==2?clk_80:0;      //条件判断表达式
//assign clkout3 = cnt_a==3?clk_80:0;      //条件判断表达式

assign clkout1 = clk_40;      //条件判断表达式
assign clkout2 = clk_40;      //条件判断表达式
assign clkout3 = clk_40;      //条件判断表达式
assign clkp = clk_40;
                                                                    //当N=1时，直接输出clk
                                                                    //当N为偶数也就是N的最低位为0，N（0）=0，输出clk_p
                                                                    //当N为奇数也就是N最低位为1，N（0）=1，输出clk_p&clk_n。正周期多所以是相与


endmodule
