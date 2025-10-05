package FIFO_coverage_pkg;
import FIFO_transaction_pkg::*;
class FIFO_coverage;
FIFO_transaction   F_cvg_txn=new();
covergroup g1;
WR_EN       : coverpoint F_cvg_txn.wr_en ;
RD_EN       : coverpoint F_cvg_txn.rd_en ;
WR_ACK      : coverpoint F_cvg_txn.wr_ack ;
OVERFLOW    : coverpoint F_cvg_txn.overflow ;
FULL        : coverpoint F_cvg_txn.overflow ; 
EMPTY       : coverpoint F_cvg_txn.empty ;
ALMOSTFULL  : coverpoint F_cvg_txn.almostfull ;
ALMOSTEMPTY : coverpoint F_cvg_txn.almostempty ;
UNDERFLOW   : coverpoint F_cvg_txn.underflow ;

wr_en_rd_en_WR_ACK      :cross WR_EN , RD_EN , WR_ACK  ;
wr_en_rd_en_OVERFLOW    :cross WR_EN , RD_EN , OVERFLOW ;
wr_en_rd_en_FULL        :cross WR_EN , RD_EN ,FULL       ;
wr_en_rd_en_EMPTY       :cross WR_EN , RD_EN ,EMPTY      ;
wr_en_rd_en_ALMOSTFULL  :cross WR_EN , RD_EN ,ALMOSTFULL ;
wr_en_rd_en_ALMOSTEMPTY :cross WR_EN , RD_EN ,ALMOSTEMPTY;
wr_en_rd_en_UNDERFLOW   :cross WR_EN , RD_EN ,UNDERFLOW  ;
endgroup

//constructor
function new();
  g1 =new;
endfunction
//
function void sample_data(input FIFO_transaction F_txn);
F_cvg_txn=F_txn; 
g1.sample();
endfunction

endclass
endpackage