`timescale 1ns / 1ps
//`include "D:\Traffic_Light_System\Traffic_Light_System\Traffic_Light_System.srcs\sim_1\new\Traffic_Light_System_tb.sv"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/01/2024 03:36:17 PM
// Design Name: 
// Module Name: Traffic_Light_System_tb
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
module Traffic_Light_System_tb;
    reg clk, rst, changemode, inc, dec, setup;
    color outcolorhor;
    color outcolorver;
    reg [6:0] outtimehor;
    reg [6:0] outtimever;
    
    Traffic_Light_System dut(.clk(clk),.rst(rst),.changemode(changemode),.inc(inc),.dec(dec),.setup(setup),.outcolorhor(outcolorhor),.outcolorver(outcolorver),.outtimehor(outtimehor),.outtimever(outtimever));
    
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    
    
    initial begin
        #0 rst=0;
        #1 rst=1;
        #1000 $finish;
    end
    
    always_ff @(posedge clk) begin
//        $display("%d %d %d %d %d", dut.current_state, outcolorhor, outtimehor, outcolorver, outtimever);
        $display("%d %d %d", dut.current_state, outtimehor, outtimever);
    end
endmodule
