import FIFO_transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_coverage_pkg::*;
import shared_pkg::*;

module FIFO_monitor(FIFO_IF.MONITOR fifoif);
FIFO_transaction fifo_txn;
FIFO_scoreboard  fifo_board;
FIFO_coverage  fifo_cvg;

initial begin
fifo_txn=new();
fifo_board=new();
fifo_cvg=new();

 forever begin
   
//    wait(etrigger.triggered);
   @etrigger;

    fifo_txn.data_in=fifoif.data_in;
    fifo_txn.wr_en=fifoif.wr_en;
    fifo_txn.rd_en=fifoif.rd_en;
    fifo_txn.rst_n=fifoif.rst_n;
    fifo_txn.full=fifoif.full;
    fifo_txn.empty=fifoif.empty;
    fifo_txn.almostfull=fifoif.almostfull;
    fifo_txn.almostempty=fifoif.almostempty;
    fifo_txn.wr_ack=fifoif.wr_ack;
    fifo_txn.overflow=fifoif.overflow;
    fifo_txn.underflow=fifoif.underflow;
    fifo_txn.data_out=fifoif.data_out;

    fork
    begin
         fifo_cvg.sample_data(fifo_txn);
    end

    begin 
         fifo_board.check_data(fifo_txn) ;
    end     
    join  

    if(test_finished==1)begin
    $display("error_count =%d  ,correct_count =%d ",error_count,correct_count);
    $stop;
    end
    end
end

endmodule
 

