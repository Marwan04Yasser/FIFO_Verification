package FIFO_scoreboard_pkg;
import FIFO_transaction_pkg::*;
import shared_pkg::*;
logic full_ref=0, empty_ref=1,almostfull_ref=0,almostempty_ref=0,overflow_ref=0,underflow_ref=0;
logic [FIFO_WIDTH-1:0] data_out_ref;
class FIFO_scoreboard;
// logic full_ref=0, empty_ref=1,almostfull_ref=0,almostempty_ref=0,overflow_ref=0,underflow_ref=0;
logic [FIFO_WIDTH-1:0]data_mem [$];


function void reference_model(input FIFO_transaction F_ref_txn);

if(!F_ref_txn.rst_n)begin
   data_mem.delete();
   full_ref<=0;
   empty_ref<=1;
   overflow_ref<=0; 
   underflow_ref<=0;
end     
else begin
     
if(F_ref_txn.wr_en && (data_mem.size() < FIFO_DEPTH) )
     data_mem.push_back(F_ref_txn.data_in);
if(F_ref_txn.rd_en && !empty_ref)    
     data_out_ref<=data_mem.pop_front;

if(F_ref_txn.wr_en && !F_ref_txn.rd_en && full_ref )
     overflow_ref<=1;    
else  
     overflow_ref<=0; 

if(F_ref_txn.rd_en && !F_ref_txn.wr_en &&  empty_ref) 
   underflow_ref<=1;
else
   underflow_ref<=0; 

  if (data_mem.size()==FIFO_DEPTH) full_ref<=1;
  else full_ref<=0;

  if(data_mem.size()==0) empty_ref<=1;
  else    empty_ref<=0;

end
  if(data_mem.size() == FIFO_DEPTH-1)  almostfull_ref  <=   1 ;
  else  almostfull_ref<= 0; 
  
  if(data_mem.size() == 1)  almostempty_ref <=1 ;
  else  almostempty_ref <= 0;

endfunction 

task check_data(input FIFO_transaction F_chk_txn);
reference_model(F_chk_txn); 
if(data_out_ref!=F_chk_txn.data_out  ||  full_ref!=F_chk_txn.full || empty_ref!=F_chk_txn.empty
   ||almostfull_ref!=F_chk_txn.almostfull ||almostempty_ref!=F_chk_txn.almostempty
   ||overflow_ref!=F_chk_txn.overflow|| underflow_ref!=F_chk_txn.underflow )begin 
      $display("ERROR: incorrect data_out   , data_out =%h    ,EXPECTED =%h",F_chk_txn.data_out,data_out_ref);
      $display("rst_n=%b , wr_en=%b , rd_en =%b , data_in =%h , full=%b ,full_ref=%b, empty=%b ,empty_ref=%b ,
      almostfull=%b,almostfull_ref=%b ,almostempty=%b,almostempty_ref=%b,overflow=%b,overflow_ref=%b,underflow=%b,
       underflow_ref=%b ",
      F_chk_txn.rst_n,F_chk_txn.wr_en,F_chk_txn.rd_en,F_chk_txn.data_in,F_chk_txn.full,full_ref,F_chk_txn.empty,empty_ref,
      F_chk_txn.almostfull,almostfull_ref,F_chk_txn.almostempty,almostempty_ref,F_chk_txn.overflow,overflow_ref,
      F_chk_txn.underflow, underflow_ref);
      $display("-----------------------------------");
     error_count=error_count+1;
end
else begin
     correct_count=correct_count+1;
end

endtask
endclass
endpackage



