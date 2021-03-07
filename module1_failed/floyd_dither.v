`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/29/2020 01:16:09 PM
// Design Name: 
// Module Name: floyd_dither
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

(* keep_hierarchy = "yes" *) module floyd_dither(
        //Inputs
		clk             ,
		rst             ,
        h_cnt           ,
		v_cnt           ,
        hs_in           ,
		vs_in           ,
		de_in           ,
		din             ,

		//outputs
	    hs_out          ,
		vs_out          ,
		de_out          ,
		dout           
);
//**************************
// INPUT
//**************************
input           clk;
input           rst;
input[11:0]     h_cnt;
input[11:0]     v_cnt;
input           hs_in;
input           vs_in;
input           de_in;
input[23:0]     din;
//**************************
// OUTPUT
//**************************
output           vs_out;
output           hs_out;
output           de_out;
output[23:0]     dout;

wire[9:0]       gray_factor;
wire[9:0]       gray_factor_tmp;
wire[9:0]       gray_factor_now;
wire[9:0]       gray_factor_cliped;
wire[9:0]       new_gray_factor;
wire[9:0]       quant_err;
wire[9:0]       prepix_err;
wire[9:0]       prepix_err_tmp;
wire[9:0]       left_err;
wire[9:0]       preline_err;
wire[9:0]       down_err;
wire[9:0]       q_err_k;
wire[9:0]       q_err_k_tmp;
wire[9:0]       new_q_err_k;
wire[11:0]      addr_k;
wire[11:0]      addr_kmin1;
wire[9:0]       q_err_kmin1;
wire[9:0]       q_err_kmin1_tmp;
wire[9:0]       new_q_err_kmin1;
wire[11:0]       line_num;
// REG;
reg[9:0]        gray_factor_reg;
reg[9:0]        prepix_err_reg;
reg[9:0]        preline_err_reg;
reg[11:0]       addr_k_reg;
reg[11:0]       addr_k_min1_reg;
reg             vs_out_d0;
reg             hs_out_d0;
reg             de_out_d0;

assign gray_factor = {2'd0, {(din[7:0]>>2) + (din[15:8]>>1) + (din[23:16]>>2)}};

always @(posedge clk or posedge rst) begin
    if(rst || !de_out_d0)
        gray_factor_reg <= 10'b0;
    else
        gray_factor_reg <= gray_factor;
end

assign q_err_k_tmp = (addr_k_reg == 12'd0 || line_num == 12'd0) ? 10'd0 : q_err_k;
assign gray_factor_tmp = gray_factor + q_err_k_tmp;

assign gray_factor_now = gray_factor_tmp + prepix_err_reg;//assign gray_factor_now = gray_factor_tmp + prepix_err_tmp;

assign gray_factor_cliped = (gray_factor_now[9] == 1'b1) ? 10'd0 : ((gray_factor_now[8] == 1'b1) ? 10'b001111111 : gray_factor_now);

assign new_gray_factor = (gray_factor_cliped < 10'd128) ? 10'd0 : 10'b0011111111;

assign quant_err = gray_factor_cliped - new_gray_factor;

assign prepix_err = {{2{quant_err[9]}}, quant_err[9:2]} + {{3{quant_err[9]}}, quant_err[9:3]} + {{4{quant_err[9]}}, quant_err[9:4]};
assign left_err = {{3{quant_err[9]}}, quant_err[9:3]} + {{4{quant_err[9]}}, quant_err[9:4]};
assign preline_err = {{4{quant_err[9]}}, quant_err[9:4]};
assign down_err = {{2{quant_err[9]}}, quant_err[9:2]} + {{4{quant_err[9]}}, quant_err[9:4]};

always @(posedge clk or posedge rst) begin
    if(rst || !de_out_d0)
        prepix_err_reg <= 10'b0;
    else
        prepix_err_reg <= prepix_err;
end

//assign prepix_err_tmp = (addr_k_reg == 12'd0) ? 10'd0 : prepix_err_reg;

always @(posedge clk or posedge rst) begin
    if(rst || !de_out_d0)
        preline_err_reg <= 10'b0;
    else
        preline_err_reg <= preline_err;
end

assign new_q_err_k = preline_err_reg + down_err;

//assign q_err_kmin1_tmp = (addr_k_reg == 12'd0 || line_num == 12'd0) ? 10'd0 : q_err_kmin1;
assign new_q_err_kmin1 = q_err_kmin1 + left_err;//assign new_q_err_kmin1 = q_err_kmin1_tmp + left_err;

assign line_num = v_cnt - 12'd4;
assign addr_k = h_cnt - 12'd88 - 12'd44 - 12'd148;
assign addr_kmin1 = addr_k - 12'd1;

always @(posedge clk or posedge rst) begin
    if(rst || !de_out_d0)
        addr_k_reg <= 10'b0;
    else
        addr_k_reg <= addr_k; 
end

always @(posedge clk or posedge rst) begin
    if(rst || !de_out_d0)
        addr_k_min1_reg <= 10'b0;
    else
        addr_k_min1_reg <= addr_kmin1;
end

q_err ins_q_err(
    .clk              (clk),
    .en               (1'b1),
    .w_addr_k         (addr_k_reg),
    .w_addr_kmin1     (addr_k_min1_reg),
    .w_din_k          (new_q_err_k),
    .w_din_kmin1      (new_q_err_kmin1),
    .r_addr_k         (addr_k),
    .r_addr_kmin1     (addr_kmin1),
    //Output
    .r_dout_k         (q_err_k),
    .r_dout_kmin1     (q_err_kmin1)
);

always  @(posedge clk or posedge rst) begin
    if(rst)
        hs_out_d0 <= 1'b0;
    else 
        hs_out_d0 <= hs_in;
end

always @(posedge  clk or posedge rst) begin
    if(rst)
        vs_out_d0 <= 1'b0;
    else
        vs_out_d0 <= vs_in;
end

always @(posedge clk or posedge rst) begin
    if(rst)
        de_out_d0 <= 1'b0;
    else
        de_out_d0 <= de_in;
end

assign hs_out = hs_out_d0;
assign vs_out = vs_out_d0;
assign de_out = de_out_d0;

assign dout = {3{new_gray_factor[7:0]}};

endmodule