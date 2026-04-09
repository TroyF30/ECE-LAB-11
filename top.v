`timescale 1ns / 1ps

module top(
    input btnU, // Reset
    input btnC, // Input clock
    output [6:0] led    // Ripple counter stage 3,2, and 1
                        // Modulo counter state bit 2,1,0
                        // Modulo counter output
    );
    
    // Ripple Counter Wires: 
    //      - Hold the outputs of the three T flip-flop stages in the ripple counter
    wire rc_q0;     // normal Q outputs of stages 0, 1, 2   // stage 1 output
    wire rc_nq0;    // inverted outputs (notQ) of those same stages
    wire rc_q1;     // stage 2 output
    wire rc_nq1;
    wire rc_q2;     // // stage 3 output
    wire rc_nq2;
    
    // Modulo Counter Wires:
    //      - 
    wire mc_q0; // three stored state bits // if the modulo counter is currently at binary 101, then mc_q2 = 1; mc_q1 = 0; mc_q0 = 1 // keep track of where you are in the count
    wire mc_nq0;
    wire mc_q1;
    wire mc_nq1;
    wire mc_q2;
    wire mc_nq2;
    
    // Modulo Counter Helper Wires:
    //      - incrementer outputs for count + 1
    //      - carry chain from the full adders
    //      - terminal-count detect
    //      - next-state inputs for the D flip-flops
    wire mc_inc0;   // incrementer outputs for count + 1
    wire mc_inc1;
    wire mc_inc2;
    
    wire mc_c1;     // carry chain from full adders
    wire mc_c2;
    wire mc_c3;
    
    wire mc_tc;     // terminal count detect
    wire mc_d0;     // next-state input for state bit 0
    wire mc_d1;     // next-state input for state bit 1
    wire mc_d2;     // next-state input for state bit 2
    
    wire mc_out_d;  // next state INPUT for modulo output FF
    wire mc_out_nq;     // inverted output of modulo output FF
    
    
    // Modulo Output Wire:
    //      - 
    wire mc_out;        // clock divider output
                        // toggles whenever the counter reaches the terminal count
  
    t_ff rc0(
        .T(1'b1),
        .clk(btnC),
        .rst(btnU),
        .Q(rc_q0),
        .notQ(rc_nq0)
    );
    
    t_ff rc1(
        .T(1'b1),
        .clk(rc_q0),
        .rst(btnU),
        .Q(rc_q1),
        .notQ(rc_nq1)
    );
    
    t_ff rc2(
        .T(1'b1),
        .clk(rc_q1),
        .rst(btnU),
        .Q(rc_q2),
        .notQ(rc_nq2)
    );
    

    full_adder fa0(
        .A(mc_q0),
        .B(1'b1),
        .carryIn(1'b0),
        .Y(mc_inc0),     // sum bit
        .carryOut(mc_c1)
    );
        
    full_adder fa1(
        .A(mc_q1),
        .B(1'b0),
        .carryIn(mc_c1),
        .Y(mc_inc1),     // sum bit
        .carryOut(mc_c2)
    );
        
    full_adder fa2(
        .A(mc_q2),
        .B(1'b0),
        .carryIn(mc_c2),
        .Y(mc_inc2),     // sum bit
        .carryOut(mc_c3)
    );
    
    // Modulo Counter Terminal Count / Next-State Logic

   
    assign mc_tc = mc_q2 & mc_nq1 & mc_q0;   // mc_tc is our terminal count detect // current state = 101 
    
    assign mc_d0 = mc_tc ? 1'b0 : mc_inc0;
    // assign mc_d0 = btnU ? 1'b0 : (mc_tc ? 1'b0 : mc_inc0);  // next-state input for state bit 0
    assign mc_d1 = mc_tc ? 1'b0 : mc_inc1;
    // assign mc_d1 = btnU ? 1'b0 : (mc_tc ? 1'b0 : mc_inc1);  // next-state input for state bit 1
    assign mc_d2 = mc_tc ? 1'b0 : mc_inc2;
    // assign mc_d2 = btnU ? 1'b0 : (mc_tc ? 1'b0 : mc_inc2);  // next-state input for state bit 2
               // condition ? value_if_true : value_if_false
               
    assign mc_out_d = mc_tc ? mc_out_nq : mc_out;
    // assign mc_out_d = btnU ? 1'b0 : (mc_tc ? mc_out_nq : mc_out);   // next state INPUT for modulo output FF
    

    d_ff mc_ff0(
        .D(mc_d0),      // next-state input for state bit 0
        .clk(btnC),     // Input clock
        .Q(mc_q0),      // three stored state bitS: mc_q0, mc_q1, mc_q2
        .notQ(mc_nq0)   // inverse
    );
    
    d_ff mc_ff1(
        .D(mc_d1),
        .clk(btnC),
        .rst(btnU),
        .Q(mc_q1),
        .notQ(mc_nq1)
    );
    
    d_ff mc_ff2(
        .D(mc_d2),
        .clk(btnC),
        .rst(btnU),
        .Q(mc_q2),
        .notQ(mc_nq2)
    );
    
    d_ff mc_out_ff(
        .D(mc_out_d),
        .clk(btnC),
        .rst(btnU),
        .Q(mc_out),
        .notQ(mc_out_nq)
    );
    
    
    
    // Ripple Counter led --> wire assignments
    assign led[0] = rc_q0;
    assign led[1] = rc_q1;
    assign led[2] = rc_q2;
    
    // Modulo counter led --> wire assignments
    assign led[3] = mc_q0;
    assign led[4] = mc_q1;
    assign led[5] = mc_q2;

    assign led[6] = mc_out;
    
    
    
endmodule