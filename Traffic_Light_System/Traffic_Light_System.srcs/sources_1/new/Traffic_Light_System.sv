`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2024 03:44:33 PM
// Design Name: 
// Module Name: Traffic_Light_System
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

typedef enum {RED=0,GREEN=1,YELLOW=2} light;

class TrafficLight;
    local light color [2:0];
    local logic [5:0] time_value [2:0];
    
    //constructor
    function new();
        time_value[2]=6'd5;
        time_value[1]=6'd3;
        time_value[0]=6'd2;
        color[2]=RED;
        color[1]=GREEN;
        color[0]=YELLOW;
    endfunction
endclass

module Traffic_Light_System(
    input clk,rst,changemode,inc,dec,setup
    );
endmodule
