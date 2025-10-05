import FIFO_transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_coverage_pkg::*;
import shared_pkg::*;
module FIFO_tb(FIFO_IF.TEST fifoif);

FIFO_transaction fifo_txn_tb=new();

initial begin
    fifo_txn_tb.data_in=0;
    fifo_txn_tb.wr_en=0;
    fifo_txn_tb.rd_en=0;
    fifo_txn_tb.rst_n=0;

fifoif.rst_n=0;
@(negedge fifoif.clk);
fifoif.rst_n=1;

repeat(100000)begin
    @(negedge fifoif.clk); 
    assert(fifo_txn_tb.randomize());
    fifoif.data_in=fifo_txn_tb.data_in;
    fifoif.wr_en=fifo_txn_tb.wr_en;
    fifoif.rd_en=fifo_txn_tb.rd_en;
    fifoif.rst_n=fifo_txn_tb.rst_n;

    

     -> etrigger;
  
end
      test_finished=1;
end

endmodule 
    