`include "stack_structural.sv"
//iverilog -g2012 -o out.txt stack_structural_tb.sv && vvp out.txt

module stack_structural_tb;
    reg RESET, CLK;
    reg [1:0] COMMAND;
    reg [2:0] INDEX;
    wire [3:0] IO_DATA;
    reg [3:0] DATA;
    assign IO_DATA = DATA;
    stack_structural_normal stack_test(.RESET(RESET), .CLK(CLK), .COMMAND(COMMAND), .INDEX(INDEX), .IO_DATA(IO_DATA));
    int errors = 0;
    initial begin
       //#100; $monitor("time %0d: RESET=%b, CLK=%b, COMMAND=%b, INDEX=%b, IO_DATA=%b", $time, RESET, CLK, COMMAND, INDEX, IO_DATA);
        INDEX = 3'b000; COMMAND = 2'b00; CLK = 0; RESET = 0;
        #1;
        RESET = 1; #1; RESET = 0; #1;
        DATA = 4'b0000; 
        #1; CLK = 1; #1 CLK = 0; #1;

        COMMAND = 2'b01; 
        DATA = 4'b0001; #1; CLK = 1; 
        #1 CLK = 0; #1;
        DATA = 4'b0010; #1; CLK = 1; 
        #1 CLK = 0; #1;
        DATA = 4'b0011; #1; CLK = 1; 
        #1 CLK = 0; #1;
        DATA = 4'b0100; #1; CLK = 1; 
        #1 CLK = 0; #1;
        DATA = 4'b0101; #1; CLK = 1; 
        #1 CLK = 0; #1;
        DATA = 4'b0110; #1; CLK = 1; 
        #1 CLK = 0; #1;
        DATA = 4'bZZZZ;

        COMMAND = 2'b10; #1; CLK = 1; 
        #1; if(IO_DATA != 4'b0110) errors++; 
        #1; CLK = 0; 
        #1; if(IO_DATA != 4'bZZZZ) errors++; 
        #1; CLK = 1; 
        #1; if(IO_DATA != 4'b0101) errors++; 
        #1; CLK = 0; 
        #1; if(IO_DATA != 4'bZZZZ) errors++;

        COMMAND = 2'b11; 
        #1; INDEX = 3'b000; #1; CLK = 1; 
        #1; if(IO_DATA != 4'b0100) errors++;
        #1; CLK = 0; 
        #1; if(IO_DATA != 4'bZZZZ) errors++;
        #1; INDEX = 3'b001; #1; CLK = 1; 
        #1; if(IO_DATA != 4'b0011) errors++; 
        #1; CLK = 0;
        #1; if(IO_DATA != 4'bZZZZ) errors++;
        #1; INDEX = 3'b010; #1; CLK = 1; 
        #1; if(IO_DATA != 4'b0010) errors++; 
        #1; CLK = 0;
        #1; if(IO_DATA != 4'bZZZZ) errors++;
        #1; INDEX = 3'b011; #1; CLK = 1; 
        #1; if(IO_DATA != 4'b0110) errors++; 
        #1; CLK = 0;
        #1; if(IO_DATA != 4'bZZZZ) errors++;

        COMMAND = 2'b01; 
        DATA = 4'b1000; #1; CLK = 1; 
        #1 CLK = 0; #1;
        DATA = 4'b1001; #1; CLK = 1;
        #1 CLK = 0; #1;
        DATA = 4'b1010; #1; CLK = 1;
        #1 CLK = 0; #1 
        DATA = 4'bZZZZ;

        COMMAND = 2'b10; #1; CLK = 1; 
        #1; if(IO_DATA != 4'b1010) errors++; 
        #1; CLK = 0; 
        #1; if(IO_DATA != 4'bZZZZ) errors++;
        #1; CLK = 1; 
        #1; if(IO_DATA != 4'b1001) errors++; 
        #1; CLK = 0; 
        #1; if(IO_DATA != 4'bZZZZ) errors++; 

        COMMAND = 2'b11; 
        #1; INDEX = 3'b000; #1; CLK = 1; 
        #1; if(IO_DATA != 4'b1000) errors++;
        #1; CLK = 0; 
        #1; if(IO_DATA != 4'bZZZZ) errors++;
        #1; INDEX = 3'b001; #1; CLK = 1; 
        #1; if(IO_DATA != 4'b0100) errors++; 
        #1; CLK = 0;
        #1; if(IO_DATA != 4'bZZZZ) errors++;
        #1; INDEX = 3'b010; #1; CLK = 1; 
        #1; if(IO_DATA != 4'b0011) errors++; 
        #1; CLK = 0;
        #1; if(IO_DATA != 4'bZZZZ) errors++;
        #1; INDEX = 3'b011; #1; CLK = 1; 
        #1; if(IO_DATA != 4'b1010) errors++; 
        #1; CLK = 0;
        #1; if(IO_DATA != 4'bZZZZ) errors++;
        #1; INDEX = 3'b100; #1; CLK = 1; 
        #1; if(IO_DATA != 4'b1001) errors++; 
        #1; CLK = 0;
        #1; if(IO_DATA != 4'bZZZZ) errors++;
        #1; INDEX = 3'b101; #1; CLK = 1; 
        #1; if(IO_DATA != 4'b1000) errors++; 
        #1; CLK = 0;
        #1; if(IO_DATA != 4'bZZZZ) errors++;
        #1; INDEX = 3'b110; #1; CLK = 1; 
        #1; if(IO_DATA != 4'b0100) errors++; 
        #1; CLK = 0;
        #1; if(IO_DATA != 4'bZZZZ) errors++;
        #1; INDEX = 3'b111; #1; CLK = 1; 
        #1; if(IO_DATA != 4'b0011) errors++; 
        #1; CLK = 0;
        #1; if(IO_DATA != 4'bZZZZ) errors++;


        if (errors) $display("Incorrect implenmentation of stack");
        else $display("Correct implenmentation of stack");
    end

endmodule

module RStrigger_tb;
    reg R, C, S, reset; wire Q, notQ;
    RStrigger rst_test(.Q(Q), .notQ(notQ), .R(R), .C(C), .S(S), .reset(reset));
    int errors = 0;

    initial begin
        //#100; $monitor("time %0d: R=%b, C=%b, S=%b, reset=%b, Q=%b, notQ=%b", $time, R, C, S, reset, Q, notQ);
        reset = 0; R = 0; C = 0; S = 0; 
        reset = 1;
        #1; if (Q) errors++;
        reset = 0; S = 1;
        #1; if (Q) errors++;
        C = 1;
        #1; if (!Q) errors++;
        C = 0; S = 0; R = 1;
        #1; if (!Q) errors++;
        C = 1;
        #1; if(Q) errors++;

        C = 0; S = 1; R = 0;
        #1 C = 1;
        #1; if(!Q) errors++;
        reset = 1;
        #1; if(Q) errors++;
        #1;
        if (errors) $display("Incorrect implenmentation of RStrigger");
        else $display("Correct implenmentation of RStrigger");
    end 
endmodule

module twoToFour_tb;
    reg A0, A1; wire Q0, Q1, Q2, Q3;
    twoToFour twoToFour_test(.A0(A0), .A1(A1), .Q0(Q0), .Q1(Q1), .Q2(Q2), .Q3(Q3));
    int errors = 0;

    initial begin
        //#100; $monitor("time %0d: A0=%b, A1=%b, Q0=%b, Q1=%b, Q2=%b, Q3=%b", $time, A0, A1, Q0, Q1, Q2, Q3);
        A0 = 0; A1 = 0;
        #1; if(!Q0) errors++;
        if(Q1) errors++;
        if(Q2) errors++;
        if(Q3) errors++;
        A0 = 1;
        #1; if(Q0) errors++;
        if(!Q1) errors++;
        if(Q2) errors++;
        if(Q3) errors++;
        A0 = 0; A1 = 1;
        #1; if(Q0) errors++;
        if(Q1) errors++;
        if(!Q2) errors++;
        if(Q3) errors++;
        A0 = 1;
        #1; if(Q0) errors++;
        if(Q1) errors++;
        if(Q2) errors++;
        if(!Q3) errors++;
        #1; if (errors) $display("Incorrect implenmentation of TwoToFour");
        else $display("Correct implenmentation of TwoToFour");
    end
endmodule

module Dtrigger_tb;
    reg D, C, reset; wire Q, notQ;
    Dtrigger dt_test(.Q(Q), .notQ(notQ), .D(D), .C(C), .reset(reset));
    int errors = 0;

    initial begin
        //#100; $monitor("time %0d: D=%b, C=%b, reset=%b, Q=%b, notQ=%b", $time, D, C, reset, Q, notQ);
        reset = 0; D = 0; C = 0; 
        reset = 1;
        #1; if(Q) errors++;
        reset = 0;
        #1; if(Q) errors++;
        reset = 0; 
        C = 1;
        #1; if(Q) errors++;
        C = 0; D = 1;
        #1; if(Q) errors++;
        C = 1;
        #1; if(!Q) errors++;
        C = 0; D = 0;
        #1; if(!Q) errors++;

        D = 1;
        #1; if(!Q) errors++;
        reset = 1;
        #1; if(Q) errors++;

        #1; if (errors) $display("Incorrect implenmentation of Dtrigger");
        else $display("Correct implenmentation of Dtrigger");
    end 
endmodule

module DtriggerFront_tb;
    reg D, C, reset; wire Q, notQ;
    DtriggerFront dtf_test(.Q(Q), .notQ(notQ), .D(D), .C(C), .reset(reset));
    int errors = 0;

    initial begin
        //#150; $monitor("time %0d: D=%b, C=%b, reset=%b, Q=%b, notQ=%b", $time, D, C, reset, Q, notQ);
        reset = 0; D = 0; C = 0; 
        reset = 1;
        #1; if(Q) errors++;
        reset = 0;
        #1; if(Q) errors++;
        D = 1;
        #1; if(Q) errors++;
        C = 1;
        #1; if(Q) errors++;
        C = 0;
        #1; if(!Q) errors++;
        D = 0;
        #1; if(!Q) errors++;
        C = 1;
        #1; if(!Q) errors++;
        C = 0;
        #1; if(Q) errors++;

        D = 1;
        #1 C = 1;
        #1 C = 0;
        #1; if(!Q) errors++;
        reset = 1;
        #1; if(Q) errors++;
        
        #1; if (errors) $display("Incorrect implenmentation of DtriggerFront");
        else $display("Correct implenmentation of DtriggerFront");
    end 
endmodule

module counterMod5next_tb;
    reg plusOrMinus, C, reset; wire [4:0] Q;
    counterMod5next counterMod5next_test(.Q(Q), .C(C), .reset(reset), .plusOrMinus(plusOrMinus));
    int errors = 0;

    initial begin
        //#150; $monitor("time %0d: plusOrMinus=%b, C=%b, reset=%b, Q=%b", $time, plusOrMinus, C, reset, Q);
        reset = 0; plusOrMinus = 0; C = 0; 
        reset = 1;
        #1; reset = 0;
        #1; if(!Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        C = 1; #1; C = 0;
        #1; if(Q[0]) errors++;
        if(!Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        C = 1; #1; C = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(!Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        C = 1; #1; C = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(!Q[3]) errors++;
        if(Q[4]) errors++;
        C = 1; #1; C = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(!Q[4]) errors++;
        C = 1; #1; C = 0;
        #1; if(!Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        plusOrMinus = 1; #1; C = 1; #1; C = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(!Q[4]) errors++;
        C = 1; #1; C = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(!Q[3]) errors++;
        if(Q[4]) errors++;
        C = 1; #1; C = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(!Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        C = 1; #1; C = 0;
        #1; if(Q[0]) errors++;
        if(!Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        C = 1; #1; C = 0;
        #1; if(!Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        
        #1; if (errors) $display("Incorrect implenmentation of counterMod5next");
        else $display("Correct implenmentation of counterMod5next");
    end 
endmodule

module counterMod5current_tb;
    reg plusOrMinus, C, reset; wire [4:0] Q;
    counterMod5current counterMod5current_test(.Q(Q), .C(C), .reset(reset), .plusOrMinus(plusOrMinus));
    int errors = 0;

    initial begin
        //#150; $monitor("time %0d: plusOrMinus=%b, C=%b, reset=%b, Q[0]=%b, Q[1]=%b, Q[2]=%b, Q[3]=%b, Q[4]=%b", $time, plusOrMinus, C, reset, Q[0], Q[1], Q[2], Q[3], Q[4]);
        reset = 0; plusOrMinus = 0; C = 0; 
        reset = 1;
        #1; reset = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(!Q[4]) errors++;
        C = 1; #1; C = 0;
        #1; if(!Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        C = 1; #1; C = 0;
        #1; if(Q[0]) errors++;
        if(!Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        C = 1; #1; C = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(!Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        C = 1; #1; C = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(!Q[3]) errors++;
        if(Q[4]) errors++;
        C = 1; #1; C = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(!Q[4]) errors++;
        plusOrMinus = 1; #1; C = 1; #1; C = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(!Q[3]) errors++;
        if(Q[4]) errors++;
        C = 1; #1; C = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(!Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        C = 1; #1; C = 0;
        #1; if(Q[0]) errors++;
        if(!Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        C = 1; #1; C = 0;
        #1; if(!Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        C = 1; #1; C = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(!Q[4]) errors++;
        
        #1; if (errors) $display("Incorrect implenmentation of counterMod5current");
        else $display("Correct implenmentation of counterMod5current");
    end 
endmodule

module memory_tb;
    reg D0, D1, D2, D3, RorW, C, reset; wire Q0, Q1, Q2, Q3;
    memory memory_test(.D0(D0), .D1(D1), .D2(D2), .D3(D3), .C(C), .reset(reset), .RorW(RorW), .Q0(Q0), .Q1(Q1), .Q2(Q2), .Q3(Q3));
    int errors = 0;

    initial begin
        //#150; $monitor("time %0d: D0=%b, D1=%b, D2=%b, D3=%b, RorW=%b, C=%b, reset=%b, Q0=%b, Q1=%b, Q2=%b, Q3=%b", $time, D0, D1, D2, D3, RorW, C, reset, Q0, Q1, Q2, Q3);
        reset = 1; #1; reset = 0;
        #1; if(Q0) errors++;
        if(Q1) errors++;
        if(Q2) errors++;
        if(Q3) errors++;
        RorW = 0; D0 = 1; D1 = 0; D2 = 1; D3 = 0; #1; C = 1;
        #1; if(Q0) errors++;
        if(Q1) errors++;
        if(Q2) errors++;
        if(Q3) errors++;
        C = 0; #1; RorW = 1; #1; C = 1;
        #1; if(!Q0) errors++;
        if(Q1) errors++;
        if(!Q2) errors++;
        if(Q3) errors++;
        C = 0;
        #1; if(!Q0) errors++;
        if(Q1) errors++;
        if(!Q2) errors++;
        if(Q3) errors++;
        D0 = 0; D1 = 1; D2 = 0; D3 = 1; #1; C = 1;
        #1; if(Q0) errors++;
        if(!Q1) errors++;
        if(Q2) errors++;
        if(!Q3) errors++;

        #1; if (errors) $display("Incorrect implenmentation of memory");
        else $display("Correct implenmentation of memory");

    end

endmodule

module mod5_tb;
    reg [2:0] INDEX; 
    wire Q0, Q1, Q2, Q3, Q4;
    mod5 mod5_test(.INDEX(INDEX), .Q0(Q0), .Q1(Q1), .Q2(Q2), .Q3(Q3), .Q4(Q4));
    int errors = 0;

    initial begin
        //#150; $monitor("time %0d: INDEX[0]=%b, INDEX[1]=%b, INDEX[2]=%b, Q0=%b, Q1=%b, Q2=%b, Q3=%b, Q4=%b", $time, INDEX[0], INDEX[1], INDEX[2], Q0, Q1, Q2, Q3, Q4);
        INDEX[0] = 0; INDEX[1] = 0; INDEX[2] = 0;
        #1; if(!Q0) errors++;
        if(Q1) errors++;
        if(Q2) errors++;
        if(Q3) errors++;
        if(Q4) errors++;
        INDEX[0] = 1; INDEX[1] = 0; INDEX[2] = 0;
        #1; if(Q0) errors++;
        if(!Q1) errors++;
        if(Q2) errors++;
        if(Q3) errors++;
        if(Q4) errors++;
        INDEX[0] = 0; INDEX[1] = 1; INDEX[2] = 0;
        #1; if(Q0) errors++;
        if(Q1) errors++;
        if(!Q2) errors++;
        if(Q3) errors++;
        if(Q4) errors++;
        INDEX[0] = 1; INDEX[1] = 1; INDEX[2] = 0;
        #1; if(Q0) errors++;
        if(Q1) errors++;
        if(Q2) errors++;
        if(!Q3) errors++;
        if(Q4) errors++;
        INDEX[0] = 0; INDEX[1] = 0; INDEX[2] = 1;
        #1; if(Q0) errors++;
        if(Q1) errors++;
        if(Q2) errors++;
        if(Q3) errors++;
        if(!Q4) errors++;
        INDEX[0] = 1; INDEX[1] = 0; INDEX[2] = 1;
        #1; if(!Q0) errors++;
        if(Q1) errors++;
        if(Q2) errors++;
        if(Q3) errors++;
        if(Q4) errors++;
        INDEX[0] = 0; INDEX[1] = 1; INDEX[2] = 1;
        #1; if(Q0) errors++;
        if(!Q1) errors++;
        if(Q2) errors++;
        if(Q3) errors++;
        if(Q4) errors++;
        INDEX[0] = 1; INDEX[1] = 1; INDEX[2] = 1;
        #1; if(Q0) errors++;
        if(Q1) errors++;
        if(!Q2) errors++;
        if(Q3) errors++;
        if(Q4) errors++;
        
        #1; if (errors) $display("Incorrect implenmentation of mod5");
        else $display("Correct implenmentation of mod5");
    end 
endmodule

module SubstractorMod5_tb;
    reg [2:0] INDEX;
    reg [4:0] counter; 
    wire [4:0] Q;
    SubstractorMod5 substractor_test(.INDEX(INDEX), .counter(counter), .Q(Q));
    int errors = 0;

    initial begin
        //#150; $monitor("time %0d:counter[0]=%b, counter[1]=%b, counter[2]=%b, counter[3]=%b, counter[4]=%b, INDEX[0]=%b, INDEX[1]=%b, INDEX[2]=%b, Q[0]=%b, Q[1]=%b, Q[2]=%b, Q[3]=%b, Q[4]=%b", $time, counter[0], counter[1], counter[2], counter[3], counter[4], INDEX[0], INDEX[1], INDEX[2], Q[0], Q[1], Q[2], Q[3], Q[4]);
        INDEX[0] = 0; INDEX[1] = 0; INDEX[2] = 0;
        counter[0] = 1; counter[1] = 0; counter[2] = 0; counter[3] = 0; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(!Q[4]) errors++;
        counter[0] = 0; counter[1] = 1; counter[2] = 0; counter[3] = 0; counter[4] = 0;
        #1; if(!Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 0; counter[2] = 1; counter[3] = 0; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(!Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 0; counter[2] = 0; counter[3] = 1; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(!Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 0; counter[2] = 0; counter[3] = 0; counter[4] = 1;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(!Q[3]) errors++;
        if(Q[4]) errors++;  
        INDEX[0] = 1; INDEX[1] = 0; INDEX[2] = 0;
        counter[0] = 1; counter[1] = 0; counter[2] = 0; counter[3] = 0; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(!Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 1; counter[2] = 0; counter[3] = 0; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(!Q[4]) errors++;
        counter[0] = 0; counter[1] = 0; counter[2] = 1; counter[3] = 0; counter[4] = 0;
        #1; if(!Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 0; counter[2] = 0; counter[3] = 1; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(!Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 0; counter[2] = 0; counter[3] = 0; counter[4] = 1;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(!Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;  
        INDEX[0] = 0; INDEX[1] = 1; INDEX[2] = 0;
        counter[0] = 1; counter[1] = 0; counter[2] = 0; counter[3] = 0; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(!Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 1; counter[2] = 0; counter[3] = 0; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(!Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 0; counter[2] = 1; counter[3] = 0; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(!Q[4]) errors++;
        counter[0] = 0; counter[1] = 0; counter[2] = 0; counter[3] = 1; counter[4] = 0;
        #1; if(!Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 0; counter[2] = 0; counter[3] = 0; counter[4] = 1;
        #1; if(Q[0]) errors++;
        if(!Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++; 
        INDEX[0] = 1; INDEX[1] = 1; INDEX[2] = 0;
        counter[0] = 1; counter[1] = 0; counter[2] = 0; counter[3] = 0; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(!Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 1; counter[2] = 0; counter[3] = 0; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(!Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 0; counter[2] = 1; counter[3] = 0; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(!Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 0; counter[2] = 0; counter[3] = 1; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(!Q[4]) errors++;
        counter[0] = 0; counter[1] = 0; counter[2] = 0; counter[3] = 0; counter[4] = 1;
        #1; if(!Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++; 
        INDEX[0] = 0; INDEX[1] = 0; INDEX[2] = 1;
        counter[0] = 1; counter[1] = 0; counter[2] = 0; counter[3] = 0; counter[4] = 0;
        #1; if(!Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 1; counter[2] = 0; counter[3] = 0; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(!Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 0; counter[2] = 1; counter[3] = 0; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(!Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 0; counter[2] = 0; counter[3] = 1; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(!Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 0; counter[2] = 0; counter[3] = 0; counter[4] = 1;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(!Q[4]) errors++; 
        INDEX[0] = 1; INDEX[1] = 0; INDEX[2] = 1;
        counter[0] = 1; counter[1] = 0; counter[2] = 0; counter[3] = 0; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(!Q[4]) errors++;
        counter[0] = 0; counter[1] = 1; counter[2] = 0; counter[3] = 0; counter[4] = 0;
        #1; if(!Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 0; counter[2] = 1; counter[3] = 0; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(!Q[1]) errors++;
        if(Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 0; counter[2] = 0; counter[3] = 1; counter[4] = 0;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(!Q[2]) errors++;
        if(Q[3]) errors++;
        if(Q[4]) errors++;
        counter[0] = 0; counter[1] = 0; counter[2] = 0; counter[3] = 0; counter[4] = 1;
        #1; if(Q[0]) errors++;
        if(Q[1]) errors++;
        if(Q[2]) errors++;
        if(!Q[3]) errors++;
        if(Q[4]) errors++; 
        #1; if (errors) $display("Incorrect implenmentation of SubstractorMod5");
        else $display("Correct implenmentation of SubstractorMod5");
    end
endmodule

module oneOfTwo_tb;
    reg [4:0] A, B;
    reg AorB; 
    wire [4:0] result;
    oneOfTwo oneOfTwo_test(.A(A), .B(B), .AorB(AorB), .result(result));
    int errors = 0;

    initial begin
        //#150; $monitor("time %0d:A[0]=%b, A[1]=%b, A[2]=%b, A[3]=%b, A[4]=%b, B[0]=%b, B[1]=%b, B[2]=%b, B[3]=%b, B[4]=%b, AorB=%b result[0]=%b, result[1]=%b, result[2]=%b, result[3]=%b, result[4]=%b", $time, A[0], A[1], A[2], A[3], A[4], B[0], B[1], B[2], B[3], B[4], AorB, result[0], result[1], result[2], result[3], result[4]);
        A[0] = 1; A[1] = 0; A[2] = 1; A[3] = 0; A[4] = 1;
        B[0] = 1; B[1] = 1; B[2] = 0; B[3] = 1; B[4] = 1;
        AorB = 0;
        #1; if(!result[0]) errors++;
        if(result[1]) errors++;
        if(!result[2]) errors++;
        if(result[3]) errors++;
        if(!result[4]) errors++;
        AorB = 1;
        #1; if(!result[0]) errors++;
        if(!result[1]) errors++;
        if(result[2]) errors++;
        if(!result[3]) errors++;
        if(!result[4]) errors++;

        A[0] = 0; A[1] = 0; A[2] = 1; A[3] = 1; A[4] = 0;
        B[0] = 1; B[1] = 0; B[2] = 1; B[3] = 0; B[4] = 0;
        AorB = 0;
        #1; if(result[0]) errors++;
        if(result[1]) errors++;
        if(!result[2]) errors++;
        if(!result[3]) errors++;
        if(result[4]) errors++;
        AorB = 1;
        #1; if(!result[0]) errors++;
        if(result[1]) errors++;
        if(!result[2]) errors++;
        if(result[3]) errors++;
        if(result[4]) errors++;
         
        #1; if (errors) $display("Incorrect implenmentation of OneOfTwo");
        else $display("Correct implenmentation of OneOfTwo");
    end
endmodule