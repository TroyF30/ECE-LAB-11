`timescale 1ns / 1ps

module jk_ff(
    input J,
    input K,
    input clk,  // clk is the clock input port of the JK module.
    input rst,
    output Q,
    output notQ
    );
    
    wire d_in;
    
    assign d_in = (J & notQ) | ((~K) & Q); // <-- review
    
    d_ff jk_dff(
        .D(d_in),
        .clk(clk),      
        .rst(rst),
        .Q(Q),         
        .notQ(notQ)    
    );
    
endmodule
