package FIFO_transaction_pkg;
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
class FIFO_transaction;
bit clk;
rand bit [FIFO_WIDTH-1:0] data_in;
rand bit rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

int RD_EN_ON_DIST , WR_EN_ON_DIST;

function new(int  RD_EN_ON_DIST=30 , WR_EN_ON_DIST=70);
 this.RD_EN_ON_DIST=RD_EN_ON_DIST ;
 this.WR_EN_ON_DIST=WR_EN_ON_DIST ;
endfunction 

constraint reset{ rst_n  dist {0:/10 , 1:/90};}
constraint WR_EN{ wr_en  dist {1:/WR_EN_ON_DIST , 0:/(100-WR_EN_ON_DIST)};}
constraint RD_EN{ rd_en  dist {1:/RD_EN_ON_DIST , 0:/(100-RD_EN_ON_DIST)};}

endclass
endpackage

