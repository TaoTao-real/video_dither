`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/29/2020 01:15:19 PM
// Design Name: 
// Module Name: q_err
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


(* keep_hierarchy = "yes" *) module q_err(
    //Input
    clk             ,
    en              ,
    w_addr_k        ,
    w_addr_kmin1    ,
    w_din_k         ,
    w_din_kmin1     ,
    r_addr_k        ,
    r_addr_kmin1    ,
    //Output
    r_dout_k        ,
    r_dout_kmin1    ,
    );
input            clk;
input            en;
input[11:0]      w_addr_k;
input[11:0]      w_addr_kmin1;
input[9:0]       w_din_k;
input[9:0]       w_din_kmin1;
input[11:0]      r_addr_k;
input[11:0]      r_addr_kmin1;

output[9:0]      r_dout_k;
output[9:0]      r_dout_kmin1;

wire[10:0]      even_ram_w_addr;
wire[9:0]       even_ram_w_din;
wire[10:0]      even_ram_r_addr;
wire[9:0]       even_ram_r_dout;

wire[10:0]      odd_ram_w_addr;
wire[9:0]       odd_ram_w_din;
wire[10:0]      odd_ram_r_addr;
wire[9:0]       odd_ram_r_dout;

assign even_ram_w_addr = (w_addr_k[0]==1'b0) ? w_addr_k[11:1] : w_addr_kmin1[11:1];
assign even_ram_w_din = (w_addr_k[0]==1'b0) ? w_din_k : w_din_kmin1;
assign even_ram_r_addr = (r_addr_k[0]==1'b0) ? r_addr_k[11:1] : r_addr_kmin1[11:1];

assign odd_ram_w_addr = (w_addr_k[0]==1'b1) ? w_addr_k[11:1] :w_addr_kmin1[11:1];
assign odd_ram_w_din = (w_addr_k[0]==1'b1) ? w_din_k : w_din_kmin1;
assign odd_ram_r_addr = (r_addr_k[0]==1'b1) ? r_addr_k[11:1] : r_addr_kmin1[11:1];

blk_mem_gen_0 even_ram
(
    .clka                   (clk),
    //.ena                    (1'b1),
    .wea                    (en),
    .addra                  (even_ram_w_addr),
    .dina                   (even_ram_w_din),
    .clkb                   (clk),
   // .enb                    (1'b1),
    .addrb                  (even_ram_r_addr),
    .doutb                  (even_ram_r_dout)
);

blk_mem_gen_0 odd_ram
(
    .clka                   (clk),
    //.ena                    (1'b1),
    .wea                    (en),
    .addra                  (odd_ram_w_addr),
    .dina                   (odd_ram_w_din),
    .clkb                   (clk),
    //.enb                    (1'b1),
    .addrb                  (odd_ram_r_addr),
    .doutb                  (odd_ram_r_dout)
);

assign r_dout_k = (r_addr_k[0]==1'b0)?even_ram_r_dout:odd_ram_r_dout;
assign r_dout_kmin1 = (r_addr_k[0]==1'b1)?even_ram_r_dout:odd_ram_r_dout;

endmodule
