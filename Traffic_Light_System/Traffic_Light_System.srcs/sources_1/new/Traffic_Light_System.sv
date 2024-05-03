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

typedef enum reg [1:0]{RED=0, GREEN=1, YELLOW=2} color;
typedef struct packed{
    reg [6:0] max_light_time;
    reg [6:0] current_light_time;
} struct_t;
typedef enum reg [2:0] {START=0, RED_GREEN = 1, RED_YELLOW = 2, GREEN_RED = 3, YELLOW_RED = 4, MANUAL_RED = 5, MANUAL_GREEN = 6, MANUAL_YELLOW = 7} state;

module Traffic_Light_System(
    input wire clk,rst,changemode,inc,dec,setup,
    output color outcolorhor, 
    output color outcolorver, 
    output reg [6:0] outtimehor,
    output reg [6:0] outtimever
    );
    state current_state, next_state;
    struct_t red,green,yellow;
    reg change;
    
    function automatic void decrement(ref struct_t col);
        col.current_light_time <= col.current_light_time - 1;
    endfunction
    
    function automatic void decrementmanual(ref struct_t col);
        col.current_light_time <= col.current_light_time - 1;
        col.max_light_time <= col.max_light_time - 1;
    endfunction
    
    function automatic void incrementmanual(ref struct_t col);
        col.current_light_time <= col.current_light_time + 1;
        col.max_light_time <= col.max_light_time + 1;
    endfunction
    
    function automatic void setuptime(ref struct_t col, input logic [6:0] num);
        col.current_light_time <= num;
        col.max_light_time <= num;
    endfunction
    
    function automatic void resettime(ref struct_t col);
        col.current_light_time <= col.max_light_time;
    endfunction
    
    always_comb begin
        next_state=START;
        case(current_state)
            START: begin
                if(changemode) next_state=MANUAL_RED;
                else next_state=RED_GREEN;
            end
            
            RED_GREEN: begin
                if(changemode) begin
                    next_state=MANUAL_RED;
                end
                else begin
                    if(green.current_light_time <= 0) next_state=RED_YELLOW;
                    else next_state=RED_GREEN;
                end
            end
            
            RED_YELLOW: begin
                if(changemode) begin
                    next_state=MANUAL_RED;
                end
                else begin
                    if(yellow.current_light_time <= 0) next_state=GREEN_RED;
                    else next_state=RED_YELLOW;
                end
            end
            
            GREEN_RED: begin
                if(changemode) begin
                    next_state=MANUAL_RED;
                end
                else begin
                    if(green.current_light_time <= 0) next_state=YELLOW_RED;
                    else next_state=GREEN_RED;
                end
            end
            
            YELLOW_RED: begin
                if(changemode) begin
                    next_state=MANUAL_RED;
                end
                else begin
                    if(yellow.current_light_time <= 0) next_state=RED_GREEN;
                    else next_state=YELLOW_RED;
                end
            end
            
            MANUAL_RED: begin
                if(changemode) begin
                    next_state=MANUAL_GREEN;
                end
                else begin
                    if(setup) begin
                        next_state=RED_GREEN;
                    end
                    else next_state=MANUAL_RED;
                end
            end
            
            MANUAL_GREEN: begin
                if(changemode) begin
                    next_state=MANUAL_YELLOW;
                end
                else begin
                    if(setup) begin
                        next_state=RED_GREEN;
                    end
                    else next_state=MANUAL_GREEN;
                end
            end
            
            MANUAL_YELLOW: begin
                if(changemode) begin
                    next_state=MANUAL_RED;
                end
                else begin
                    if(setup) begin
                        next_state=RED_GREEN;
                    end
                    else next_state=MANUAL_YELLOW;
                end
            end
            
            default: next_state = START;
        endcase
    end
    
    always_ff @(posedge clk, negedge rst) begin
        if(~rst) begin
            current_state <= START;
        end
        else begin
            current_state <= next_state;
        end
    end
    
    always_ff @(posedge clk) begin
        case(current_state)
            START: begin
                setuptime(red,5);
                setuptime(green,3);
                setuptime(yellow,2);
                if(changemode) begin
                    setuptime(red,3);
                    setuptime(green,2);
                    setuptime(yellow,1);
                end
            end
            
            RED_GREEN: begin
                outcolorhor<=RED;
                outtimehor<=red.current_light_time;
                if(green.current_light_time <= 0) begin
                    resettime(green);
                    outcolorver<=YELLOW;
                    outtimever<=yellow.current_light_time;
                    decrement(yellow);
                end
                else begin
                    outcolorver<=GREEN;
                    outtimever<=green.current_light_time;
                    decrement(green);
                end
                decrement(red);
                if(changemode) begin
                    setuptime(red,3);
                    setuptime(green,2);
                    setuptime(yellow,1);
                end
            end
            
            RED_YELLOW: begin
                if(yellow.current_light_time <= 0) begin
                    resettime(yellow);
                    resettime(red);
                    outcolorhor<=GREEN;
                    outtimehor<=green.current_light_time;
                    outcolorver<=RED;
                    outtimever<=red.current_light_time;
                    decrement(green);
                    decrement(red);
                end
                else begin
                    outcolorhor<=RED;
                    outtimehor<=red.current_light_time;
                    outcolorver<=YELLOW;
                    outtimever<=yellow.current_light_time;
                    decrement(yellow);
                    decrement(red);
                end
                if(changemode) begin
                    setuptime(red,3);
                    setuptime(green,2);
                    setuptime(yellow,1);
                end
            end
            
            GREEN_RED: begin
                outcolorver<=RED;
                outtimever<=red.current_light_time;
                if(green.current_light_time <= 0) begin
                    resettime(green);
                    outcolorhor<=YELLOW;
                    outtimehor<=yellow.current_light_time;
                    decrement(yellow);
                end
                else begin
                    outcolorhor<=GREEN;
                    outtimehor<=green.current_light_time;
                    decrement(green);
                end
                decrement(red);
                if(changemode) begin
                    setuptime(red,3);
                    setuptime(green,2);
                    setuptime(yellow,1);
                end
            end
            
            YELLOW_RED: begin
                if(yellow.current_light_time <= 0) begin
                    resettime(yellow);
                    resettime(red);
                    outcolorhor<=RED;
                    outtimehor<=red.current_light_time;
                    outcolorver<=GREEN;
                    outtimever<=green.current_light_time;
                    decrement(red);
                    decrement(green);
                end
                else begin
                    outcolorhor<=YELLOW;
                    outtimehor<=yellow.current_light_time;
                    outcolorver<=RED;
                    outtimever<=red.current_light_time;
                    decrement(yellow);
                    decrement(red);
                end
                if(changemode) begin
                    setuptime(red,3);
                    setuptime(green,2);
                    setuptime(yellow,1);
                end
            end
            
            MANUAL_RED: begin
                if(dec) begin
                    decrementmanual(red);
                end
                else if(inc) begin
                    incrementmanual(red);
                end
            end
            
            MANUAL_GREEN: begin
                if(dec) begin
                    decrementmanual(green);
                end
                else if(inc) begin
                    incrementmanual(green);
                end
            end
            
            MANUAL_YELLOW: begin
                if(dec) begin
                    decrementmanual(yellow);
                end
                else if(inc) begin
                    incrementmanual(yellow);
                end
            end
            
            default: begin
            
            end
        endcase
    end
endmodule
