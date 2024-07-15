
module stack_structural_normal(
    inout wire[3:0] IO_DATA, 
    input wire RESET, 
    input wire CLK, 
    input wire[1:0] COMMAND,
    input wire[2:0] INDEX);

    wire command0, command1, command2, command3;
    twoToFour twoToFourForCommand(.A0(COMMAND[0]), .A1(COMMAND[1]), .Q0(command0), .Q1(command1), .Q2(command2), .Q3(command3));
    
    wire not_command0, not_command3;
    not notCommand1(not_command0, command0);
    not notCommand3(not_command3, command3);
    
    wire true_clk;
    and trueClk(true_clk, CLK, not_command0, not_command3);

    
    wire rw_0, rw_1, rw_2, rw_3, rw_4;
    and rw0(rw_0, command1, cntr_next[0]);
    and rw1(rw_1, command1, cntr_next[1]);
    and rw2(rw_2, command1, cntr_next[2]);
    and rw3(rw_3, command1, cntr_next[3]);
    and rw4(rw_4, command1, cntr_next[4]);

    wire mem_out0_0, mem_out0_1, mem_out0_2, mem_out0_3;
    wire mem_out1_0, mem_out1_1, mem_out1_2, mem_out1_3;
    wire mem_out2_0, mem_out2_1, mem_out2_2, mem_out2_3;
    wire mem_out3_0, mem_out3_1, mem_out3_2, mem_out3_3;
    wire mem_out4_0, mem_out4_1, mem_out4_2, mem_out4_3;

    memory mem0(.C(true_clk), .reset(RESET), .RorW(rw_0), .Q0(mem_out0_0), .Q1(mem_out0_1), .Q2(mem_out0_2), .Q3(mem_out0_3), .D0(IO_DATA[0]), .D1(IO_DATA[1]), .D2(IO_DATA[2]), .D3(IO_DATA[3]));
    memory mem1(.C(true_clk), .reset(RESET), .RorW(rw_1), .Q0(mem_out1_0), .Q1(mem_out1_1), .Q2(mem_out1_2), .Q3(mem_out1_3), .D0(IO_DATA[0]), .D1(IO_DATA[1]), .D2(IO_DATA[2]), .D3(IO_DATA[3]));
    memory mem2(.C(true_clk), .reset(RESET), .RorW(rw_2), .Q0(mem_out2_0), .Q1(mem_out2_1), .Q2(mem_out2_2), .Q3(mem_out2_3), .D0(IO_DATA[0]), .D1(IO_DATA[1]), .D2(IO_DATA[2]), .D3(IO_DATA[3]));
    memory mem3(.C(true_clk), .reset(RESET), .RorW(rw_3), .Q0(mem_out3_0), .Q1(mem_out3_1), .Q2(mem_out3_2), .Q3(mem_out3_3), .D0(IO_DATA[0]), .D1(IO_DATA[1]), .D2(IO_DATA[2]), .D3(IO_DATA[3]));
    memory mem4(.C(true_clk), .reset(RESET), .RorW(rw_4), .Q0(mem_out4_0), .Q1(mem_out4_1), .Q2(mem_out4_2), .Q3(mem_out4_3), .D0(IO_DATA[0]), .D1(IO_DATA[1]), .D2(IO_DATA[2]), .D3(IO_DATA[3]));
    
    wire[4:0] cntr_next, cntr_curr;
    counterMod5next cntrMod5next(.plusOrMinus(command2), .C(true_clk), .reset(RESET), .Q(cntr_next));
    counterMod5current cntrMod5curr(.plusOrMinus(command2), .C(true_clk), .reset(RESET), .Q(cntr_curr));
    
    wire [4:0] oneOfTwo_first;
    oneOfTwo oneOfTwoFirst(.A(cntr_next), .B(cntr_curr), .AorB(command2), .result(oneOfTwo_first));
    wire [4:0] substractor_wire;
    SubstractorMod5 sbstrctrMod5(.counter(cntr_next), .INDEX(INDEX), .Q(substractor_wire));
    wire [4:0] oneOfTwo_second;
    oneOfTwo oneOfTwoSecond(.A(oneOfTwo_first), .B(substractor_wire), .AorB(command3), .result(oneOfTwo_second));


    //вывод даннных
    wire out0_0, out0_1, out0_2, out0_3, out0_4;
    wire out1_0, out1_1, out1_2, out1_3, out1_4;
    wire out2_0, out2_1, out2_2, out2_3, out2_4;
    wire out3_0, out3_1, out3_2, out3_3, out3_4;
    and out00(out0_0, mem_out0_0, oneOfTwo_second[0]);
    and out01(out0_1, mem_out1_0, oneOfTwo_second[1]);
    and out02(out0_2, mem_out2_0, oneOfTwo_second[2]);
    and out03(out0_3, mem_out3_0, oneOfTwo_second[3]);
    and out04(out0_4, mem_out4_0, oneOfTwo_second[4]);

    and out10(out1_0, mem_out0_1, oneOfTwo_second[0]);
    and out11(out1_1, mem_out1_1, oneOfTwo_second[1]);
    and out12(out1_2, mem_out2_1, oneOfTwo_second[2]);
    and out13(out1_3, mem_out3_1, oneOfTwo_second[3]);
    and out14(out1_4, mem_out4_1, oneOfTwo_second[4]);

    and out20(out2_0, mem_out0_2, oneOfTwo_second[0]);
    and out21(out2_1, mem_out1_2, oneOfTwo_second[1]);
    and out22(out2_2, mem_out2_2, oneOfTwo_second[2]);
    and out23(out2_3, mem_out3_2, oneOfTwo_second[3]);
    and out24(out2_4, mem_out4_2, oneOfTwo_second[4]);

    and out30(out3_0, mem_out0_3, oneOfTwo_second[0]);
    and out31(out3_1, mem_out1_3, oneOfTwo_second[1]);
    and out32(out3_2, mem_out2_3, oneOfTwo_second[2]);
    and out33(out3_3, mem_out3_3, oneOfTwo_second[3]);
    and out34(out3_4, mem_out4_3, oneOfTwo_second[4]);

    wire[3:0] out;
    or out0(out[0], out0_0, out0_1, out0_2, out0_3, out0_4);
    or out1(out[1], out1_0, out1_1, out1_2, out1_3, out1_4);
    or out2(out[2], out2_0, out2_1, out2_2, out2_3, out2_4);
    or out3(out[3], out3_0, out3_1, out3_2, out3_3, out3_4);
    
    wire cmd2_or_cmd3, cmd2_or_cmd3_and_clk, not_cmd2_or_cmd3_and_clk;
    or cmd2orCmd2(cmd2_or_cmd3, command2, command3);
    and cmd2orCmd2andClk(cmd2_or_cmd3_and_clk, cmd2_or_cmd3, CLK);
    not notCmd2orCmd2andClk(not_cmd2_or_cmd3_and_clk, cmd2_or_cmd3_and_clk);

    nmos nmos0(IO_DATA[0], out[0], cmd2_or_cmd3_and_clk);
    nmos nmos1(IO_DATA[1], out[1], cmd2_or_cmd3_and_clk);
    nmos nmos2(IO_DATA[2], out[2], cmd2_or_cmd3_and_clk);
    nmos nmos3(IO_DATA[3], out[3], cmd2_or_cmd3_and_clk);

    pmos pmos0(IO_DATA[0], out[0], not_cmd2_or_cmd3_and_clk);
    pmos pmos1(IO_DATA[1], out[1], not_cmd2_or_cmd3_and_clk);
    pmos pmos2(IO_DATA[2], out[2], not_cmd2_or_cmd3_and_clk);
    pmos pmos3(IO_DATA[3], out[3], not_cmd2_or_cmd3_and_clk);

    

