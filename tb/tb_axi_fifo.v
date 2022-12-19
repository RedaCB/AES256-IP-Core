`timescale 1ns / 10ps
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
localparam period = 10; // Duration for each bit = period * timescale = period * 1ns = 20ns
reg clk, resetn;


// WRITE CHANNELS
// Inputs of AXI4 - WRITE (reg)
reg [5 : 0] addrw_addr;
reg [7 : 0] addrw_numTranfers;
reg [2 : 0] addrw_size;
reg [1 : 0] addrw_burst;
reg [0 : 0] addrw_id;

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

wire [1 : 0] datar_resp;
wire [31 : 0] datar_data;
wire datar_valid;
wire datar_last;
wire kg_fin;

// Registers
wire [31 : 0] reg_status;
wire [31 : 0] reg_control;


// Instance of module AXI4
myip_axififo_v1 UUT(
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
    .s00_axi_rready(datar_ready),
    
    .s01_reg_status(reg_status),
    .s02_reg_control(reg_control)

);

// Clock
always 
begin
    clk = 1'b1; 
    #(period/2); // high for period * timescale = 20 ns

    clk = 1'b0;
    #(period/2); // low for period * timescale = 20 ns
end

task initialState;
//always
begin 
    // Write Channels
    addrw_valid <= 1'b0;
    addrw_numTranfers = 8'b00000000;
    addrw_size <= 3'b000;
    addrw_burst <= 2'b00;
    addrw_id <= 1'b0;
    
    dataw_valid <= 1'b0;
    dataw_last <= 1'b0;
    
    respw_ready = 1'b0;
    
    // Read Channels
    addrr_addr <= 'h00;
    addrr_len <= 1'b0;
    addrr_size <= 1'b0;
    addrr_burst <= 1'b0;
    addrr_valid <= 1'b0;
    
    datar_ready <= 1'b1;
    
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
//fork : f
    begin
        // Configure Address of Write
        #period;
        addrw_id = 1'b1;
        addrw_valid <= 1'b1;
        assign addrw_addr  = i_addr;
        addrw_numTranfers = 8'b00000000;
        addrw_size = 3'b010;
        addrw_burst = 2'b01;
        respw_ready <= 1'b1;
        #period;
	#period;
        addrw_valid <= 1'b0;
        addrw_valid <= 1'b0;
        addrw_id <= 1'b0;
        #period;
        #period;
        #period;
        dataw_valid <= 1'b1;
        dataw_data  <= i_data;
        dataw_last <= 1'b1;
        dataw_flash <= 4'hf;
        #period;
	#period;

        dataw_valid <= 1'b0;
        while(dataw_ready == 1'b0) begin
            #period;
        end
        
        dataw_valid <= 1'b0;

    end
 /*   begin
        // Send Data of Write
        while (addrw_ready == 1'b0) begin 
            #period;
        end
        if (addrw_ready) begin
            addrw_valid <= 1'b0;
            addrw_id <= 1'b0;
            dataw_valid <= 1'b1;
            dataw_data  <= i_data;
            dataw_last <= 1'b1;
            dataw_flash <= 4'b0001;
            #period;
            dataw_flash <= 'h0;
            dataw_valid <= 1'b0;
            respw_ready <= 1'b0;
            dataw_last <= 1'b0;
            // Check Response of Write
            //while (dataw_ready == 1'b0) begin 
            #period;
            //end
            if (dataw_ready) begin
                
                respw_ready <= 1'b1;
                #period;
                while (respw_valid == 1'b0) begin 
                    #period;
                end
                if (respw_valid) begin
                    #period;

                end
            end
        end    
    end
    join */
endtask





task axi_multi_write(
    input [5:0] i_addr
);
fork : f
    begin
        // Configure Address of Write
        #period;
         addrw_id <= 1'b1;
         addrw_valid <= 1'b1;
         addrw_addr  <= i_addr;
         addrw_numTranfers <= 'h03;
         addrw_size <= 3'b010;
         addrw_burst <= 2'b01;
         #period;
    end
    begin
        // Send Data of Write
         @(posedge addrw_ready);
         #period;
             
            addrw_valid <= 1'b0;
            addrw_id <= 1'b0;
            dataw_valid <= 1'b1;
            dataw_flash <= 'h1;
            dataw_data  <= 'hABABABAB;
            #period;
            #period;
            //#period;
            #period;
            dataw_data  <= 'hCDCDCDCD;
            #period;
            //#period;
            #period;
            dataw_data  <= 'hEFEFEFEF;
            //#period;
            #period;
            #period;
            dataw_last <= 1'b1;
            
         
         #period;
	 #period;
         // Check Response of Write
         //if(dataw_ready == 1'b1) begin
         
         //   #period;
         //   respw_ready <= 1'b1;
         //   #period;
         //end
         
         if(dataw_ready == 1'b1) begin
         
            //#period;
            dataw_last <= 1'b0;
            dataw_valid <= 1'b0;
            respw_ready <= 1'b0;
            dataw_flash <= 'h0;
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
        addrr_valid <= 1'b1;
        addrr_addr <= i_addr;
        //addrr_burst <= 2'b00;
        #(period*2);
        //while (datar_valid == 1'b0) begin 
        //    #period;
        //end
 //       if (datar_valid) begin
        addrr_valid <= 1'b0;
        #period;
        datar_ready <= 1'b1;
        #period;
        datar_ready <= 1'b0;
        //end
    end
endtask


always @(posedge clk)
begin
    // ------------------------------------------
	// -- Phase 0: Active System
	// ------------------------------------------
    resetn = 1'b0;
    initialState();
    #period;
    enableResetn();
    #period;
    
    // ------------------------------------------
	// -- Phase 1: Generate Key
	// ------------------------------------------
    /* CARGAMOS FIFO_SEED */
    // SEED_1 (CT-O & Device):  aaaaaaaa bbbbbbbb cccccccc dddddddd aaaaaaaa bbbbbbbb cccccccc dddddddd
    // KEY_1 (Result CT-O):     87dad8e4 b53b8489 32a019e9 41425310
    // KEY_1 (Result Device):   10534241 e919a032 89843bb5 e4d8da87
    
    // SEED_2 (CT-O):           00010203 04050607 08090a0b 0c0d0e0f 00010203 04050607 08090a0b 0c0d0e0f
    // SEED_2 (Device):         03020100 07060504 0b0a0908 0f0e0d0c 03020100 07060504 0b0a0908 0f0e0d0c
    // SEED_2 (Result CT-O):    ...
    // SEED_2 (Result Device):  ...  
    axi_write('h08, 'hAAAAAAAA);
    //axi_write('h08, 'h03020100);
    #period;
    axi_write('h08, 'hBBBBBBBB);
    //axi_write('h08, 'h07060504);
    #period;
    axi_write('h08, 'hCCCCCCCC);
    //axi_write('h08, 'h0b0a0908);
    #period;
    axi_write('h08, 'hDDDDDDDD);
    //axi_write('h08, 'h0f0e0d0c);
    #period;
    axi_write('h08, 'hAAAAAAAA);
    //axi_write('h08, 'h03020100);
    #period;
    axi_write('h08, 'hBBBBBBBB);
    //axi_write('h08, 'h07060504);
    #period;
    axi_write('h08, 'hCCCCCCCC);
    //axi_write('h08, 'h0b0a0908);
    #period;
    axi_write('h08, 'hDDDDDDDD);
    //axi_write('h08, 'h0f0e0d0c);
    #period;

    // Wait KG_FIN
    while(reg_status[2] == 0) begin
       #period; 
    end
    #(period*10);
    
    // ------------------------------------------
	// -- Phase 2: Encryption Something
	// ------------------------------------------
	// ENCRYPTION WITH SEED_1
	/// TEST 1: Input Encryption (Device)  ->  00010203 04050607 08090A0B 0C0D0E0F
	/// TEST 1: Input Encryption (CT-O)    ->  0f0e0d0c 0b0a0908 07060504 03020100 
	/// TEST 1: Result Encryption (Device) ->  deae1a89 b07f6e26 246b3283 cef7b78c  
	/// TEST 1: Result Encryption (CT-O)   ->  8cb7f7ce 83326b24 266e7fb0 891aaede
    /* CARGAMOS FIFO_DATA_IN */
    axi_write('h04, 'h00010203);
    #period;
    axi_write('h04, 'h04050607);
    #period;
    axi_write('h04, 'h08090A0B);
    #period;
    axi_write('h04, 'h0C0D0E0F);
    #(period*10);
    /* ACTIVAMOS ENCRIPTACIÓN */
    axi_write('h0C, 'h00000001);
    #period;
    
    // Wait ENCRYPT_FIN
    while(reg_status[0] == 1) begin
       #period; 
    end
    #(period*10);
    
    // ENCRYPTION WITH SEED_1
	/// TEST 2: Input Encryption (Device)  ->  AAAAAAAA BBBBBBBB AAAAAAAA BBBBBBBB
	/// TEST 2: Input Encryption (CT-O)    ->  BBBBBBBB AAAAAAAA BBBBBBBB AAAAAAAA
	/// TEST 2: Result Encryption (Device) ->  ec37ecb9 92740bec 68a69ef7 e863935c
	/// TEST 2: Result Encryption (CT-O)   ->  5c9363e8 f79ea668 ec0b7492 b9ec37ec
    /* CARGAMOS FIFO_DATA_IN */
    axi_write('h04, 'hAAAAAAAA);
    #period;
    axi_write('h04, 'hBBBBBBBB);
    #period;
    axi_write('h04, 'hAAAAAAAA);
    #period;
    axi_write('h04, 'hBBBBBBBB);
    #(period*10);
    /* ACTIVAMOS ENCRIPTACIÓN */
    axi_write('h0C, 'h00000001);
    #period;
    
    // Wait ENCRYPT_FIN
    while(reg_status[0] == 1) begin
       #period; 
    end
    #(period*10);
    
    // ------------------------------------------
	// -- Phase 3: Decryption Something
	// ------------------------------------------
		// DESENCRYPTION WITH SEED_1
	/// TEST 3: Input Desencryption (Device)   ->  deae1a89 b07f6e26 246b3283 cef7b78c
	/// TEST 3: Input Desencryption (CT-O)     ->  8cb7f7ce 83326b24 266e7fb0 891aaede 
	/// TEST 3: Result Desencryption (Device)  ->  00010203 04050607 08090a0b 0c0d0e0f  
	/// TEST 3: Result Desencryption (CT-O)    ->  0f0e0d0c 0b0a0908 07060504 03020100
    /* CARGAMOS FIFO_DATA_IN */
    axi_write('h04, 'hdeae1a89);
    #period;
    axi_write('h04, 'hb07f6e26);
    #period;
    axi_write('h04, 'h246b3283);
    #period;
    axi_write('h04, 'hcef7b78c);
    #(period*10);
    /* ACTIVAMOS DESENCRIPTACIÓN */
    axi_write('h0C, 'h00000002);
    #period;
    
    // Wait ENCRYPT_FIN
    while(reg_status[1] == 1) begin
       #period; 
    end
    #(period*10);
	$stop;
	
	// ------------------------------------------
	// -- Phase 4: Read results from FIFO_OUT
	// ------------------------------------------
    axi_read('h04);
    #(period);
    #(period);
    #(period);
    axi_read('h04);
    #(period);
    #(period);
    #(period);
    axi_read('h04);
    #(period);
    #(period);
    #(period);
    axi_read('h04);
    #(period);
    #(period);
    #(period);
    axi_read('h04);
    #(period*5);
    #period;
    axi_write('h04, 'hEEEEEEEE);
    #period;
    axi_write('h04, 'hFFFFFFFF);
    #(period);
    #(period);
    #(period);
    axi_read('h04);
    #(period);
    #(period);
    #(period);
    axi_read('h04);
end
    
endmodule
