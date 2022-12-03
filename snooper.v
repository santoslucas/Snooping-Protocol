module snooper(clock, old_Status, message, writeBack, new_Status, mem_access);
    input clock;
    input [1:0] old_Status;
    input [1:0] message;
    output reg writeBack;
    output reg [1:0] new_Status;
    output reg mem_access;

    parameter I=2'b00, S=2'b01, M=2'b10;
    parameter bus_write_miss = 2'b00, bus_read_miss = 2'b01, bus_ivalidate = 2'b10, NA = 2'b11;

    always @(negedge clock) begin
        writeBack = 1'b0;
        mem_access = 1'b1;
        new_Status = old_Status;
        case (old_Status)
            M: begin
                if (message == bus_write_miss) begin
                    writeBack = 1'b1;
                    mem_access = 1'b0;
                    new_Status = I;
                end
                else if (message == bus_read_miss) begin
                    writeBack = 1'b1;
                    mem_access = 1'b0;
                    new_Status = S;
                end
            end

            S: begin
                if (message == bus_read_miss) begin
                    new_Status = S;
                end
                else if (message == bus_write_miss || message == bus_ivalidate) begin
                    new_Status = I;
                end
            end
        endcase
    end
endmodule
