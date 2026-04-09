`timescale 1ns / 1ps

module d_ff(
    input D,        
    input clk,      
    input rst,
    output reg Q,   
    output notQ    
    );
    
    // Output starts low/0
    initial begin
        Q <= 1'b0;     // Q driver // non-blocking "<="
    end
    
   
    always @(posedge clk or posedge rst) begin  
        if (rst)
            Q <= 1'b0;
        else
            Q <= D;
    end
    
  
    assign notQ = ~Q;       // notQ driver
    
endmodule