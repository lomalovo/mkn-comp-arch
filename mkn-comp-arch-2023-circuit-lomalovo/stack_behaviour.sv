
module stack_behaviour_normal(
    inout wire[3:0] IO_DATA, 
    input wire RESET, 
    input wire CLK, 
    input wire[1:0] COMMAND,
    input wire[2:0] INDEX);

    reg [3:0] mem0, mem1, mem2, mem3, mem4;

    int topNumber = 0; //это номеер вершины стека
    int outNumber; //а это номер для вывода с учетом команды и индекса
    assign outNumber = (topNumber + 10 - INDEX) % 5;

    reg[3:0] DATA_OUT;
    reg enable;
    assign enable = !(((COMMAND == 2'b10) || (COMMAND == 2'b11)) && CLK);
    assign IO_DATA = enable ? 4'bZZZZ : DATA_OUT;

    always @ (posedge RESET) begin
        topNumber <= 0;
        mem0 <= 4'b0000;
        mem1 <= 4'b0000;
        mem2 <= 4'b0000;
        mem3 <= 4'b0000;
        mem4 <= 4'b0000;
    end

    always @ (posedge CLK) begin
        if (COMMAND == 2'b01) begin
            topNumber = (topNumber + 1) % 5;
            if (topNumber == 0) mem0 = IO_DATA;
            if (topNumber == 1) mem1 = IO_DATA;
            if (topNumber == 2) mem2 = IO_DATA;
            if (topNumber == 3) mem3 = IO_DATA;
            if (topNumber == 4) mem4 = IO_DATA;
        end
        if (COMMAND == 2'b10) begin
            if (topNumber == 0) DATA_OUT <= mem0;
            if (topNumber == 1) DATA_OUT <= mem1;
            if (topNumber == 2) DATA_OUT <= mem2;
            if (topNumber == 3) DATA_OUT <= mem3;
            if (topNumber == 4) DATA_OUT <= mem4;
            topNumber <= (topNumber + 4) % 5;
        end
        if (COMMAND == 2'b11) begin
            if (outNumber == 0) DATA_OUT <= mem0;
            if (outNumber == 1) DATA_OUT <= mem1;
            if (outNumber == 2) DATA_OUT <= mem2;
            if (outNumber == 3) DATA_OUT <= mem3;
            if (outNumber == 4) DATA_OUT <= mem4;
        end 
    end

endmodule