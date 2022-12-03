//`include "snooping.v"

module testbench (PX_tag, PX_status, PX_data,
                MEM_000, MEM_001, MEM_010, MEM_011,
                MEM_100, MEM_101, MEM_110, MEM_111);
    reg clock;
    reg [1:0] proc_num;
    reg [2:0] m_tag;
    reg [1:0] tag_position;
    reg op;
    reg [15:0] data;

    output wire [2:0] PX_tag;
    output wire [1:0] PX_status;  
    output wire [15:0] PX_data;
    output wire [15:0] MEM_000;
    output wire [15:0] MEM_001;
    output wire [15:0] MEM_010;
    output wire [15:0] MEM_011;
    output wire [15:0] MEM_100;
    output wire [15:0] MEM_101;
    output wire [15:0] MEM_110;
    output wire [15:0] MEM_111;

    assign PX_tag = procs.proc_tags[proc_num][tag_position];
    assign PX_status =  procs.proc_status[proc_num][tag_position];
    assign PX_data =  procs.proc_datas[proc_num][tag_position];

    assign MEM_000 = procs.mem.datas[0];
    assign MEM_001 = procs.mem.datas[1];
    assign MEM_010 = procs.mem.datas[2];
    assign MEM_011 = procs.mem.datas[3];
    assign MEM_100 = procs.mem.datas[4];
    assign MEM_101 = procs.mem.datas[5];
    assign MEM_110 = procs.mem.datas[6];
    assign MEM_111 = procs.mem.datas[7];

    parameter I=2'b00, S=2'b01, M=2'b10;
    parameter write = 1'b0, read = 1'b1;

    snooping procs(clock, proc_num, m_tag, tag_position, op, data);

    initial begin
        clock = 1'b0;
    end

    initial begin
        // P0: READ 010
        proc_num = 2'b0;
        m_tag = 3'b010;
        tag_position = 2'b10;
        op = read;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;

        // P0: WRITE 010 <- 80
        proc_num = 2'b0;
        m_tag = 3'b010;
        tag_position = 2'b10;
        op = write;
        data = 80;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;

        // P2: WRITE 010 <- 80
        proc_num = 2'b10;
        m_tag = 3'b010;
        tag_position = 2'b10;
        op = write;
        data = 80;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;

        // P2: READ 111 
        proc_num = 2'b10;
        m_tag = 3'b111;
        tag_position = 2'b01;
        op = read;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;

        // P2: WRITE 111 <- 71
        proc_num = 2'b10;
        m_tag = 3'b111;
        tag_position = 2'b01;
        op = write;
        data = 71;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;

        // P1: WRITE 111 <- 99
        proc_num = 2'b01;
        m_tag = 3'b111;
        tag_position = 2'b01;
        op = write;
        data = 99;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
        #1 clock = ~clock;
    end

    always @(negedge clock) begin
        if ( procs.Tstep_Q == 0) begin
           $display("--------------------------------------------------------------------------------------------------------------------"); 
        end
        $display("T_step: %d", procs.Tstep_Q);
        $display("Mensagem: %b", procs.message);
        $display("P0:\nstatus: %b, tag: %b, data: %d", procs.proc_status[0][0],  procs.proc_tags[0][0], procs.proc_datas[0][0]);
        $display("status: %b, tag: %b, data: %d", procs.proc_status[0][1],  procs.proc_tags[0][1], procs.proc_datas[0][1]);
        $display("status: %b, tag: %b, data: %d", procs.proc_status[0][2],  procs.proc_tags[0][2], procs.proc_datas[0][2]);
        $display("status: %b, tag: %b, data: %d", procs.proc_status[0][3],  procs.proc_tags[0][3], procs.proc_datas[0][3]);

        $display("\nP1:\nstatus: %b, tag: %b, data: %d", procs.proc_status[1][0],  procs.proc_tags[1][0], procs.proc_datas[1][0]);
        $display("status: %b, tag: %b, data: %d", procs.proc_status[1][1],  procs.proc_tags[1][1], procs.proc_datas[1][1]);
        $display("status: %b, tag: %b, data: %d", procs.proc_status[1][2],  procs.proc_tags[1][2], procs.proc_datas[1][2]);
        $display("status: %b, tag: %b, data: %d", procs.proc_status[1][3],  procs.proc_tags[1][3], procs.proc_datas[1][3]);
        
        $display("\nP2:\nstatus: %b, tag: %b, data: %d", procs.proc_status[2][0],  procs.proc_tags[2][0], procs.proc_datas[2][0]);
        $display("status: %b, tag: %b, data: %d", procs.proc_status[2][1],  procs.proc_tags[2][1], procs.proc_datas[2][1]);
        $display("status: %b, tag: %b, data: %d", procs.proc_status[2][2],  procs.proc_tags[2][2], procs.proc_datas[2][2]);
        $display("status: %b, tag: %b, data: %d", procs.proc_status[2][3],  procs.proc_tags[2][3], procs.proc_datas[2][3]);
        
        $display("\nMEMORY: m_tag: %b, enable: %b, w_enable: %b, data_in: %d, data_out: %d\n", procs.mem.m_tag, procs.mem.enable, procs.mem.w_enable, procs.mem.data_in, procs.mem.data_out);
        $display("data[0]: %d | data[1]: %d | data[2]: %d | data[3]: %d", procs.mem.datas[0], procs.mem.datas[1], procs.mem.datas[2], procs.mem.datas[3]);
        $display("data[4]: %d | data[5]: %d | data[6]: %d | data[7]: %d", procs.mem.datas[4], procs.mem.datas[5], procs.mem.datas[6], procs.mem.datas[7]);
    end

endmodule