endmodule

module RStrigger(output wire Q, notQ, input wire R, C, S, reset);
    wire r_and_c, s_and_c, wire_reset;
    and and_r(r_and_c, R, C);
    and and_s(s_and_c, S, C);
	nor nor_r(Q, r_and_c, notQ);
    nor nor_s(wire_reset, s_and_c, Q);
	or or_reset(notQ, reset, wire_reset);
endmodule

module twoToFour(output wire Q0, Q1, Q2, Q3, input wire A0, A1);
    wire not_A0, not_A1;
    not notA0(not_A0, A0);
    not notA1(not_A1, A1);
    and andQ0(Q0, not_A0, not_A1);
    and andQ1(Q1, A0, not_A1);
    and andQ2(Q2, not_A0, A1);
    and andQ3(Q3, A0, A1);
endmodule

module Dtrigger(output wire Q, notQ, input wire D, C, reset);
    wire not_D;
    not notD(not_D, D);
    RStrigger rst(.Q(Q), .notQ(notQ), .R(not_D), .C(C), .S(D), .reset(reset));
endmodule

module DtriggerFront(output wire Q, notQ, input wire D, C, reset);
    wire dtrA_to_dtrB;
    wire not_C;
    not notC(not_C, C);
    Dtrigger dtfA(.Q(dtrA_to_dtrB), .D(D), .C(C), .reset(reset));
    Dtrigger dtfB(.Q(Q), .notQ(notQ), .D(dtrA_to_dtrB), .C(not_C), .reset(reset));
