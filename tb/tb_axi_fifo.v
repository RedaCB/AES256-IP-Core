`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2022 15:43:47
// Design Name: 
// Module Name: tb_axi_fifo
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


module tb_axi_fifo();

// Local Parameters
localparam period = 50; // Duration for each bit = period * timescale = period * 1ns = 20ns
reg clk, resetn;


// WRITE CHANNELS
// Inputs of AXI4 - WRITE (reg)
reg [5 : 0] addrw_addr;
reg [7 : 0] addrw_numTranfers;
reg [2 : 0] addrw_size;
reg [1 : 0] addrw_burst;
reg [1 : 0] addrw_id;

reg [31 : 0] dataw_data;
reg dataw_last;
reg [3 : 0] dataw_flash;

reg addrw_valid, dataw_valid, respw_ready;

// Outputs of AXI4 - WRITE (wire)
wire addrw_ready, dataw_ready, respw_valid;

wire [1 : 0] respw_resp;
wire respw_id;


// READ CHANNELS
// Inputs of AXI4 - READ
reg [5 : 0] addrr_addr;
reg [2 : 0] addrr_size;
reg [7 : 0] addrr_len;
reg [1 : 0] addrr_burst;
reg addrr_valid;

reg datar_ready;

// Outputs of AXI4 - READ
wire addrr_ready;

wire datar_resp;
wire [31 : 0] datar_data;
wire datar_valid;
wire datar_last;


// Instance of module AXI4
myip_axi_fifo_v1 UUT(
    .s00_axi_aclk(clk),
    .s00_axi_aresetn(resetn),
    
    // SIGNALS of Write Address Channel
    .s00_axi_awaddr(addrw_addr),        // Input    - Write Address Channel
    .s00_axi_awsize(addrw_size),        // Input    - Write Address Channel
    .s00_axi_awlen(addrw_numTranfers),  // Input    - Write Address Channel
    .s00_axi_awburst(addrw_burst),      // Input    - Write Address Channel
    .s00_axi_awvalid(addrw_valid),      // Input    - Write Address Channel
    .s00_axi_awready(addrw_ready),      // Output   - Write Address Channel
    .s00_axi_awid(addrw_id),            // Input    - Write Address Channel
    
    // SIGNALS of Write Data Channel
    .s00_axi_wdata(dataw_data),         // Input    - Write Data Channel
    .s00_axi_wvalid(dataw_valid),       // Input    - Write Data Channel
    .s00_axi_wready(dataw_ready),       // Output   - Write Data Channel
    .s00_axi_wlast(dataw_last),         // Input    - Write Data Channel
    .s00_axi_wstrb(dataw_flash),
    
    // SIGNALS of Write Response Channel
    .s00_axi_bresp(respw_resp),         // Output   - Write Response Channel
    .s00_axi_bvalid(respw_valid),       // Output   - Write Response Channel
    .s00_axi_bready(respw_ready),       // Input    - Write Response Channel
    .s00_axi_bid(respw_id),             // Output   - Write Response Channel
    
    
    // SIGNALS of Read Address Channel
    .s00_axi_araddr(addrr_addr),        // Input    - Read Address Channel
    .s00_axi_arlen(addrr_len),          // Input    - Read Address Channel
    .s00_axi_arsize(addrr_size),        // Input    - Read Address Channel
    .s00_axi_arburst(addrr_burst),      // Input    - Read Address Channel
    .s00_axi_arvalid(addrr_valid),      // Input    - Read Address Channel
    .s00_axi_arready(addrr_ready),      // Output   - Read Address Channel
    
    // SIGNALS of Read Data Channel
    .s00_axi_rdata(datar_data),
    .s00_axi_rresp(datar_resp),
    .s00_axi_rlast(datar_last),
    .s00_axi_rvalid(datar_valid),
    .s00_axi_rready(datar_ready)

);

// Clock
always 
begin
    clk = 1'b1; 
    #period; // high for period * timescale = 20 ns

    clk = 1'b0;
    #period; // low for period * timescale = 20 ns
end

task initialState;
//always
begin 
    // Write Channels
    addrw_valid = 1'b0;
    addrw_numTranfers = 8'b00000000;
    addrw_size = 3'b000;
    addrw_burst = 2'b00;
    addrw_id = 1'b0;
    
    dataw_valid = 1'b0;
    dataw_last = 1'b0;
    
    respw_ready = 1'b0;
    
    // Read Channels
    addrr_addr = 'h00;
    addrr_len = 1'b0;
    addrr_size = 1'b0;
    addrr_burst = 1'b0;
    addrr_valid = 1'b0;
    
    datar_ready = 1'b0;
    
    
    #period;
end
endtask

task enableResetn;
begin
    #period;
    @(posedge clk)
    resetn = 1'b1;
    #period;
end
endtask

task axi_write(
    input [5:0] i_addr,
    input [31:0] i_data
);
fork : f
    begin
        // Configure Address of Write
        #period;
        addrw_id = 2'b11;
        addrw_valid = 1'b1;
        assign addrw_addr  = i_addr;
        addrw_numTranfers = 8'b00000001;
        addrw_size = 3'b010;
        addrw_burst = 2'b01;
        #period;
    end
    begin
        // Send Data of Write
        while (addrw_ready == 1'b0) begin 
            #period;
        end
        if (addrw_ready) begin
            addrw_valid = 1'b0;
            addrw_id = 1'b0;
            dataw_valid = 1'b1;
            assign dataw_data  = i_data;
            dataw_last = 1'b1;
            dataw_flash = 4'b0001;
            #period;
            // Check Response of Write
            while (dataw_ready == 1'b0) begin 
                #period;
            end
            if (dataw_ready) begin
                
                respw_ready = 1'b1;
                #period;
                while (respw_valid == 1'b0) begin 
                    #period;
                end
                if (respw_valid) begin
                    #period;
                    dataw_flash = 'h0;
                    dataw_valid = 1'b0;
                    respw_ready = 1'b0;
                    dataw_last = 1'b0;
                end
            end
        end    
    end
    join
endtask

task axi_multi_write(
    input [5:0] i_addr
);
fork : f
    begin
        // Configure Address of Write
        #period;
         addrw_id = 2'b11;
         addrw_valid = 1'b1;
         assign addrw_addr  = i_addr;
         addrw_numTranfers = 'h03;
         addrw_size = 3'b010;
         addrw_burst = 2'b01;
         #period;
    end
    begin
        // Send Data of Write
         @(posedge addrw_ready);
         #period;
             
            addrw_valid = 1'b0;
            addrw_id = 1'b0;
            dataw_valid = 1'b1;
            dataw_flash = 'h1;
            assign dataw_data  = 'hABABABAB;
            #period;
            #period;
            //#period;
            #period;
            assign dataw_data  = 'hCDCDCDCD;
            #period;
            //#period;
            #period;
            assign dataw_data  = 'hEFEFEFEF;
            //#period;
            #period;
            #period;
            dataw_last = 1'b1;
            
         
         #period;
         // Check Response of Write
         if(dataw_ready == 1'b1) begin
         
            #period;
            respw_ready = 1'b1;
            #period;
         end
         
         if(dataw_ready == 1'b1) begin
         
            #period;
            dataw_last = 1'b0;
            dataw_valid = 1'b0;
            respw_ready = 1'b0;
            dataw_flash = 'h0;
            #period;
         end
    end
    join
endtask

task axi_read(
    input [5:0] i_addr
);
    begin
        // Configure Address of Read
        #period;
        //addrw_id = 2'b11;
        addrr_valid = 1'b1;
        assign addrr_addr = i_addr;
        addrr_burst = 2'b00;
        #period;
        while (datar_valid == 1'b0) begin 
            #period;
        end
        if (datar_valid) begin
            addrr_valid = 1'b0;
            datar_ready = 1'b1;
            #(period*3);
            datar_ready = 1'b0;
        end
    end
endtask


always @(posedge clk)
begin
    resetn = 1'b0;
    initialState();
    #period;
    enableResetn();
    #period;
    axi_write('h04, 'hFFFFFFFF);
    #period;
    axi_write('h04, 'hAAAAAAAA);
    #period;
    axi_multi_write('h08);
    #period;
    axi_read('h04);
    #(period);
    axi_read('h04);
    #(period*5);
    $stop;
end
    
endmodule
