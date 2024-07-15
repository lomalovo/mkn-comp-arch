`include "stack_behaviour.sv"
//iverilog -g2012 -o out.txt stack_behaviour_tb.sv && vvp out.txt

module stack_behaviour_tb;
    reg RESET, CLK;
    reg [1:0] COMMAND;
    reg [2:0] INDEX;
    wire [3:0] IO_DATA;
    reg [3:0] DATA;
    assign IO_DATA = DATA;
    stack_behaviour_normal stack_test(.RESET(RESET), .CLK(CLK), .COMMAND(COMMAND), .INDEX(INDEX), .IO_DATA(IO_DATA));
    int errors = 0;
    initial begin
        #100; $monitor("time %0d: RESET=%b, CLK=%b, COMMAND=%b, INDEX=%b, IO_DATA=%b", $time, RESET, CLK, COMMAND, INDEX, IO_DATA);
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

