`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.05.2022 15:41:51
// Design Name: 
// Module Name: fifo_data
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define FIFO_SZ 64
`define FIFO_DATA_IN_WH 32
`define FIFO_DATA_OUT_WH 128

module fifo_data_in(
        clk, resetn,
        write_fifo, read_fifo,
        empty_fifo, full_fifo,
        counter_fifo,
        data_in,
        data_out
    );
    
input clk, resetn;
input write_fifo;
input read_fifo;
input [`FIFO_DATA_IN_WH - 1 : 0] data_in;
output reg [`FIFO_SZ : 0] counter_fifo;
output empty_fifo, full_fifo;
output reg [`FIFO_DATA_OUT_WH - 1 : 0] data_out;

reg [`FIFO_DATA_IN_WH - 1 : 0] memory_fifo[`FIFO_SZ-1 : 0];
reg [`FIFO_SZ : 0] write_ptr;
reg [`FIFO_SZ : 0] read_ptr;


assign empty_fifo = (write_ptr == read_ptr) ? 1'b1 : 1'b0;
assign full_fifo = (counter_fifo == `FIFO_SZ) ? 1'b1 : 1'b0;
//assign read_fifo = (full_fifo == 1'b1) ? 1'b1 : 1'b0;


// Write BLOCK
always @(posedge clk) begin: write
    if (write_fifo == 1'b1 && full_fifo == 1'b0) begin
        //memory_fifo[(write_ptr*`FIFO_DATA_IN_WH) +: `FIFO_DATA_IN_WH] <= data_in;
        memory_fifo[write_ptr] <= data_in;
    end
end

// Pointer Write BLOCK
always @(posedge clk) begin: pointer_w
    if (resetn == 1'b0) begin
        // Estado inicial
        write_ptr <= 0;
    end
    else begin
        // Estado de trabajo
        if (write_fifo == 1'b1 && full_fifo == 1'b0) begin 
            write_ptr <= (write_ptr == `FIFO_SZ - 1) ? 0 : write_ptr + 1;
        end
        //write_ptr <= (write_fifo == 1'b1 && full_fifo == 1'b0 && counter_fifo == `FIFO_SZ) ? 0 : write_ptr;
    end
end

// Read BLOCK
//assign data_out = (counter_fifo == `FIFO_SZ) ? memory_fifo : 128'h000000000000;
always @(posedge read_fifo) begin: read
    if (read_fifo == 1'b1 && empty_fifo == 1'b0) begin
        data_out[`FIFO_DATA_IN_WH-1 : 0] <= memory_fifo[read_ptr+3];
        data_out[(`FIFO_DATA_IN_WH*2)-1 : `FIFO_DATA_IN_WH] <= memory_fifo[read_ptr+2];
        data_out[(`FIFO_DATA_IN_WH*3)-1 : (`FIFO_DATA_IN_WH*2)] <= memory_fifo[read_ptr+1];
        data_out[(`FIFO_DATA_IN_WH*4)-1 : (`FIFO_DATA_IN_WH*3)] <= memory_fifo[read_ptr];
    end
end



// Pointer Read BLOCK
always @(posedge clk) begin: pointer_r
    if (resetn == 1'b0) begin
        // Estado inicial
       read_ptr <= 8'h0;
    end
    else begin
        // Estado de trabajo
        if (read_fifo == 1'b1 && empty_fifo == 1'b0) begin
            read_ptr <= (read_ptr == `FIFO_SZ - 1) ? 0 : read_ptr + 4;
        end
        //read_ptr <= (read_fifo == 1'b1 && empty_fifo == 1'b0) ? read_ptr + 1 : read_ptr;
        //read_ptr <= (read_fifo == 1'b1 && empty_fifo == 1'b0 && counter_fifo == `FIFO_SZ) ? 0 : read_ptr;
    end
end

/*
always @(posedge clk, posedge full_fifo) begin
    if (resetn == 1'b0) begin
        // Estado inicial
        read_fifo <= 1'b0;
    end else begin
        if (full_fifo == 1'b1 && ~read_fifo) begin
            read_fifo <= 1'b1;
        end else begin
            read_fifo <= 1'b0;
        end
    end
end
*/

// Counter BLOCK
always @(posedge clk) begin: counter
    if (resetn == 1'b0) begin
        // Estado inicial
        counter_fifo <= 0;
    end
    else begin
        // Estado de trabajo
        case ({write_fifo, read_fifo})
            2'b00 : counter_fifo <= counter_fifo;
            2'b01 : counter_fifo <= (counter_fifo == 0) ? 0 : counter_fifo - 4;
            2'b10 : counter_fifo <= (counter_fifo == `FIFO_SZ) ? `FIFO_SZ : counter_fifo + 1;
            2'b11 : counter_fifo <= counter_fifo;
            default : counter_fifo <= counter_fifo;
        endcase
    end
end

endmodule
