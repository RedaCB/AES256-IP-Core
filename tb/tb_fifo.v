`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.05.2022 15:59:41
// Design Name: 
// Module Name: tb_fifo
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


module tb_fifo();
    // Local Parameters
    localparam period = 50;
    
    reg clk, resetn;
    reg [31 : 0] data_in;
    reg write_fifo, read_fifo;
    wire [31 : 0] data_out;
    
    fifo_data UUT(
        .clk(clk),
        .resetn(resetn),
        .write_fifo(write_fifo),
        .read_fifo(read_fifo),
        .data_in(data_in),
        .data_out(data_out)
    );
    
    // Clock
    always 
    begin
        clk = 1'b0; 
        #(period / 2); // high for period * timescale = 20 ns
    
        clk = 1'b1;
        #(period / 2); // low for period * timescale = 20 ns
    end
    
    always @(posedge clk)
    begin
        resetn <= 1'b0;
        write_fifo <= 1'b0;
        read_fifo <= 1'b0;
        
        #(period*2);
        write_fifo <= 1'b1;
        resetn <= 1'b1;
        data_in <= 32'haaaaaaaa;
        #period;
        
        write_fifo <= 1'b0;
        #period;
        
        data_in <= 32'hbbbbbbbb;
        write_fifo <= 1'b1;
        #period;
        
        data_in <= 32'hcccccccc;
        write_fifo <= 1'b1;
        #period;
        
        data_in <= 32'hdddddddd;
        write_fifo <= 1'b1;
        #period;
        
        data_in <= 32'heeeeeeee;
        write_fifo <= 1'b1;
        #period;
        
        write_fifo <= 1'b0;
        read_fifo <= 1'b1;
        #(period * 2);
        
        write_fifo <= 1'b1;
        read_fifo <= 1'b0;
        #(period);
        
        write_fifo <= 1'b0;
        read_fifo <= 1'b1;
        #(period * 2);
        
        write_fifo <= 1'b0;
        read_fifo <= 1'b0;
        #(period * 4);
        $stop;
        
        data_in <= 32'haaaaaaaa;
        #period;
        data_in <= 32'hcccccccc;
        #period;
        
    end

endmodule
