`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2022 14:10:28
// Design Name: 
// Module Name: fifo_seed
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


`define FIFO_SZ 8
`define FIFO_DATA_IN_WH 32
`define FIFO_DATA_OUT_WH 256

module fifo_seed(
        clk, resetn,
        write_fifo, read_fifo,
        empty_fifo, full_fifo,
        counter_fifo,
        data_in,
        data_out
    );
    
input clk, resetn;
input write_fifo;
input [`FIFO_DATA_IN_WH - 1 : 0] data_in;
output reg [`FIFO_SZ : 0] counter_fifo;
output reg read_fifo;
output empty_fifo, full_fifo;
output reg [`FIFO_DATA_OUT_WH - 1 : 0] data_out;

reg [`FIFO_DATA_OUT_WH - 1 : 0] memory_fifo;
reg [`FIFO_SZ : 0] write_ptr;


assign empty_fifo = (counter_fifo == 0) ? 1'b1 : 1'b0;
assign full_fifo = (counter_fifo == `FIFO_SZ) ? 1'b1 : 1'b0;


// Write BLOCK
always @(posedge clk) begin: write
    if (write_fifo == 1'b1 && full_fifo == 1'b0) begin
        memory_fifo[(write_ptr*`FIFO_DATA_IN_WH) +: `FIFO_DATA_IN_WH] <= data_in;
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
always @(posedge clk, posedge full_fifo) begin
    if (resetn == 1'b0) begin
        read_fifo <= 1'b0;
    end else begin
        if (full_fifo == 1'b1 && ~read_fifo) begin
            read_fifo <= 1'b1;
            data_out <= memory_fifo;
        end else begin
            read_fifo <= 1'b0;
        end
    end
end

// Counter BLOCK
always @(posedge clk) begin: counter
    if (resetn == 1'b0) begin
        counter_fifo <= 0;
    end
    else begin
        case ({write_fifo, read_fifo})
            2'b00 : counter_fifo <= counter_fifo;
            2'b01 : counter_fifo <= 0;
            2'b10 : counter_fifo <= (counter_fifo == `FIFO_SZ) ? 1 : counter_fifo + 1;
            2'b11 : counter_fifo <= counter_fifo;
            default : counter_fifo <= counter_fifo;
        endcase
    end
end

endmodule