endmodule

module counterMod5next(output wire [4:0] Q, input wire plusOrMinus, C, reset);
    wire not_plusOrMinus, reset_or_C;
    not notPlusOrMinus(not_plusOrMinus, plusOrMinus);
    or resetOrC(reset_or_C, reset, C);
    DtriggerFront dtfQ0(.Q(Q[0]), .reset(reset), .C(reset_or_C), .D(reset_or_D_for_dtfQ0));
    DtriggerFront dtfQ1(.Q(Q[1]), .reset(reset), .C(C), .D(D_for_dtfQ1));
    DtriggerFront dtfQ2(.Q(Q[2]), .reset(reset), .C(C), .D(D_for_dtfQ2));
    DtriggerFront dtfQ3(.Q(Q[3]), .reset(reset), .C(C), .D(D_for_dtfQ3));
    DtriggerFront dtfQ4(.Q(Q[4]), .reset(reset), .C(C), .D(D_for_dtfQ4));
    wire D_for_dtfQ0, D_for_dtfQ1, D_for_dtfQ2, D_for_dtfQ3, D_for_dtfQ4;
    or or_for_dtfQ0(D_for_dtfQ0, first_for_or_for_dtfQ0, second_for_or_for_dtfQ0);
    or or_for_dtfQ1(D_for_dtfQ1, first_for_or_for_dtfQ1, second_for_or_for_dtfQ1);
    or or_for_dtfQ2(D_for_dtfQ2, first_for_or_for_dtfQ2, second_for_or_for_dtfQ2);
    or or_for_dtfQ3(D_for_dtfQ3, first_for_or_for_dtfQ3, second_for_or_for_dtfQ3);
    or or_for_dtfQ4(D_for_dtfQ4, first_for_or_for_dtfQ4, second_for_or_for_dtfQ4);
    wire reset_or_D_for_dtfQ0;
    or resetOrDforDtfQ0(reset_or_D_for_dtfQ0, reset, D_for_dtfQ0);
    wire first_for_or_for_dtfQ0, second_for_or_for_dtfQ0;
    and first_for_dtfQ0(first_for_or_for_dtfQ0, Q[4], not_plusOrMinus);
    and second_for_dtfQ0(second_for_or_for_dtfQ0, Q[1], plusOrMinus);
    wire first_for_or_for_dtfQ1, second_for_or_for_dtfQ1;
    and first_for_dtfQ1(first_for_or_for_dtfQ1, Q[0], not_plusOrMinus);
    and second_for_dtfQ1(second_for_or_for_dtfQ1, Q[2], plusOrMinus);
    wire first_for_or_for_dtfQ2, second_for_or_for_dtfQ2;
    and first_for_dtfQ2(first_for_or_for_dtfQ2, Q[1], not_plusOrMinus);
    and second_for_dtfQ2(second_for_or_for_dtfQ2, Q[3], plusOrMinus);
    wire first_for_or_for_dtfQ3, second_for_or_for_dtfQ3;
    and first_for_dtfQ3(first_for_or_for_dtfQ3, Q[2], not_plusOrMinus);
    and second_for_dtfQ3(second_for_or_for_dtfQ3, Q[4], plusOrMinus);
    wire first_for_or_for_dtfQ4, second_for_or_for_dtfQ4;
    and first_for_dtfQ4(first_for_or_for_dtfQ4, Q[3], not_plusOrMinus);
    and second_for_dtfQ4(second_for_or_for_dtfQ4, Q[0], plusOrMinus);
endmodule

