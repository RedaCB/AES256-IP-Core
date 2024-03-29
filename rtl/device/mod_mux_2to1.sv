

module mod_mux_2to1(addr,
                    inp0, inp1, 
                    outp
                    );

    localparam nAddr = 4;
    localparam plaintxtL = 128;
    localparam N = 16;

    input                 addr;
    input [(N-1):0][7:0]  inp0;
    input [(N-1):0][7:0]  inp1;

    reg [(N-1):0][7:0]      aux;

    output reg [(N-1):0][7:0]   outp;

    assign outp = (addr == 0) ? inp0:inp1;

endmodule

/*
module mod_mux_2to1(addr,
                    inp0, inp1, 
                    outp
                    );

    localparam nAddr = 4;
    localparam plaintxtL = 128;
    localparam N = 16;

    input [3:0]           addr;
    input [(N-1):0][7:0]  inp0;
    input [(N-1):0][7:0]  inp1;

    reg [(N-1):0][7:0]      aux;

    output reg [(N-1):0][7:0]   outp;

    assign outp = (addr == 0) ? inp0:inp1;

endmodule
*/