module memory(m_tag, enable, w_enable, data_in, data_out);
    input [2:0] m_tag;
    input enable, w_enable;
    input [15:0] data_in;

    output reg [15:0] data_out;

    reg [15:0] datas [7:0];

    initial begin
        datas[0] = 8; datas[4] = 0; // B0
        datas[1] = 10; datas[5] = 0; // B1
        datas[2] = 20; datas[6] = 0; // B2
        datas[3] = 30; datas[7] = 7; // B3
    end

    always @(*) begin
        if (enable) begin
            if (w_enable) begin // Write-back
                datas[m_tag] = data_in;
            end

            else begin // Read
                data_out = datas[m_tag];
            end
        end
    end

endmodule