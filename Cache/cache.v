module L1_cache #(
    parameter ADRESSSIZE = 32,
    parameter DATASIZE = 8,
    parameter INDEXSIZE = 4,
    parameter OFFSETSIZE = 2,
    parameter TAGSIZE = ADRESSSIZE - INDEXSIZE - OFFSETSIZE
) (
    input [ADRESSSIZE-1:0] address,
    output [DATASIZE-1:0] data_out,
    input clk,
    // THIS IS USED FOR WRITE OPERATION
    input write_enable,
    input [DATASIZE-1:0] data_in,
    input reset,
    // Our output
    output data_ready,
    // READ FROM CHUCK NORRI'S MEMORY
    input [DATASIZE-1:0] bram_out;
    output [ADRESSSIZE  - 1:0] bram_address,
    output bram_enable,
    output bram_write_enable,
    input bram_dataReady,


);

    // Define the cache as a 2D array of registers
    reg [DATASIZE-1:0] cache [0:2**INDEXSIZE-1][0:2**TAGSIZE-1];
    // Define the valid bit array
    reg valid [0:2**INDEXSIZE-1][0:2**TAGSIZE-1];

    // Define the offset, index and tag from the address
    wire [OFFSETSIZE-1:0] offset = address[OFFSETSIZE-1:0];
    wire [INDEXSIZE-1:0] index = address[OFFSETSIZE+INDEXSIZE-1:OFFSETSIZE];
    wire [TAGSIZE-1:0] tag = address[ADRESSSIZE-1:OFFSETSIZE+INDEXSIZE];

    integer i, j;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Clear the cache and valid bits
            for (i = 0; i < 2**INDEXSIZE; i = i + 1) begin
                for (j = 0; j < 2**TAGSIZE; j = j + 1) begin
                    cache[i][j] <= 0;
                    valid[i][j] <= 0;
                end
            end
        end else if (write_enable) begin
            // Write data to cache and set valid bit
            cache[index][tag] <= data_in;
            valid[index][tag] <= 1;
        end else begin
            // Read data from cache if valid
            if (valid[index][tag]) begin
                data_out <= cache[index][tag];
            end
            else
            begin
                bram_address <= address;
                data_out <= bram_out;
            end
        end
    end

endmodule