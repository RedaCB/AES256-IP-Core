
`timescale 1 ns / 1 ps

	module myip_axififo_v1_S00_AXI #
	(
		// Users to add parameters here

        // AES256_FIFO START
		parameter integer C_S_FIFO_SEED_WIDTH     = 256,
		parameter integer C_S_FIFO_DATA_WIDTH     = 128,
		parameter integer C_S_FIFO_SIZE	          = 16,
		// AES256_FIFO ENDS
		
		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of ID for for write address, write data, read address and read data
		parameter integer C_S_AXI_ID_WIDTH		= 1,
		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 6,
		// Width of optional user defined signal in write address channel
		parameter integer C_S_AXI_AWUSER_WIDTH	= 0,
		// Width of optional user defined signal in read address channel
		parameter integer C_S_AXI_ARUSER_WIDTH	= 0,
		// Width of optional user defined signal in write data channel
		parameter integer C_S_AXI_WUSER_WIDTH	= 0,
		// Width of optional user defined signal in read data channel
		parameter integer C_S_AXI_RUSER_WIDTH	= 0,
		// Width of optional user defined signal in write response channel
		parameter integer C_S_AXI_BUSER_WIDTH	= 0
	)
	(
		// Users to add ports here
		
		// Registers START
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_REG_STATUS,
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_REG_CONTROL,
		// Registers ENDS

		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write Address ID
		input wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_AWID,
		// Write address
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Burst length. The burst length gives the exact number of transfers in a burst
		input wire [7 : 0] S_AXI_AWLEN,
		// Burst size. This signal indicates the size of each transfer in the burst
		input wire [2 : 0] S_AXI_AWSIZE,
		// Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
		input wire [1 : 0] S_AXI_AWBURST,
		// Lock type. Provides additional information about the
    // atomic characteristics of the transfer.
		input wire  S_AXI_AWLOCK,
		// Memory type. This signal indicates how transactions
    // are required to progress through a system.
		input wire [3 : 0] S_AXI_AWCACHE,
		// Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Quality of Service, QoS identifier sent for each
    // write transaction.
		input wire [3 : 0] S_AXI_AWQOS,
		// Region identifier. Permits a single physical interface
    // on a slave to be used for multiple logical interfaces.
		input wire [3 : 0] S_AXI_AWREGION,
		// Optional User-defined signal in the write address channel.
		input wire [C_S_AXI_AWUSER_WIDTH-1 : 0] S_AXI_AWUSER,
		// Write address valid. This signal indicates that
    // the channel is signaling valid write address and
    // control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that
    // the slave is ready to accept an address and associated
    // control signals.
		output wire  S_AXI_AWREADY,
		// Write Data
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte
    // lanes hold valid data. There is one write strobe
    // bit for each eight bits of the write data bus.
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write last. This signal indicates the last transfer
    // in a write burst.
		input wire  S_AXI_WLAST,
		// Optional User-defined signal in the write data channel.
		input wire [C_S_AXI_WUSER_WIDTH-1 : 0] S_AXI_WUSER,
		// Write valid. This signal indicates that valid write
    // data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    // can accept the write data.
		output wire  S_AXI_WREADY,
		// Response ID tag. This signal is the ID tag of the
    // write response.
		output wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_BID,
		// Write response. This signal indicates the status
    // of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Optional User-defined signal in the write response channel.
		output wire [C_S_AXI_BUSER_WIDTH-1 : 0] S_AXI_BUSER,
		// Write response valid. This signal indicates that the
    // channel is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    // can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address ID. This signal is the identification
    // tag for the read address group of signals.
		input wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_ARID,
		// Read address. This signal indicates the initial
    // address of a read burst transaction.
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Burst length. The burst length gives the exact number of transfers in a burst
		input wire [7 : 0] S_AXI_ARLEN,
		// Burst size. This signal indicates the size of each transfer in the burst
		input wire [2 : 0] S_AXI_ARSIZE,
		// Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
		input wire [1 : 0] S_AXI_ARBURST,
		// Lock type. Provides additional information about the
    // atomic characteristics of the transfer.
		input wire  S_AXI_ARLOCK,
		// Memory type. This signal indicates how transactions
    // are required to progress through a system.
		input wire [3 : 0] S_AXI_ARCACHE,
		// Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Quality of Service, QoS identifier sent for each
    // read transaction.
		input wire [3 : 0] S_AXI_ARQOS,
		// Region identifier. Permits a single physical interface
    // on a slave to be used for multiple logical interfaces.
		input wire [3 : 0] S_AXI_ARREGION,
		// Optional User-defined signal in the read address channel.
		input wire [C_S_AXI_ARUSER_WIDTH-1 : 0] S_AXI_ARUSER,
		// Write address valid. This signal indicates that
    // the channel is signaling valid read address and
    // control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that
    // the slave is ready to accept an address and associated
    // control signals.
		output wire  S_AXI_ARREADY,
		// Read ID tag. This signal is the identification tag
    // for the read data group of signals generated by the slave.
		output wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_RID,
		// Read Data
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of
    // the read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read last. This signal indicates the last transfer
    // in a read burst.
		output wire  S_AXI_RLAST,
		// Optional User-defined signal in the read address channel.
		output wire [C_S_AXI_RUSER_WIDTH-1 : 0] S_AXI_RUSER,
		// Read valid. This signal indicates that the channel
    // is signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    // accept the read data and response information.
		input wire  S_AXI_RREADY
	);

	// AXI4FULL signals
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg [C_S_AXI_BUSER_WIDTH-1 : 0] 	axi_buser;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arready;
	reg [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rlast;
	reg [C_S_AXI_RUSER_WIDTH-1 : 0] 	axi_ruser;
	reg  	axi_rvalid;
	// aw_wrap_en determines wrap boundary and enables wrapping
	wire aw_wrap_en;
	// ar_wrap_en determines wrap boundary and enables wrapping
	wire ar_wrap_en;
	// aw_wrap_size is the size of the write transfer, the
	// write address wraps to a lower address if upper address
	// limit is reached
	wire [31:0]  aw_wrap_size ; 
	// ar_wrap_size is the size of the read transfer, the
	// read address wraps to a lower address if upper address
	// limit is reached
	wire [31:0]  ar_wrap_size ; 
	// The axi_awv_awr_flag flag marks the presence of write address valid
	reg axi_awv_awr_flag;
	//The axi_arv_arr_flag flag marks the presence of read address valid
	reg axi_arv_arr_flag; 
	// The axi_awlen_cntr internal write address counter to keep track of beats in a burst transaction
	reg [7:0] axi_awlen_cntr;
	//The axi_arlen_cntr internal read address counter to keep track of beats in a burst transaction
	reg [7:0] axi_arlen_cntr;
	reg [1:0] axi_arburst;
	reg [1:0] axi_awburst;
	reg [7:0] axi_arlen;
	reg [7:0] axi_awlen;
	//local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	//ADDR_LSB is used for addressing 32/64 bit registers/memories
	//ADDR_LSB = 2 for 32 bits (n downto 2) 
	//ADDR_LSB = 3 for 42 bits (n downto 3)

	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32)+ 1;
	localparam integer OPT_MEM_ADDR_BITS = 3;
	localparam integer USER_NUM_MEM = 1;
	//------------------------------------------------
	//-- Signals for user logic STARTS
	//------------------------------------------------
    // AES256 START
    /// REGISTERS START
    reg [C_S_FIFO_DATA_WIDTH-1 : 0] register_status;
    reg [C_S_FIFO_DATA_WIDTH-1 : 0] register_control;
    wire regControl_wren;      // Señal para escribir en el REGISTRO CONTROL wr: write y en: enable
    /// REGISTERS ENDS
    
    /// FIFO_SEED START
    wire fifoSeed_wren;     // Señal para escribir en la memoria de FIFO SEED wr: write y en: enable
    wire fifoSeed_empty;
    wire fifoSeed_full;
    wire [C_S_FIFO_SEED_WIDTH-1 : 0] fifoSeed_outData;
    /// FIFO_SEED ENDS
    
    /// FIFO_IN START
    wire fifoIn_wren;      // Señal para escribir en memoria de FIFO IN wr: write y en: enable
    wire fifoIn_empty;
    wire fifoIn_full;
    wire [C_S_FIFO_DATA_WIDTH-1 : 0] fifoIn_outData;
    /// FIFO_IN ENDS
    
    /// FIFO_OUT START
    wire fifoOut_empty;     // Señal para escribir en la memoria de FIFO SEED wr: write y en: enable
    wire fifoOut_full;
    wire [C_S_AXI_DATA_WIDTH-1 : 0] fifoOut_outData;
    /// FIFO_OUT ENDS
    
    /// DEVICE START
    wire device_encFin;
    wire device_decFin; 
    wire device_kgFin;
    wire [C_S_FIFO_DATA_WIDTH-1 : 0] device_outData;
    /// DEVICE ENDS
	// AES256 ENDS
	
	//------------------------------------------------
	//-- Signals for user logic ENDS
	//------------------------------------------------

	// I/O Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BUSER	= axi_buser;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RLAST	= axi_rlast;
	assign S_AXI_RUSER	= axi_ruser;
	assign S_AXI_RVALID	= axi_rvalid;
	assign S_AXI_BID = S_AXI_AWID;
	assign S_AXI_RID = S_AXI_ARID;
	assign  aw_wrap_size = (C_S_AXI_DATA_WIDTH/8 * (axi_awlen)); 
	assign  ar_wrap_size = (C_S_AXI_DATA_WIDTH/8 * (axi_arlen)); 
	assign  aw_wrap_en = ((axi_awaddr & aw_wrap_size) == aw_wrap_size)? 1'b1: 1'b0;
	assign  ar_wrap_en = ((axi_araddr & ar_wrap_size) == ar_wrap_size)? 1'b1: 1'b0;

	// Implement axi_awready generation

	// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	// de-asserted when reset is low.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awready <= 1'b0;
	      axi_awv_awr_flag <= 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && ~axi_awv_awr_flag && ~axi_arv_arr_flag)
	        begin
	          // slave is ready to accept an address and
	          // associated control signals
	          axi_awready <= 1'b1;
	          axi_awv_awr_flag  <= 1'b1; 
	          // used for generation of bresp() and bvalid
	        end
	      else if (S_AXI_WLAST && axi_wready)          
	      // preparing to accept next address after current write burst tx completion
	        begin
	          axi_awv_awr_flag  <= 1'b0;
	        end
	      else        
	        begin
	          axi_awready <= 1'b0;
	        end
	    end 
	end       
	// Implement axi_awaddr latching

	// This process is used to latch the address when both 
	// S_AXI_AWVALID and S_AXI_WVALID are valid. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awaddr <= 0;
	      axi_awlen_cntr <= 0;
	      axi_awburst <= 0;
	      axi_awlen <= 0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && ~axi_awv_awr_flag)
	        begin
	          // address latching 
	          axi_awaddr <= S_AXI_AWADDR[C_S_AXI_ADDR_WIDTH - 1:0];  
	           axi_awburst <= S_AXI_AWBURST; 
	           axi_awlen <= S_AXI_AWLEN;     
	          // start address of transfer
	          axi_awlen_cntr <= 0;
	        end   
	      else if((axi_awlen_cntr <= axi_awlen) && axi_wready && S_AXI_WVALID)        
	        begin

	          axi_awlen_cntr <= axi_awlen_cntr + 1;

	          case (axi_awburst)
	            2'b00: // fixed burst
	            // The write address for all the beats in the transaction are fixed
	              begin
	                axi_awaddr <= axi_awaddr;          
	                //for awsize = 4 bytes (010)
	              end   
	            2'b01: //incremental burst
	            // The write address for all the beats in the transaction are increments by awsize
	              begin
	                axi_awaddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB] <= axi_awaddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1;
	                //awaddr aligned to 4 byte boundary
	                axi_awaddr[ADDR_LSB-1:0]  <= {ADDR_LSB{1'b0}};   
	                //for awsize = 4 bytes (010)
	              end   
	            2'b10: //Wrapping burst
	            // The write address wraps when the address reaches wrap boundary 
	              if (aw_wrap_en)
	                begin
	                  axi_awaddr <= (axi_awaddr - aw_wrap_size); 
	                end
	              else 
	                begin
	                  axi_awaddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB] <= axi_awaddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1;
	                  axi_awaddr[ADDR_LSB-1:0]  <= {ADDR_LSB{1'b0}}; 
	                end                      
	            default: //reserved (incremental burst for example)
	              begin
	                axi_awaddr <= axi_awaddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1;
	                //for awsize = 4 bytes (010)
	              end
	          endcase              
	        end
	    end 
	end       
	// Implement axi_wready generation

	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	// de-asserted when reset is low. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_wready <= 1'b0;
	    end 
	  else
	    begin    
	      if ( ~axi_wready && S_AXI_WVALID && axi_awv_awr_flag)
	        begin
	          // slave can accept the write data
	          axi_wready <= 1'b1;
	        end
	      //else if (~axi_awv_awr_flag)
	      else if (S_AXI_WLAST && axi_wready)
	        begin
	          axi_wready <= 1'b0;
	        end
	    end 
	end       
	// Implement write response logic generation

	// The write response and response valid signals are asserted by the slave 
	// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	// This marks the acceptance of address and indicates the status of 
	// write transaction.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_bvalid <= 0;
	      axi_bresp <= 2'b0;
	      axi_buser <= 0;
	    end 
	  else
	    begin    
	      if (axi_awv_awr_flag && axi_wready && S_AXI_WVALID && ~axi_bvalid && S_AXI_WLAST )
	        begin
	          axi_bvalid <= 1'b1;
	          axi_bresp  <= 2'b0; 
	          // 'OKAY' response 
	        end                   
	      else
	        begin
	          if (S_AXI_BREADY && axi_bvalid) 
	          //check if bready is asserted while bvalid is high) 
	          //(there is a possibility that bready is always asserted high)   
	            begin
	              axi_bvalid <= 1'b0; 
	            end  
	        end
	    end
	 end   
	// Implement axi_arready generation

	// axi_arready is asserted for one S_AXI_ACLK clock cycle when
	// S_AXI_ARVALID is asserted. axi_awready is 
	// de-asserted when reset (active low) is asserted. 
	// The read address is also latched when S_AXI_ARVALID is 
	// asserted. axi_araddr is reset to zero on reset assertion.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_arready <= 1'b0;
	      axi_arv_arr_flag <= 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_arready && S_AXI_ARVALID && ~axi_awv_awr_flag && ~axi_arv_arr_flag)
	        begin
	          axi_arready <= 1'b1;
	          axi_arv_arr_flag <= 1'b1;
	        end
	      else if (axi_rvalid && S_AXI_RREADY && axi_arlen_cntr == axi_arlen)
	      // preparing to accept next address after current read completion
	        begin
	          axi_arv_arr_flag  <= 1'b0;
	        end
	      else        
	        begin
	          axi_arready <= 1'b0;
	        end
	    end 
	end       
	// Implement axi_araddr latching

	//This process is used to latch the address when both 
	//S_AXI_ARVALID and S_AXI_RVALID are valid. 
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_araddr <= 0;
	      axi_arlen_cntr <= 0;
	      axi_arburst <= 0;
	      axi_arlen <= 0;
	      axi_rlast <= 1'b0;
	      axi_ruser <= 0;
	    end 
	  else
	    begin    
	      if (~axi_arready && S_AXI_ARVALID && ~axi_arv_arr_flag)
	        begin
	          // address latching 
	          axi_araddr <= S_AXI_ARADDR[C_S_AXI_ADDR_WIDTH - 1:0]; 
	          axi_arburst <= S_AXI_ARBURST; 
	          axi_arlen <= S_AXI_ARLEN;     
	          // start address of transfer
	          axi_arlen_cntr <= 0;
	          axi_rlast <= 1'b0;
	        end   
	      else if((axi_arlen_cntr <= axi_arlen) && axi_rvalid && S_AXI_RREADY)        
	        begin
	         
	          axi_arlen_cntr <= axi_arlen_cntr + 1;
	          axi_rlast <= 1'b0;
	        
	          case (axi_arburst)
	            2'b00: // fixed burst
	             // The read address for all the beats in the transaction are fixed
	              begin
	                axi_araddr       <= axi_araddr;        
	                //for arsize = 4 bytes (010)
	              end   
	            2'b01: //incremental burst
	            // The read address for all the beats in the transaction are increments by awsize
	              begin
	                axi_araddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB] <= axi_araddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1; 
	                //araddr aligned to 4 byte boundary
	                axi_araddr[ADDR_LSB-1:0]  <= {ADDR_LSB{1'b0}};   
	                //for awsize = 4 bytes (010)
	              end   
	            2'b10: //Wrapping burst
	            // The read address wraps when the address reaches wrap boundary 
	              if (ar_wrap_en) 
	                begin
	                  axi_araddr <= (axi_araddr - ar_wrap_size); 
	                end
	              else 
	                begin
	                axi_araddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB] <= axi_araddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1; 
	                //araddr aligned to 4 byte boundary
	                axi_araddr[ADDR_LSB-1:0]  <= {ADDR_LSB{1'b0}};   
	                end                      
	            default: //reserved (incremental burst for example)
	              begin
	                axi_araddr <= axi_araddr[C_S_AXI_ADDR_WIDTH - 1:ADDR_LSB]+1;
	                //for arsize = 4 bytes (010)
	              end
	          endcase              
	        end
	      else if((axi_arlen_cntr == axi_arlen) && ~axi_rlast && axi_arv_arr_flag )   
	        begin
	          axi_rlast <= 1'b1;
	        end          
	      else if (S_AXI_RREADY)   
	        begin
	          axi_rlast <= 1'b0;
	        end          
	    end 
	end       
	// Implement axi_arvalid generation

	// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	// S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	// data are available on the axi_rdata bus at this instance. The 
	// assertion of axi_rvalid marks the validity of read data on the 
	// bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	// is deasserted on reset (active low). axi_rresp and axi_rdata are 
	// cleared to zero on reset (active low).  

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rvalid <= 0;
	      axi_rresp  <= 0;
	    end 
	  else
	    begin    
	      if (axi_arv_arr_flag && ~axi_rvalid)
	        begin
	          axi_rvalid <= 1'b1;
	          axi_rresp  <= 2'b0; 
	          // 'OKAY' response
	        end   
	      else if (axi_rvalid && S_AXI_RREADY)
	        begin
	          axi_rvalid <= 1'b0;
	        end            
	    end
	end
    
	// Add user logic here
	
	// ------------------------------------------
	// -- Memory Addressing Start
	// ------------------------------------------
	reg fifo_seed_addr_active, fifo_data_addr_active, reg_control_addr_active;

	// BLOQUE PARA ACTIVAR ESCRITURA AXI4 -> FIFO_SEED
	always @(S_AXI_AWADDR) begin
	   if (S_AXI_AWADDR == 6'h08) begin
	       fifo_seed_addr_active = 1'b1;
	   end else begin
	       fifo_seed_addr_active = 1'b0;
	   end
	end
	
	//Posible fusion del Mapping Address para las FIFOS_DATA
	// BLOQUE PARA ACTIVAR ESCRITURA AXI4 -> FIFO_DATA_IN
	always @(S_AXI_AWADDR) begin
	   if (S_AXI_AWADDR == 6'h04) begin
	       fifo_data_addr_active = 1'b1;
	   end else begin
	       fifo_data_addr_active = 1'b0;
	   end
	end
	// BLOQUE PARA ACTIVAR LECTUR Y ESCRITURA FIFO_DATA_OUT -> AXI4 
	always @(S_AXI_ARADDR) begin
	   if (S_AXI_ARADDR == 6'h04) begin
	       reg_control_addr_active = 1'b1;
	   end else begin
	       reg_control_addr_active = 1'b0;
	   end
	end 

	// BLOQUE PARA ACTIVAR REG_CONTROL -> DEVICE
	always @(S_AXI_AWADDR) begin
	   if (S_AXI_AWADDR == 6'h0C) begin
	       reg_control_addr_active = 1'b1;
	   end else begin
	       reg_control_addr_active = 1'b0;
	   end
	end 
	
	// ------------------------------------------
	// -- Memory Addressing Ends
	// ------------------------------------------
	

    // ------------------------------------------
	// -- REG_STATUS Start
	/* --------- CONTROL REGISTER STRC ----------
    *
    *  0 - Encrypte_State
    *  1 - Decrypte_State
    *  2 - KG_State -> Cambiarlo, 1 indica que la llave esta generada, 0 indica que la llave no existe
    *  3 - FIFO_IN_Full
    *  4 - FIFO_OUT_Full
    *  5 - FIFO_SEED_Full
    *  6 - FIFO_IN_Empty
    *  7 - FIFO_OUT_Empty
    *  8 - FIFO_SEED_Empty
    *  9
    *  ...
    *  31
    *
    *  ------------------------------------------*/
	// ------------------------------------------
    always @( posedge S_AXI_ACLK )
	begin
        if ( S_AXI_ARESETN == 1'b0 )
            begin
              register_status = 0;
            end 
          else
            begin
            
            if(device_encFin)
               register_status[0] <= 1'b0;
               //start_encrytpion <= 1'b0;
            
            if(device_decFin)
               register_status[1] <= 1'b0;
               //start_decrytpion <= 1'b0;
               
            if(device_kgFin)
               register_status[2] <= 1'b1;
            
            if (fifoIn_full) begin
                //start_encrytpion <= 1'b1;
                register_status[3] <= 1'b1; 
            end
            else begin
                register_status[3] <= 1'b0;
            end
            
            if (fifoOut_full) begin
                //start_decrytpion <= 1'b1;
                register_status[4] <= 1'b1; 
            end
            else begin
                register_status[4] <= 1'b0;
            end
            
            if (fifoSeed_full) begin
                //start_key_generator <= 1'b1;
                register_status[5] <= 1'b1;
            end
            else begin
                register_status[5] <= 1'b0;
            end

        end
    end
    
    assign S_REG_STATUS = register_status;
    
    // ------------------------------------------
	// -- REG_STATUS Ends
	// ------------------------------------------
	
	
	
	// ------------------------------------------
	// -- REG_CONTROL Start
	/* --------- CONTROL REGISTER STRC ----------
    *
    *  0 - Encrypte Active
    *  1 - Decrypte Active
    *  2 - KG_Force
    *  3 - FIFO_IN_Flush
    *  4 - FIFO_OUT_Flush
    *  5 - FIFO_SEED_Flush
    *  6
    *  ...
    *  31
    *
    *  ------------------------------------------*/
	// ------------------------------------------	
	wire start_key_generator;      // Registro para indicar inicio de generación de llaves
	wire start_encrytpion;         // Registro para indicar inicio de encriptación
	wire start_decrytpion;         // Registro para indicar inicio de desencriptación
	wire flush_fifo_seed;          // Registro para indicar inicio acción de vaciar la FIFO_SEED	
	
	reg fifo_in_rden;     // Señal para leer en memoria de FIFO IN ¿Para que sirve? TODO rd: read y en: enable
    reg fifo_out_wren;      // Señal para escribir en memoria de FIFO OUT wr: write y en: enable
	reg fifo_out_rden;     // Registro para indicar inicio de lectura de FIFO_OUT
	
	assign regControl_wren = axi_wready && S_AXI_WVALID && reg_control_addr_active ;  // Bloque para controlar escritura en la FIFO_SEED
	
	always @( posedge S_AXI_ACLK )
	begin
        if ( S_AXI_ARESETN == 1'b0 )
            begin
              register_control <= 0;
            end 
          else
            begin
            
            if (regControl_wren) begin
                if (S_AXI_WDATA[0]) begin
                   //start_encrytpion <= 1'b1;
                   register_control[0] <= 1'b1; 
                   register_status[0] <= 1'b1;
                end
                
                if (S_AXI_WDATA[1]) begin
                   //start_decrytpion <= 1'b1;
                   register_control[1] <= 1'b1;
                   register_status[1] <= 1'b1;
                end
            end

            
            if (fifoSeed_full) begin
               //start_key_generator <= 1'b1;
               register_control[2] <= 1'b1; 
            end
    
            if(device_encFin)
               register_control[0] <= 1'b0;
               //start_encrytpion <= 1'b0;
            
            if(device_decFin)
               register_control[1] <= 1'b0;
               //start_decrytpion <= 1'b0;
               
            if(device_kgFin)
               register_control[2] <= 1'b0;
               //start_key_generator <= 1'b0;
        end
    end
    
    assign S_REG_CONTROL = register_control;
	
	// ------------------------------------------
	// -- REG_CONTROL Ends
	// ------------------------------------------
	
	
	
	// ------------------------------------------
	// -- FIFO_SEED Implementation Start
	// ------------------------------------------
    fifo_seed FIFO_SEED (
	   .clk(S_AXI_ACLK),
       .resetn(S_AXI_ARESETN),
       .write_fifo(fifo_seed_wren),
       .read_fifo(start_key_generator),
       .data_in(S_AXI_WDATA),
       .data_out(fifoSeed_outData),
       .empty_fifo(fifoSeed_empty),
       .full_fifo(fifoSeed_full)
	);
	
	assign fifo_seed_wren = axi_wready && S_AXI_WVALID && fifo_seed_addr_active ;  // Bloque para controlar escritura en la FIFO_SEED
	
	// ------------------------------------------
	// -- FIFO_SEED Implementation Ends
	// ------------------------------------------
	

	
	// ------------------------------------------
	// -- FIFOs_DATA Implementation Start
	// ------------------------------------------
	fifo_data_in FIFO_DATA_IN_1(
        .clk(S_AXI_ACLK),
        .resetn(S_AXI_ARESETN),
        .write_fifo(fifoIn_wren),
        .read_fifo(fifo_in_rden),
        .data_in(S_AXI_WDATA),
        .data_out(fifoIn_outData),
        .empty_fifo(fifoIn_empty),
        .full_fifo(fifoIn_full)
    );
	
    fifo_data_out FIFO_DATA_OUT_1(
        .clk(S_AXI_ACLK),
        .resetn(S_AXI_ARESETN),
        .write_fifo(fifo_out_wren), // Register para indicar cuando escribe dato de DEVICE a FIFO_OUT
        .read_fifo(fifo_out_rden),
        .data_in(device_outData),
        .data_out(fifoOut_outData),
        .empty_fifo(fifoOut_empty),
        .full_fifo(fifoOut_full)
    );
    
    assign fifoIn_wren = axi_wready && S_AXI_WVALID && fifo_data_addr_active ;     // Bloque para controlar escritura en la FIFO_IN  
    
    // TODO: Improve
    // Bloque para controlar lectura de la FIFO_IN
    always @( posedge register_control[0], posedge register_control[1] )
	begin
        if (S_AXI_ARESETN == 1'b0) begin
            // Estado inicial
            //fifo_in_rden <= 0;
        end else begin
            if ((register_control[0] || register_control[1]) && ~fifo_in_rden) begin
                fifo_in_rden <= 'b1; //TODO: Hacer que dure un ciclo de reloj
            end else begin
                fifo_in_rden <= 1'b0;
            end
        end
    end
    
    // TODO: Improve
    // Bloque para controlar escritura en la FIFO_OUT
    always @( negedge register_control[0], negedge register_control[1] )
	begin
        if (S_AXI_ARESETN == 1'b0) begin
            // Estado inicial
            //fifo_in_rden <= 0;
        end else begin
            if ((register_control[0] == 1'b0 || register_control[1] == 1'b0) && ~fifo_out_wren) begin
                fifo_out_wren <= 'b1; //TODO: Hacer que dure un ciclo de reloj
            end else begin
                fifo_out_wren <= 1'b0;
            end
        end
    end
    
    // TODO: Mejorable
    // Bloque para controlar lectura de la FIFO_OUT: fifo_out_rden
    // Bloque para controlar lectura de la FIFO_IN: fifo_in_rden
    // Bloque para controlar escritura en la FIFO_OUT: fifo_out_wren
    always @(posedge S_AXI_ACLK) begin

        if ( S_AXI_ARESETN == 1'b0 ) begin
            fifo_out_rden <= 0;
            fifo_in_rden <= 0;
            fifo_out_wren <= 0;
        end 
        else begin
            fifo_out_rden = axi_arv_arr_flag && axi_rvalid && ~fifo_out_rden ;
            if (fifo_in_rden) begin
                fifo_in_rden <= 'b0; //TODO: Hacer que dure un ciclo de reloj
            end
            if (fifo_out_wren) begin
                fifo_out_wren <= 'b0; //TODO: Hacer que dure un ciclo de reloj
            end
        end

	end

	// TODO: Bloque para controlar salida al BUS AXI
	always @(axi_rvalid)
	begin
	  if (axi_rvalid) 
	    begin
	      // Read address mux
	      axi_rdata <= fifoOut_outData;
	    end   
	  else
	    begin
	      axi_rdata <= 32'h00000000; // TODO - Lo dejamos?
	    end       
	end
		
	// ------------------------------------------
	// -- FIFOs_DATA Implementation Ends
	// ------------------------------------------
	
	
	
	// ------------------------------------------
	// -- Device AES-256 Implementation Start
	// ------------------------------------------	
	AES256_device DEVICE_AES256 (
        .clk(S_AXI_ACLK),
        .resetn(S_AXI_ARESETN),
        .seed(fifoSeed_outData),            // Salida de la FIFO_SEED: Datos que entran para generar la llave de encriptación
        // .datakey_in(),      // TODO - Que es esto? Indica al dispositivo cuando entran datos mediante el Input Device
        .inp_device(fifoIn_outData),   // Salida de la FIFO_IN: Datos que entran para encriptarse
        .ctrl_dataIn(S_REG_CONTROL),     // TODO - Que es esto? ARRAY [1:0] Indica al dispositivo cuando entran datos mediante el Input Device, para ctrl_dataIn[0] = 1 activa Encrypter, ctrl_dataIn[1] = 1 activa desencrypter y ctrl_dataIn[2] = 1 activa key_gen
        //.mod_en(2'b00),       // TODO - Que es esto? Indica si el modo es encrypt o decrypt??
        .enc_fin(device_encFin),  // Indica final de encriptación
        .dec_fin(device_decFin),  // Indica final de decriptación
        .kg_fin(device_kgFin),    // Indica final de generación de llaves
        .outp_device(device_outData) // Entrada de la FIFO_OUT: Datos de salida del device que van a la FIFO_OUT
        // .mod_decrease(),    // TODO - Que es esto? - Decrementar la FIFO de entrada
        // .data_debug()       // TODO - Que es esto? - Para ver los datos que pasan por el device
    );
    
	// ------------------------------------------
	// -- Device AES-256 Implementation Ends
	// ------------------------------------------
	
	// User logic ends

endmodule
