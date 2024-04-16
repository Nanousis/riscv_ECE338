`include "constants.vh"
`include "config.vh"

module Imem (	input reset, 
				input ren, 
				input  [`TEXT_BITS-3:0] addr, 
				output [31:0] dout);

/****** SIGNALS ******/
reg [31:0] data[0:2**(`TEXT_BITS-2)-1];


/****** LOGIC ******/
assign dout = (reset == 1 && ren == 1) ? data[addr] : 32'b0;

///****** SIMULATION ******/
//`ifdef TEXT_HEX
//initial $readmemh(`TEXT_HEX, data);
//`endif

endmodule