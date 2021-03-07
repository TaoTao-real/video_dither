`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2021 06:14:58 PM
// Design Name: 
// Module Name: jarvis_dither
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


module jarvis_dither(
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

//*************************
// pix_reg pack the gray_factor:10bit \  v_cnt:12bit \ h_cnt:12bit\ de:1bit \ vs:1bit \ hs:1bit;
// gray_factor = pix_reg[36:27]; v_cnt = pix_reg[26:15]; h_cnt = pix_reg[14:3]; de = pix_reg[2:2]; vs = pix_reg[1:1]; hs = pix_reg[0:0];
//  ____________________________________________________________________________
// |    gray_factor   |     v_cnt   |    h_cnt   |    de    |    vs   |    hs   |
// |    10bit         |     12bit   |    12bit   |   1bit   |   1bit  |   1bit  |
//  ____________________________________________________________________________
//*************************


wire      full_1;
wire      empty_1;
wire      full_2;
wire      empty_2;
wire[9:0] gray_factor;
wire[9:0] err_1;
wire[9:0] err_2;
wire[9:0] err_3;
wire[9:0] err_4;
wire[9:0] err_5;
wire[9:0] err_6;
wire[9:0] err_7;
wire[9:0] err_8;
wire[9:0] err_9;
wire[9:0] err_10;
wire[9:0] err_11;
wire[9:0] err_12;

wire[9:0] new_gray_factor_1;
wire[9:0] new_gray_factor_2;
wire[9:0] new_gray_factor_3;
wire[9:0] new_gray_factor_4;
wire[9:0] new_gray_factor_5;
wire[9:0] new_gray_factor_6;
wire[9:0] new_gray_factor_7;
wire[9:0] new_gray_factor_8;
wire[9:0] new_gray_factor_9;
wire[9:0] new_gray_factor_10;
wire[9:0] new_gray_factor_11;
wire[9:0] new_gray_factor_12;

wire[9:0] new_gray_factor_1_cliped;
wire[9:0] new_gray_factor_2_cliped;
wire[9:0] new_gray_factor_3_cliped;
wire[9:0] new_gray_factor_4_cliped;
wire[9:0] new_gray_factor_5_cliped;
wire[9:0] new_gray_factor_6_cliped;
wire[9:0] new_gray_factor_7_cliped;
wire[9:0] new_gray_factor_8_cliped;
wire[9:0] new_gray_factor_9_cliped;
wire[9:0] new_gray_factor_10_cliped;
wire[9:0] new_gray_factor_11_cliped;
wire[9:0] new_gray_factor_12_cliped;

wire[36:0] fifo1_dout;
wire[36:0] fifo2_dout;

wire[9:0] new_gray_factor;
wire[9:0] binarize_gray_factor;
wire[9:0] quant_err;

reg[36:0] pix_1_reg;
reg[36:0] pix_2_reg;
reg[36:0] pix_3_reg;
reg[36:0] pix_4_reg;
reg[36:0] pix_5_reg;
reg[36:0] pix_6_reg;
reg[36:0] pix_7_reg;
reg[36:0] pix_8_reg;
reg[36:0] pix_9_reg;
reg[36:0] pix_10_reg;
reg[36:0] pix_11_reg;
reg[36:0] pix_12_reg;
reg[36:0] current_pix_reg;

assign gray_factor = {2'd0, {(din[7:0]>>2) + (din[15:8]>>1) + (din[23:16]>>2)}};

assign new_gray_factor_12 = gray_factor + err_12;
assign new_gray_factor_12_cliped = (new_gray_factor_12[9:9] == 1'b1) ? 10'd0 : (new_gray_factor_12[8:8] == 1'b1 ? 10'b001111111 : new_gray_factor_12);
always @(posedge clk or rst) begin
    if(rst)
        pix_12_reg <= 37'b0;
    else 
        pix_12_reg <= {new_gray_factor_12_cliped, v_cnt - 12'd4, h_cnt - 12'd88 - 12'd44 - 12'd148, de_in, vs_in, hs_in};
end

assign new_gray_factor_11 = pix_12_reg[36:27] + err_11;
assign new_gray_factor_11_cliped = (new_gray_factor_11[9:9] == 1'b1) ? 10'd0 : (new_gray_factor_11[8:8] == 1'b1 ? 10'b001111111 : new_gray_factor_11);
always @(posedge clk or rst) begin
    if(rst)
        pix_11_reg <= 37'b0;
    else
        pix_11_reg <= {new_gray_factor_11_cliped, pix_12_reg[26:0]};
end

assign new_gray_factor_10 = pix_11_reg[36:27] + err_10;
assign new_gray_factor_10_cliped = (new_gray_factor_10[9:9] == 1'b1) ? 10'd0 : (new_gray_factor_10[8:8] == 1'b1 ? 10'b001111111 : new_gray_factor_10);
always @(posedge clk or rst) begin
    if(rst)
        pix_10_reg <= 37'b0;
    else
        pix_10_reg <= {new_gray_factor_10_cliped, pix_11_reg[26:0]};
end

assign new_gray_factor_9  = pix_10_reg[36:27] + err_9;
assign new_gray_factor_9_cliped = (new_gray_factor_9[9:9] == 1'b1) ? 10'd0 : (new_gray_factor_9[8:8] == 1'b1 ? 10'b001111111 : new_gray_factor_9);
always @(posedge clk or rst) begin
    if(rst)
        pix_9_reg <= 37'b0;
    else
        pix_9_reg <= {new_gray_factor_9_cliped, pix_10_reg[26:0]};
end

assign new_gray_factor_8  = pix_10_reg[36:27] + err_8;
assign new_gray_factor_8_cliped = (new_gray_factor_8[9:9] == 1'b1) ? 10'd0 : (new_gray_factor_8[8:8] == 1'b1 ? 10'b001111111 : new_gray_factor_8);
always @(posedge clk or rst) begin
    if(rst)
        pix_8_reg <= 37'b0;
    else
        pix_8_reg <= {new_gray_factor_8_cliped, pix_9_reg[26:0]};
end

fifo_generator_0 fifo_ins_2(
.srst           (rst),
.wr_clk         (clk),
.rd_clk         (clk),
.din            (pix_8_reg),
.dout           (fifo2_dout),
.wr_en          (1'b1),
.rd_en          (1'b1),
.full           (full_2),
.empty          (empty_2)
);

assign new_gray_factor_7 = fifo2_dout[36:27] + err_7;
assign new_gray_factor_7_cliped = (new_gray_factor_7[9:9] == 1'b1) ? 10'd0 : (new_gray_factor_7[8:8] == 1'b1 ? 10'b001111111 : new_gray_factor_7);
always @(posedge clk or rst) begin
    if(rst)
        pix_7_reg <= 37'b0;
    else
        pix_7_reg <= {new_gray_factor_7_cliped, fifo2_dout[26:0]};
end

assign new_gray_factor_6  = pix_7_reg[36:27] + err_6;
assign new_gray_factor_6_cliped = (new_gray_factor_6[9:9] == 1'b1) ? 10'd0 : (new_gray_factor_6[8:8] == 1'b1 ? 10'b001111111 : new_gray_factor_6);
always @(posedge clk or rst) begin
    if(rst)
        pix_6_reg <= 37'b0;
    else
        pix_6_reg <= {new_gray_factor_6_cliped, pix_7_reg[26:0]};
end

assign new_gray_factor_5  = pix_6_reg[36:27] + err_5;
assign new_gray_factor_5_cliped = (new_gray_factor_5[9:9] == 1'b1) ? 10'd0 : (new_gray_factor_5[8:8] == 1'b1 ? 10'b001111111 : new_gray_factor_5);
always @(posedge clk or rst) begin
    if(rst)
        pix_5_reg <= 37'b0;
    else
        pix_5_reg <= {new_gray_factor_5_cliped, pix_6_reg[26:0]};
end

assign new_gray_factor_4  = pix_5_reg[36:27] + err_4;
assign new_gray_factor_4_cliped = (new_gray_factor_4[9:9] == 1'b1) ? 10'd0 : (new_gray_factor_4[8:8] == 1'b1 ? 10'b001111111 : new_gray_factor_4);
always @(posedge clk or rst) begin
    if(rst)
        pix_4_reg <= 37'b0;
    else
        pix_4_reg <= {new_gray_factor_4_cliped, pix_5_reg[26:0]};
end

assign new_gray_factor_3  = pix_4_reg[36:27] + err_3;
assign new_gray_factor_3_cliped = (new_gray_factor_3[9:9] == 1'b1) ? 10'd0 : (new_gray_factor_3[8:8] == 1'b1 ? 10'b001111111 : new_gray_factor_3);
always @(posedge clk or rst) begin
    if(rst)
        pix_3_reg <= 37'b0;
    else
        pix_3_reg <= {new_gray_factor_3_cliped, pix_4_reg[26:0]};
end

fifo_generator_0 fifo_ins_1(
.srst           (rst),
.wr_clk         (clk),
.rd_clk         (clk),
.din            (pix_3_reg),
.dout           (fifo1_dout),
.wr_en          (1'b1),
.rd_en          (1'b1),
.full           (full_1),
.empty          (empty_1)
);

assign new_gray_factor_2 = fifo1_dout[36:27] + err_2;
assign new_gray_factor_2_cliped = (new_gray_factor_2[9:9] == 1'b1) ? 10'd0 : (new_gray_factor_2[8:8] == 1'b1 ? 10'b001111111 : new_gray_factor_2);
always @(posedge clk or rst) begin
    if(rst)
        pix_2_reg <= 37'b0;
    else
        pix_2_reg <= {new_gray_factor_2_cliped, fifo1_dout[26:0]};
end

assign new_gray_factor_1  = pix_2_reg[36:27] + err_1;
assign new_gray_factor_1_cliped = (new_gray_factor_1[9:9] == 1'b1) ? 10'd0 : (new_gray_factor_1[8:8] == 1'b1 ? 10'b001111111 : new_gray_factor_1);
always @(posedge clk or rst) begin
    if(rst)
        pix_1_reg <= 37'b0;
    else
        pix_1_reg <= {new_gray_factor_1_cliped, pix_2_reg[26:0]};
end

always @(posedge clk or rst) begin
    if(rst)
        current_pix_reg <= 36'b0;
    else
        current_pix_reg = pix_1_reg;
end 

assign binarize_gray_factor = (current_pix_reg[36:27] < 10'd128) ? 10'd0 : 10'd0011111111;
assign quant_err = current_pix_reg[36:27] - binarize_gray_factor;

assign err_1 = current_pix_reg[2:2] == 1'b0 ? 10'd0 : (current_pix_reg[26:15] == 10'd1979 ? {{4{quant_err[9:9]}}, quant_err[9:4]} : {{4{quant_err[9:9]}}, quant_err[9:4]} + {{3{quant_err[9:9]}}, quant_err[9:3]} - {{5{quant_err[9:9]}}, quant_err[9:5]});

/*
always @(*) begin
    if(current_pix_reg[2:2] == 1'b0) begin
        err_1 = 10'd0;
    end
    else if(current_pix_reg[26:15] == 10'd1979) begin
        //err_1 <= 3/48 * quant_err;
        err_1 = {{4{quant_err[9:9]}}, quant_err[9:4]};
    end
    else begin
        //err_1 <= 7/48 * quant_err;
        err_1 = {{4{quant_err[9:9]}}, quant_err[9:4]} + {{3{quant_err[9:9]}}, quant_err[9:3]} - {{5{quant_err[9:9]}}, quant_err[9:5]};
    end
end
*/
assign err_2 = current_pix_reg[2:2] == 1'b0 ? 10'd0 : (current_pix_reg[26:15] == 10'd1978 ? {{4{quant_err[9:9]}}, quant_err[9:4]} : {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]});
/*
always @(*) begin
    if(current_pix_reg[2:2] == 1'b0) begin
        err_2 <= 10'd0;
    end
    else if(current_pix_reg[26:15] == 10d'1978) begin
        //err_2 <= 3/48 * quant_err;
        err_2 <= {{4{quant_err[9:9]}}, quant_err[9:4]};
    end
    else begin
        //err_2 <= 5/48 * quant_err;
        err_2 <= {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]};
    end
end
*/
assign err_3 = current_pix_reg[2:2] == 1'b0 ? 10'd0 : (current_pix_reg[26:15] == 10'd0 ? {{4{quant_err[9:9]}}, quant_err[9:4]} + {{3{quant_err[9:9]}}, quant_err[9:3]} - {{5{quant_err[9:9]}}, quant_err[9:5]} : ((current_pix_reg[26:15] == 10'd1 || current_pix_reg[26:15] == 10'd1978) ? {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]} : (current_pix_reg[26:15] == 10'd1979 ? {{4{quant_err[9:9]}}, quant_err[9:4]} + {{3{quant_err[9:9]}}, quant_err[9:3]} - {{5{quant_err[9:9]}}, quant_err[9:5]} : {{4{quant_err[9:9]}}, quant_err[9:4]})));
/*
always @(*) begin
    if(current_pix_reg[2:2] == 1'b0) begin
        err_3 <= 10d'0;
    end
    else if(current_pix_reg[26:15] == 10'd0) begin
        //err_3 <= 7/48 * quant_err;
        err_3 <= {{4{quant_err[9:9]}}, quant_err[9:4]} + {{3{quant_err[9:9]}}, quant_err[9:3]} - {{5{quant_err[9:9]}}, quant_err[9:5]};
    end
    else if(current_pix_reg[26:15] == 10'd1) begin
        //err_3 <= 5/48 * quant_err;
        err_3 <={{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]};
    end
    else if(current_pix_reg[26:15] == 10'd1978) begin
        //err_3 <= 5/48 * quant_err;
        err_3 <={{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]};
    end
    else if(current_pix_reg[26:15] == 10'd1979) begin
        //err_3 <= 7/58 * quant_err;
        err_3 <= {{4{quant_err[9:9]}}, quant_err[9:4]} + {{3{quant_err[9:9]}}, quant_err[9:3]} - {{5{quant_err[9:9]}}, quant_err[9:5]};
    end
    else begin
        //err_3 <= 3/48 * quant_err;
        err_3 <= {{4{quant_err[9:9]}}, quant_err[9:4]};
    end
end
*/

assign err_4 = current_pix_reg[2:2] == 1'b0 ? 10'd0 : (current_pix_reg[26:15] == 10'd0 ? {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]} : ((current_pix_reg[26:15] == 10'd1 || current_pix_reg[26:15] == 10'd1978) ? {{4{quant_err[9:9]}}, quant_err[9:4]} + {{3{quant_err[9:9]}}, quant_err[9:3]} - {{5{quant_err[9:9]}}, quant_err[9:5]} : (current_pix_reg[26:15] == 10'd1979 ? err_4 = {{6{quant_err[9:9]}}, quant_err[9:6]} + {{7{quant_err[9:9]}}, quant_err[9:7]} : {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]})));
/*
always @(*) begin
    if(current_pix_reg[2:2] == 1'b0) begin
        err_4 <= 10d'0;
    end
    else if(current_pix_reg[26:15] == 10'd0) begin
        //err_4 <= 5/48 * quant_err;
        err_4 <= {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]};
    end
    else if(current_pix_reg[26:15] == 10'd1) begin
        //err_4 <= 7/48 * quant_err;
        err_4 = {{4{quant_err[9:9]}}, quant_err[9:4]} + {{3{quant_err[9:9]}}, quant_err[9:3]} - {{5{quant_err[9:9]}}, quant_err[9:5]};
    end
    else if(current_pix_reg[26:15] == 10'd1978) begin
        //err_4 <= 7/48 * quant_err;
        err_4 = {{4{quant_err[9:9]}}, quant_err[9:4]} + {{3{quant_err[9:9]}}, quant_err[9:3]} - {{5{quant_err[9:9]}}, quant_err[9:5]};
    end
    else if(current_pix_reg[26:15] == 10'd1979) begin
        //err_4 <= 1/58 * quant_err;
        err_4 = {{6{quant_err[9:9]}}, quant_err[9:6]} + {{7{quant_err[9:9]}}, quant_err[9:7]};
    end
    else begin
        //err_4 <= 5/48 * quant_err;
        err_4 <= {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]};
    end
end
*/

//assign err_ 5 = current_pix_reg[2:2] == 1'b0 ? 10'd0 : ((current_pix_reg[26:15] == 10'd1 || current_pix_reg[26:15] == 10'd1978) ? ({{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]}) : ((current_pix_reg[26:15] == 10'd1979) ? ({{4{[9:9]}}, quant_err[9:4]}) : ({{4{quant_err[9:9]}}, quant_err[9:4]} + {{3{quant_err[9:9]}}, quant_err[9:3]} - {{5{quant_err[9:9]}}, quant_err[9:5]})));

assign err_5 = current_pix_reg[2:2] == 1'b0 ? 10'd0 : ((current_pix_reg[26:15] == 10'd0 || current_pix_reg[26:15] == 10'd1979) ? {{4{quant_err[9:9]}}, quant_err[9:4]} : (current_pix_reg[26:15] == 10'd1 || current_pix_reg[26:15] == 10'd1978) ? {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]} : {{4{quant_err[9:9]}}, quant_err[9:4]} + {{3{quant_err[9:9]}}, quant_err[9:3]} - {{5{quant_err[9:9]}}, quant_err[9:5]});
/*
always @(*) begin
    if(current_pix_reg[2:2] == 1'b0) begin
        err_5 <= 10d'0;
    end
    else if(current_pix_reg[26:15] == 10'd0) begin
        //err_5 <= 3/48 * quant_err;
        err_5 <= {{4{quant_err[9:9]}}, quant_err[9:4]};
    end
    else if(current_pix_reg[26:15] == 10'd1) begin
        //err_5 <= 5/48 * quant_err;
        err_5 <= {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]};
    end
    else if(current_pix_reg[26:15] == 10'd1978) begin
        //err_5 <= 5/48 * quant_err;
        err_5 <= {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]};
    end
    else if(current_pix_reg[26:15] == 10'd1979) begin
        //err_5 <= 3/48 * quant_err;
        err_5 <= {{4{quant_err[9:9]}}, quant_err[9:4]};
    end
    else begin
        //err_5 <= 7/48 * quant_err;
        err_5 = {{4{quant_err[9:9]}}, quant_err[9:4]} + {{3{quant_err[9:9]}}, quant_err[9:3]} - {{5{quant_err[9:9]}}, quant_err[9:5]};
    end
end
*/

assign err_6 = current_pix_reg[2:2] == 1'b0 ? 10'd0 : (current_pix_reg[26:15] == 10'd0 ? {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]} : (current_pix_reg[26:15] == 10'd1 ? {{4{quant_err[9:9]}}, quant_err[9:4]} : (current_pix_reg[26:15] == 10'd1978 ? {{6{quant_err[9:9]}}, quant_err[9:6]} + {{7{quant_err[9:9]}}, quant_err[9:7]} : {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]})));
/*
always @(*) begin
    if(current_pix_reg[2:2] == 1'b0) begin
        err_6 <= 10d'0;
    end
    else if(current_pix_reg[26:15] == 10'd0) begin
        //err_6 <= 5/48 * quant_err;
        err_6 <= {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]};
    end
    else if(current_pix_reg[26:15] == 10'd1) begin
        //err_6 <= 3/48 * quant_err;
        err_6 <= {{4{quant_err[9:9]}}, quant_err[9:4]};
    end
    else if(current_pix_reg[26:15] == 10'd1978) begin
        //err_6 <= 1/48 * quant_err;
        err_6 = {{6{quant_err[9:9]}}, quant_err[9:6]} + {{7{quant_err[9:9]}}, quant_err[9:7]};
    end
    else if(current_pix_reg[26:15] == 10'd1979) begin
        //err_6 <= 5/48 * quant_err;
        err_6 <= {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]};
    end
    else begin
        //err_6 <= 5/48 * quant_err;
        err_6 <= {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]};
    end
end
*/
assign err_7 = (current_pix_reg[2:2] == 1'b0 || current_pix_reg[26:15] == 10'd1979) ? 10'd0 : (current_pix_reg[26:15] == 10'd1978 ? {{4{quant_err[9:9]}}, quant_err[9:5]} : {{4{quant_err[9:9]}}, quant_err[9:4]});
/*
always @(*) begin
    if(current_pix_reg[2:2] == 1'b0) begin
        err_7 <= 10d'0;
    end
    else if(current_pix_reg[26:15] == 10'd0) begin
        //err_7 <= 3/48 * quant_err;
        err_7 <= {{4{quant_err[9:9]}}, quant_err[9:4]};
    end
    else if(current_pix_reg[26:15] == 10'd1) begin
        //err_7 <= 3/48 * quant_err;
        err_7 <= {{4{quant_err[9:9]}}, quant_err[9:4]};
    end
    else if(current_pix_reg[26:15] == 10'd1978) begin
        //err_7 <= 3/48 * quant_err;
        err_7 <= {{4{quant_err[9:9]}}, quant_err[9:5]};
    end
    else if(current_pix_reg[26:15] == 10'd1979) begin
        err_7 <= 10'd0;
    end
    else begin
        //err_7 <= 3/48 * quant_err;
        err_7 <= {{4{quant_err[9:9]}}, quant_err[9:4]};
    end
end
*/

assign err_8 = (current_pix_reg[2:2] == 1'b0 || current_pix_reg[26:15] == 10'd1979) ? 10'd0 : ((current_pix_reg[26:15] == 10'd1 || current_pix_reg[26:15] == 10'd1978) ? {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]} : {{6{quant_err[9:9]}}, quant_err[9:6]} + {{7{quant_err[9:9]}}, quant_err[9:7]});

/*
always @(*) begin
    if(current_pix_reg[2:2] == 1'b0) begin
        err_8 <= 10d'0;
    end
    else if(current_pix_reg[26:15] == 10'd0) begin
        //err_8 <= 1/48 * quant_err;
        err_8 = {{6{quant_err[9:9]}}, quant_err[9:6]} + {{7{quant_err[9:9]}}, quant_err[9:7]};
    end
    else if(current_pix_reg[26:15] == 10'd1) begin
        //err_8 <= 5/48 * quant_err;
        err_8 <= {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]};
    end
    else if(current_pix_reg[26:15] == 10'd1978) begin
        //err_8 <= 5/48 * quant_err;
        err_8 <= {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]};
    end
    else if(current_pix_reg[26:15] == 10'd1979) begin
        err_8 <= 10'd0;
    end
    else begin
        //err_8 <= 1/48 * quant_err;
        err_8 = {{6{quant_err[9:9]}}, quant_err[9:6]} + {{7{quant_err[9:9]}}, quant_err[9:7]};
    end
end
*/

assign err_9 = (current_pix_reg[2:2] == 1'b0 || current_pix_reg[26:15] == 10'd1979 || current_pix_reg[26:15] == 10'd0) ? 10'd0 : {{4{quant_err[9:9]}}, quant_err[9:4]};
/*
always @(*) begin
    if(current_pix_reg[2:2] == 1'b0) begin
        err_9 <= 10d'0;
    end
    else if(current_pix_reg[26:15] == 10'd0) begin
        err_9 <= 10'd0;
    end
    else if(current_pix_reg[26:15] == 10'd1) begin
        //err_9 <= 3/48 * quant_err;
        err_9 <= {{4{quant_err[9:9]}}, quant_err[9:4]};
    end
    else if(current_pix_reg[26:15] == 10'd1978) begin
        //err_9 <= 3/48 * quant_err;
        err_9 <= {{4{quant_err[9:9]}}, quant_err[9:4]};
    end
    else if(current_pix_reg[26:15] == 10'd1979) begin
        err_9 <= 10'd0;
    end
    else begin
        //err_9 <= 3/48 * quant_err;
        err_9 <= {{4{quant_err[9:9]}}, quant_err[9:4]};
    end
end
*/

assign err_10 = (current_pix_reg[2:2] == 1'b0 || current_pix_reg[26:15] == 10'd1979 || current_pix_reg[26:15] == 10'd0 || current_pix_reg[26:15] == 10'd1978) ? 10'd0 : (current_pix_reg[26:15] == 10'd1 ? {{6{quant_err[9:9]}}, quant_err[9:6]} + {{7{quant_err[9:9]}}, quant_err[9:7]} : {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]});
/*
always @(*) begin
    if(current_pix_reg[2:2] == 1'b0) begin
        err_10 <= 10d'0;
    end
    else if(current_pix_reg[26:15] == 10'd0) begin
        err_10 <= 10'd0;
    end
    else if(current_pix_reg[26:15] == 10'd1) begin
        //err_10 <= 1/48 * quant_err;
        err_10 <= {{6{quant_err[9:9]}}, quant_err[9:6]} + {{7{quant_err[9:9]}}, quant_err[9:7]};
    end
    else if(current_pix_reg[26:15] == 10'd1978) begin
        err_10 <= 10'd0;
    end
    else if(current_pix_reg[26:15] == 10'd1979) begin
        err_10 <= 10'd0;
    end
    else begin
        //err_10 <= 5/48 * quant_err;
        err_10 <= {{3{quant_err[9:9]}}, quant_err[9:3]} - {{6{quant_err[9:9]}}, quant_err[9:6]};
    end
end
*/

assign err_11 = (current_pix_reg[2:2] == 1'b0 || current_pix_reg[26:15] == 10'd1979 || current_pix_reg[26:15] == 10'd0 || current_pix_reg[26:15] == 10'd1 || current_pix_reg[26:15] == 10'd1978) ? 10'd0 : {{4{quant_err[9:9]}}, quant_err[9:4]};
/*
always @(*) begin
    if(current_pix_reg[2:2] == 1'b0) begin
        err_11 <= 10'd0;
    end
    else if(current_pix_reg[26:15] == 10'd0) begin
        err_11 <= 10'd0;
    end
    else if(current_pix_reg[26:15] == 10'd1) begin
        err_11 <= 10'd0;
    end
    else if(current_pix_reg[26:15] == 10'd1978) begin
        err_11 <= 10'd0;
    end
    else if(current_pix_reg[26:15] == 10'd1979) begin
        err_11 <= 10'd0;
    end
    else begin
        //err_11 <= 3/48 * quant_err;
        err_11 <= {{4{quant_err[9:9]}}, quant_err[9:4]};
    end
end
*/

assign err_12 =  (current_pix_reg[2:2] == 1'b0 || current_pix_reg[26:15] == 10'd1979 || current_pix_reg[26:15] == 10'd0 || current_pix_reg[26:15] == 10'd1 || current_pix_reg[26:15] == 10'd1978) ? 10'd0 : {{6{quant_err[9:9]}}, quant_err[9:6]} + {{7{quant_err[9:9]}}, quant_err[9:7]};
/*
always @(*) begin
    if(current_pix_reg[2:2] == 1'b0) begin
        err_12 <= 10d'0;
    end
    else if(current_pix_reg[26:15] == 10'd0) begin
        err_12 <= 10'd0;
    end
    else if(current_pix_reg[26:15] == 10'd1) begin
        err_12 <= 10'd0;
    end
    else if(current_pix_reg[26:15] == 10'd1978) begin
        err_12 <= 10'd0;
    end
    else if(current_pix_reg[26:15] == 10'd1979) begin
        err_12 <= 10'd0;
    end
    else begin
        //err_12 <= 1/48 * quant_err;
        err_12 = {{6{quant_err[9:9]}}, quant_err[9:6]} + {{7{quant_err[9:9]}}, quant_err[9:7]};
    end
end
*/
assign vs_out = current_pix_reg[1:1];
assign hs_out = current_pix_reg[0:0];
assign de_out = current_pix_reg[2:2];
assign dout = {3{binarize_gray_factor[7:0]}};

//*************************
// pix_reg pack the gray_factor:10bit \  v_cnt:12bit \ h_cnt:12bit\ de:1bit \ vs:1bit \ hs:1bit;
// gray_factor = pix_reg[36:27]; v_cnt = pix_reg[26:15]; h_cnt = pix_reg[14:3]; de = pix_reg[2:2]; vs = pix_reg[1:1]; hs = pix_reg[0:0];
//  ____________________________________________________________________________
// |    gray_factor   |     v_cnt   |    h_cnt   |    de    |    vs   |    hs   |
// |    10bit         |     12bit   |    12bit   |   1bit   |   1bit  |   1bit  |
//  ____________________________________________________________________________
//*************************

endmodule