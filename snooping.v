//`include "memory.v"

module snooping (clock, proc_num, m_tag, tag_position, op, data);
    input clock;
    input [1:0] proc_num;
    input [2:0] m_tag;
    input [1:0] tag_position;
    input op;
    input [15:0] data;

    // Informacoes das caches dos processadores
    reg [2:0] proc_tags [2:0][3:0];
    reg [1:0] proc_status [2:0][3:0];
    reg [15:0] proc_datas[2:0][3:0];
    
    reg [1:0] message;
    reg [1:0] write_read;
    reg [2:0] Tstep_Q, Tstep_D;
    reg Done, Run, enable, w_enable;
    reg [15:0] data_in;
    wire [15:0] data_out;

    integer i, j, flag;

    memory mem (m_tag, enable, w_enable, data_in, data_out);

    parameter I=2'b00, S=2'b01, M=2'b10;
    parameter write = 1'b0, read = 1'b1;
    parameter write_hit = 2'b00, write_miss = 2'b01, read_hit = 2'b10, read_miss = 2'b11;
    parameter bus_write_miss = 2'b00, bus_read_miss = 2'b01, bus_ivalidate = 2'b10, NA = 2'b11;
    parameter T0 = 3'b000, T1 = 3'b001, T2 = 3'b010, T3 = 3'b011, T4 = 3'b100;

    initial begin
        Tstep_Q = T0;
        Tstep_D = T0;
        Done = 1'b0;
        Run = 1'b1;
        
        proc_tags[0][0] = 3'b000;
        proc_status[0][0] = S;
        proc_datas[0][0] = 8;
        proc_tags[0][1] = 3'b001;
        proc_status[0][1] = M;
        proc_datas[0][1] = 30;
        proc_tags[0][2] = 3'b010;
        proc_status[0][2] = I;
        proc_datas[0][2] = 0;
        proc_tags[0][3] = 3'b011;
        proc_status[0][3] = I;
        proc_datas[0][3] = 0;

        proc_tags[1][0] = 3'b000;
        proc_status[1][0] = I;
        proc_datas[1][0] = 0;
        proc_tags[1][1] = 3'b001;
        proc_status[1][1] = I;
        proc_datas[1][1] = 0;
        proc_tags[1][2] = 3'b010;
        proc_status[1][2] = I;
        proc_datas[1][2] = 0;
        proc_tags[1][3] = 3'b011;
        proc_status[1][3] = I;
        proc_datas[1][3] = 0;

        proc_tags[2][0] = 3'b000;
        proc_status[2][0] = S;
        proc_datas[2][0] = 8;
        proc_tags[2][1] = 3'b001; 
        proc_status[2][1] = I;
        proc_datas[2][1] = 0;
        proc_tags[2][2] = 3'b010;
        proc_status[2][2] = S;
        proc_datas[2][2] = 20;
        proc_tags[2][3] = 3'b011;
        proc_status[2][3] = I;
        proc_datas[2][3] = 0;
    end

    always @(Tstep_Q, Done, Run) begin
		case (Tstep_Q)
			T0:
				if (~Run) Tstep_D = T0;
				else Tstep_D = T1;
			T1: begin
				if (~Done) Tstep_D = T1;
				else Tstep_D =  T2;
			end
            T2: begin
				if (~Done) Tstep_D = T2;
				else Tstep_D = T3;
			end
            T3: begin
				if (~Done) Tstep_D = T3;
				else Tstep_D = T4;
			end
			T4: begin
				if (~Done) Tstep_D = T4;
				else Tstep_D = T0;
			end
	    endcase
    end

    always @(*) begin
        Done = 1'b0;
        enable = 1'b0;
        w_enable = 1'b0;

        case (Tstep_Q)
            T0: begin // Verifica operacao e Write-Back do emissor
                if ((proc_tags[proc_num][tag_position] == m_tag) && (proc_status[proc_num][tag_position] != I)) begin
                    if (op == write)
                        write_read =  write_hit;
                    else
                        write_read = read_hit;
                end
                else begin
                    if (op == write)
                        write_read =  write_miss;
                    else
                        write_read = read_miss;
                end
                
                if (write_read == read_miss || write_read == write_miss) begin
                    if (proc_status[proc_num][tag_position] == M) begin // habilita write-back
                        enable = 1;
                        w_enable = 1;
                        data_in = proc_datas[proc_num][tag_position];
                    end
                end
                Done = 1'b1;
            end   

            T1: begin // Verifica se precisa buscar dado na cache ou na memoria
                flag = 0;
                if (write_read == read_miss || write_read == write_miss) begin
                    for (i = 0; (i<3 && !flag); i=i+1) begin
                            if (i != proc_num) begin
                                if (proc_tags[i][tag_position] == m_tag && proc_status[i][tag_position] != I) begin // busca na cache
                                    proc_tags[proc_num][tag_position] = m_tag;
                                    proc_datas[proc_num][tag_position] = proc_datas[i][tag_position];
                                    flag = 1; // desabilita busca na memoria
                                end
                            end
                        end

                        if(!flag) begin //se nao achar o bloco nas caches, busca na memoria
                            proc_tags[proc_num][tag_position] = m_tag;
                            enable = 1; // habilita leitura
                        end
                end
                Done = 1'b1;
            end

            T2: begin // Busca dado Memoria
                if (!flag) begin
                   proc_datas[proc_num][tag_position] = data_out; // dado para a memoria
                end
                flag = 0;
                Done = 1'b1;
            end

            T3: begin // logica emissor - define novo estado
                case (proc_status[proc_num][tag_position])
                        I: begin  
                            if (write_read == read_miss) begin
                                message = bus_read_miss;
                                proc_status[proc_num][tag_position] = S;

                            end
                            else if (write_read == write_miss) begin
                                message = bus_write_miss;
                                proc_status[proc_num][tag_position] = M;
                                proc_datas[proc_num][tag_position] = data; // escreve novo dado
                            end 
                        end

                        M: begin
                            if (write_read == read_miss) begin
                                message = bus_read_miss;
                                proc_status[proc_num][tag_position] = S;
                            end
                            else if (write_read == write_miss) begin
                                message = bus_write_miss;
                                proc_status[proc_num][tag_position] = M;
                                proc_datas[proc_num][tag_position] = data; // escreve novo dado
                            end
                            else if (write_read == write_hit) begin
                                message = NA;
                                proc_status[proc_num][tag_position] = M;
                                proc_datas[proc_num][tag_position] = data; // escreve novo dado
                            end
                            else if (write_read == read_hit) begin
                                message = NA;
                                proc_status[proc_num][tag_position] = M;
                            end
                        end

                        S: begin
                            if (write_read == read_hit) begin
                                message = NA;
                                proc_status[proc_num][tag_position] = S;
                            end
                            else if (write_read == read_miss) begin
                                message = bus_read_miss;
                                proc_status[proc_num][tag_position] = S;
                            end
                            else if (write_read == write_hit) begin
                                message = bus_ivalidate;
                                proc_status[proc_num][tag_position] = M;
                                proc_datas[proc_num][tag_position] = data; // escreve novo dado
                            end
                            else if (write_read == write_miss) begin
                                message = bus_write_miss;
                                proc_status[proc_num][tag_position] = M;
                                proc_datas[proc_num][tag_position] = data; // escreve novo dado
                            end
                        end
                endcase
                Done = 1'b1;
            end

            T4: begin // Logica receptor - define novos status e faz write-back
                flag = 1; // ABORT MEMORY ACCESS (1 = NAO ABORTA, 0 = ABORTA)
                w_enable = 1'b0;
                enable = 1'b0;

                for (i = 0; i<3; i=i+1) begin // percorre todos os processadores
                    if (i != proc_num) begin
                        if (proc_tags[i][tag_position] == m_tag) begin //procura tags iguais
                            case (proc_status[i][tag_position]) // define novos estados
                                M: begin
                                    if (message == bus_write_miss) begin
                                        if (flag) begin
                                            w_enable = 1'b1;
                                            enable =  1'b1;
                                            data_in = proc_datas[i][tag_position];
                                            flag = 0;
                                        end
                                        proc_status[i][tag_position] = I;
                                    end
                                    else if (message == bus_read_miss) begin // faz write-back
                                        if (flag) begin
                                            w_enable = 1'b1; // habilita write-back
                                            enable =  1'b1; // habilita memoria
                                            data_in = proc_datas[i][tag_position]; // dado para a memoria
                                            flag = 0;
                                        end
                                        proc_status[i][tag_position] = S;
                                    end
                                end

                                S: begin
                                    if (message == bus_read_miss) begin
                                        proc_status[i][tag_position] = S;
                                    end
                                    else if (message == bus_write_miss || message == bus_ivalidate) begin
                                        proc_status[i][tag_position] = I;
                                    end
                                end
                            endcase
                        end
                    end
                end
                flag = 0;
                Done = 1'b1;
            end
        endcase
    end

	always @(posedge clock) begin
		Tstep_Q = Tstep_D;
    end
endmodule