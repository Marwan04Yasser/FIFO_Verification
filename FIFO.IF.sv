interface FIFO_IF(clk);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
input  bit clk;
logic [FIFO_WIDTH-1:0] data_in;
bit rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;
 
localparam max_fifo_addr = $clog2(FIFO_DEPTH);

modport TEST   (output data_in, wr_en, rd_en, rst_n,
                input clk, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);

modport DUT    (input data_in, wr_en, rd_en, clk, rst_n,
                output full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);

modport MONITOR(input data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);

endinterface

