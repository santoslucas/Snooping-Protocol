module issuer(clock, old_Status, write_read, new_Status, message, writeBack);
    input clock;
    input [1:0] old_Status;
    input [1:0] write_read;
    output reg [1:0] message;
    output reg [1:0] new_Status;
    output reg writeBack;

    parameter I=2'b00, S=2'b01, M=2'b10;
    parameter write_hit = 2'b00, write_miss = 2'b01, read_hit = 2'b10, read_miss = 2'b11;
    parameter bus_write_miss = 2'b00, bus_read_miss = 2'b01, bus_ivalidate = 2'b10, NA = 2'b11;

    always @(posedge clock) begin
        writeBack = 1'b0;
        case (old_Status)
            I: begin  
                if (write_read == read_miss) begin
                    message = bus_read_miss;
                    new_Status = S;

                end
                else if (write_read ==write_miss) begin
                    message = bus_write_miss;
                    new_Status = M;
                end
            end

            M: begin
                if (write_read == read_miss) begin
                    writeBack = 1'b1;
                    message = bus_read_miss;
                    new_Status = S;
                end
                else if (write_read == write_miss) begin
                    writeBack = 1'b1;
                    message = bus_write_miss;
                    new_Status = M;
                end
                else if (write_read == write_hit || write_read == read_hit) begin
                    message = NA;
                    new_Status = M;
                end
            end

            S: begin
                if (write_read == read_hit) begin
                    message = NA;
                    new_Status = S;
                end
                else if (write_read == read_miss) begin
                    message = bus_read_miss;
                    new_Status = S;
                end
                else if (write_read == write_hit) begin
                    message = bus_ivalidate;
                    new_Status = M;
                end
                else if (write_read == write_miss) begin
                    message = bus_write_miss;
                    new_Status = M;
                end
            end
        endcase
    end
    
endmodule