module counterMod5current(output wire [4:0] Q, input wire plusOrMinus, C, reset);
    wire not_plusOrMinus, reset_or_C;
    not notPlusOrMinus(not_plusOrMinus, plusOrMinus);
    or resetOrC(reset_or_C, reset, C);
    DtriggerFront dtfQ0(.Q(Q[0]), .reset(reset), .C(C), .D(D_for_dtfQ0));
    DtriggerFront dtfQ1(.Q(Q[1]), .reset(reset), .C(C), .D(D_for_dtfQ1));
    DtriggerFront dtfQ2(.Q(Q[2]), .reset(reset), .C(C), .D(D_for_dtfQ2));
    DtriggerFront dtfQ3(.Q(Q[3]), .reset(reset), .C(C), .D(D_for_dtfQ3));
    DtriggerFront dtfQ4(.Q(Q[4]), .reset(reset), .C(reset_or_C), .D(reset_or_D_for_dtfQ4));
    wire D_for_dtfQ0, D_for_dtfQ1, D_for_dtfQ2, D_for_dtfQ3, D_for_dtfQ4;
    or or_for_dtfQ0(D_for_dtfQ0, first_for_or_for_dtfQ0, second_for_or_for_dtfQ0);
    or or_for_dtfQ1(D_for_dtfQ1, first_for_or_for_dtfQ1, second_for_or_for_dtfQ1);
    or or_for_dtfQ2(D_for_dtfQ2, first_for_or_for_dtfQ2, second_for_or_for_dtfQ2);
    or or_for_dtfQ3(D_for_dtfQ3, first_for_or_for_dtfQ3, second_for_or_for_dtfQ3);
    or or_for_dtfQ4(D_for_dtfQ4, first_for_or_for_dtfQ4, second_for_or_for_dtfQ4);
    wire reset_or_D_for_dtfQ4;
    or resetOrDforDtfQ0(reset_or_D_for_dtfQ4, reset, D_for_dtfQ4);
    wire first_for_or_for_dtfQ0, second_for_or_for_dtfQ0;
    and first_for_dtfQ0(first_for_or_for_dtfQ0, Q[4], not_plusOrMinus);
    and second_for_dtfQ0(second_for_or_for_dtfQ0, Q[1], plusOrMinus);
    wire first_for_or_for_dtfQ1, second_for_or_for_dtfQ1;
    and first_for_dtfQ1(first_for_or_for_dtfQ1, Q[0], not_plusOrMinus);
    and second_for_dtfQ1(second_for_or_for_dtfQ1, Q[2], plusOrMinus);
    wire first_for_or_for_dtfQ2, second_for_or_for_dtfQ2;
    and first_for_dtfQ2(first_for_or_for_dtfQ2, Q[1], not_plusOrMinus);
    and second_for_dtfQ2(second_for_or_for_dtfQ2, Q[3], plusOrMinus);
    wire first_for_or_for_dtfQ3, second_for_or_for_dtfQ3;
    and first_for_dtfQ3(first_for_or_for_dtfQ3, Q[2], not_plusOrMinus);
    and second_for_dtfQ3(second_for_or_for_dtfQ3, Q[4], plusOrMinus);
    wire first_for_or_for_dtfQ4, second_for_or_for_dtfQ4;
    and first_for_dtfQ4(first_for_or_for_dtfQ4, Q[3], not_plusOrMinus);
    and second_for_dtfQ4(second_for_or_for_dtfQ4, Q[0], plusOrMinus);
endmodule

module memory(output wire Q0, Q1, Q2, Q3, input wire D0, D1, D2, D3, RorW, C, reset);
    wire RorWandC;
    and RorW_and_C(RorWandC, RorW, C);
    Dtrigger dtr0(.Q(Q0), .D(D0), .reset(reset), .C(RorWandC));
    Dtrigger dtr1(.Q(Q1), .D(D1), .reset(reset), .C(RorWandC));
    Dtrigger dtr2(.Q(Q2), .D(D2), .reset(reset), .C(RorWandC));
    Dtrigger dtr3(.Q(Q3), .D(D3), .reset(reset), .C(RorWandC));
endmodule

module mod5(output wire Q0, Q1, Q2, Q3, Q4, input wire[2:0] INDEX);
    wire not_INDEX0, not_INDEX1;
    not notINDEX0(not_INDEX0, INDEX[0]);
    not notINDEX1(not_INDEX1, INDEX[1]);

    wire first_bit, second_bit, third_bit;

    wire OR_firstBit, AND_firstBit;
    or ORfirstBit(OR_firstBit, INDEX[0], INDEX[1]);
    and ANDfirstBit(AND_firstBit, INDEX[2], OR_firstBit);
    xor XORfirstBit(first_bit, INDEX[0], AND_firstBit);
    wire AND_secondBit, OR_secondBit;

    and ANDsecondBit(AND_secondBit, not_INDEX0, INDEX[2]);
    or ORsecondBit(OR_secondBit, not_INDEX1, AND_secondBit);
    not notSecondBit(second_bit, OR_secondBit);
    
    and ANDthirdBit(third_bit, not_INDEX0, not_INDEX1, INDEX[2]);

    wire not_first_bit, not_second_bit, not_third_bit;
    not NOTfirstBit(not_first_bit, first_bit);
    not NOTsecondBit(not_second_bit, second_bit);
    not NOTthirdBit(not_third_bit, third_bit);

    and ANDQ0(Q0, not_first_bit, not_second_bit, not_third_bit);
    and ANDQ1(Q1, first_bit, not_second_bit, not_third_bit);
    and ANDQ2(Q2, not_first_bit, second_bit, not_third_bit);
    and ANDQ3(Q3, first_bit, second_bit, not_third_bit);
    and ANDQ4(Q4, not_first_bit, not_second_bit, third_bit);

