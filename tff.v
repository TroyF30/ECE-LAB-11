`timescale 1ns / 1ps

module t_ff(
    input T,        
    input clk,      
    input rst,
    output Q,
    output notQ
    );
    
    // T FF implemented using JK FF:
    // T=0 -> J=K=0 -> hold
    // T=1 -> J=K=1 -> toggle
    jk_ff t_jkff(
        .J(T),
        .K(T),
        .clk(clk),
        .rst(rst),
        .Q(Q),
        .notQ(notQ)
    );
    
endmodule