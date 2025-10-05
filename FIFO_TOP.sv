module top();
bit clk;

initial begin
    clk=1;
    forever begin
        #1 clk=~clk;
    end
end

 FIFO_IF fifoif(clk);

 FIFO    DUT(fifoif);

 FIFO_tb TEST(fifoif);

 FIFO_monitor MONITOR(fifoif);

always_comb begin
	if(!fifoif.rst_n)
     a_reset: assert final(!fifoif.full&& fifoif.empty&& !fifoif.almostfull && !fifoif.almostempty
                            && !fifoif.wr_ack && !fifoif.overflow  && !fifoif.underflow);
end

endmodule