endmodule

module SubstractorMod5(output wire [4:0] Q, input wire [4:0] counter, input wire [2:0] INDEX);
    wire Q0, Q1, Q2, Q3, Q4;
    mod5 mod5(.INDEX(INDEX), .Q0(Q0), .Q1(Q1), .Q2(Q2), .Q3(Q3), .Q4(Q4));
    
    wire w0_0, w0_1, w0_2, w0_3, w0_4;
    wire w1_0, w1_1, w1_2, w1_3, w1_4;
    wire w2_0, w2_1, w2_2, w2_3, w2_4;
    wire w3_0, w3_1, w3_2, w3_3, w3_4;
    wire w4_0, w4_1, w4_2, w4_3, w4_4;

    and a00(w0_0, counter[1], Q0);
    and a01(w0_1, counter[2], Q0);
    and a02(w0_2, counter[3], Q0);
    and a03(w0_3, counter[4], Q0);
    and a04(w0_4, counter[0], Q0);

    and a10(w1_0, counter[2], Q1);
    and a11(w1_1, counter[3], Q1);
    and a12(w1_2, counter[4], Q1);
    and a13(w1_3, counter[0], Q1);
    and a14(w1_4, counter[1], Q1);

    and a20(w2_0, counter[3], Q2);
    and a21(w2_1, counter[4], Q2);
    and a22(w2_2, counter[0], Q2);
    and a23(w2_3, counter[1], Q2);
    and a24(w2_4, counter[2], Q2);

    and a30(w3_0, counter[4], Q3);
    and a31(w3_1, counter[0], Q3);
    and a32(w3_2, counter[1], Q3);
    and a33(w3_3, counter[2], Q3);
    and a34(w3_4, counter[3], Q3);

    and a40(w4_0, counter[0], Q4);
    and a41(w4_1, counter[1], Q4);
    and a42(w4_2, counter[2], Q4);
    and a43(w4_3, counter[3], Q4);
    and a44(w4_4, counter[4], Q4);

    or or0(Q[0], w0_0, w1_0, w2_0, w3_0, w4_0);
    or or1(Q[1], w0_1, w1_1, w2_1, w3_1, w4_1);
    or or2(Q[2], w0_2, w1_2, w2_2, w3_2, w4_2);
    or or3(Q[3], w0_3, w1_3, w2_3, w3_3, w4_3);
    or or4(Q[4], w0_4, w1_4, w2_4, w3_4, w4_4);
endmodule

module oneOfTwo(output wire [4:0] result, input wire [4:0] A, B, input wire AorB);
    wire not_AorB;
    not notAorB(not_AorB, AorB);

    wire first_for0, second_for0;
    and firstFor0(first_for0, A[0], not_AorB);
    and secondFor0(second_for0, B[0], AorB);
    wire first_for1, second_for1;
    and firstFor1(first_for1, A[1], not_AorB);
    and secondFor1(second_for1, B[1], AorB);
    wire first_for2, second_for2;
    and firstFor2(first_for2, A[2], not_AorB);
    and secondFor2(second_for2, B[2], AorB);
    wire first_for3, second_for3;
    and firstFor3(first_for3, A[3], not_AorB);
    and secondFor3(second_for3, B[3], AorB);
    wire first_for4, second_for4;
    and firstFor4(first_for4, A[4], not_AorB);
    and secondFor4(second_for4, B[4], AorB);

    or or0(result[0], first_for0, second_for0);
    or or1(result[1], first_for1, second_for1);
    or or2(result[2], first_for2, second_for2);
    or or3(result[3], first_for3, second_for3);
    or or4(result[4], first_for4, second_for4);
endmodule