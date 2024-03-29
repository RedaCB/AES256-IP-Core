

/****** mod_reg16.sv *******/

// Inputs: 16 inputs, 8 bits each
// Outputs: 16 output, 8 bits

module mod_reg16_16to1( clk, resetn,
                        inp_reg163, wr_en, req_rom,
                        outp_reg163 
                      );

    localparam N = 16;
    integer index;

    input clk, resetn;
    input wr_en, req_rom;                                       // AddRK warns if it is ready to give input ; ROM requests information.
    input [(N-1):0][7:0] inp_reg163;                                     // Matrix as input coming from addRK.

    reg [(N-1):0][7:0] aux;                                     // Stores the 16 values when they are inputed.
    reg [3:0] n_read, n_read_delay;                             // Maintains accountability of the elements that have been read.

    
    output reg [7:0] outp_reg163;

    always @(posedge clk or negedge resetn)
    begin
        if(!resetn)
        begin
            aux <= 0;
        end

        else
        begin
            if(wr_en == 1)                                      // If information is ready in addRK, store it in aux register. 
                aux <= inp_reg163;

            /*
            $display("OUTPUT reg163: %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h, %h,", 
                                        aux[0], aux[1], aux[2], aux[3],
                                        aux[4], aux[5], aux[6], aux[7], 
                                        aux[8], aux[9], aux[10], aux[11], 
                                        aux[12], aux[13], aux[14], aux[15]);
            $display("-------------------------------------------------------------------------"); 
            */
            
        end
    end

    always @(posedge clk or negedge resetn)
    begin
        if(!resetn)
        begin
            n_read <= 0;
            n_read_delay <= 0;
        end
        else
        begin
            if(req_rom)                                        // ROM asks for information to the register
            begin
                n_read_delay <= n_read;

                if(n_read == N-1)                             // All data (16 bytes) have been read
                    n_read <= 0;
                else
                    n_read <= n_read + 1;
            end
        end
    end

    assign outp_reg163 = aux[n_read];
    
endmodule
