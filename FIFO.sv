////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_IF.DUT fifoif);

reg [fifoif.FIFO_WIDTH-1:0] mem [fifoif.FIFO_DEPTH-1:0];

reg [fifoif.max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [fifoif.max_fifo_addr:0] count;

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		wr_ptr <= 0;
		fifoif.wr_ack <= 0; // bug
		fifoif.overflow <= 0; //bug

	end
	else if (fifoif.wr_en && count < fifoif.FIFO_DEPTH) begin
		mem[wr_ptr] <= fifoif.data_in;
		fifoif.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		fifoif.wr_ack <= 0; 
		if (fifoif.full && fifoif.wr_en && !fifoif.rd_en)  //bug foget condition of !rd_en
			fifoif.overflow <= 1; 
		else
			fifoif.overflow <= 0;  
	end
end

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		rd_ptr <= 0;
	    fifoif.underflow<=0; //bug 
	end
	else if (fifoif.rd_en && count != 0) begin
		fifoif.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	// underflow is a sequential output here
	else begin
		if(fifoif.empty && fifoif.rd_en && !fifoif.wr_en) 
            fifoif.underflow<=1;
		else	 
            fifoif.underflow<=0;
    end
end	

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({fifoif.wr_en, fifoif.rd_en} == 2'b10) && !fifoif.full) 
			count <= count + 1;
		else if ( ({fifoif.wr_en, fifoif.rd_en} == 2'b01) && !fifoif.empty)
			count <= count - 1;
		else if ( ({fifoif.wr_en, fifoif.rd_en} == 2'b11) && fifoif.empty)
		    count <= count+1;
		else if ( ({fifoif.wr_en, fifoif.rd_en} == 2'b11) && fifoif.full)
		    count <= count-1;	
	end
end

assign fifoif.full = (count == fifoif.FIFO_DEPTH)? 1 : 0;
assign fifoif.empty = (count == 0)? 1 : 0;
//bug  underflow was combinational
assign fifoif.almostfull = (count == fifoif.FIFO_DEPTH-1)? 1 : 0; //bug fifoif.FIFO_DEPTH-2
assign fifoif.almostempty = (count == 1)? 1 : 0;



// assertions
// 1
always_comb begin
	if(!fifoif.rst_n)
     a_reset: assert final( (wr_ptr==0) && (rd_ptr==0)  && (count==0));
end
// 2
property Write_Acknowledge;
	@(posedge fifoif.clk) disable iff(!fifoif.rst_n)   (fifoif.wr_en && !fifoif.full) |=> fifoif.wr_ack;
endproperty
// 3
property Overflow_Detection;
    @(posedge fifoif.clk) disable iff(!fifoif.rst_n)   (fifoif.wr_en && fifoif.full && !fifoif.rd_en)  |=> fifoif.overflow ;
endproperty	
// 4
property Underflow_Detection;
    @(posedge fifoif.clk) disable iff(!fifoif.rst_n)   (fifoif.rd_en && !fifoif.wr_en && fifoif.empty) |=> fifoif.underflow ;
endproperty	
// 5
property Empty_Flag_Assertion;
    @(posedge fifoif.clk) disable iff(!fifoif.rst_n)   (count==0)  |-> fifoif.empty ;
endproperty	
// 6
property Full_Flag_Assertion;
    @(posedge fifoif.clk) disable iff(!fifoif.rst_n)   (count == fifoif.FIFO_DEPTH)  |-> fifoif.full ;
endproperty	
// 7
property Almost_Full_Condition;
    @(posedge fifoif.clk) disable iff(!fifoif.rst_n)   (count == fifoif.FIFO_DEPTH-1)  |-> fifoif.almostfull ;
endproperty	
// 8
property Almost_Empty_Condition;
    @(posedge fifoif.clk) disable iff(!fifoif.rst_n)   (count == 1)  |-> fifoif.almostempty ;
endproperty	
// 9
 property Pointer_Wraparound_1;
     @(posedge fifoif.clk)  disable iff(!fifoif.rst_n)  ( (wr_ptr==fifoif.FIFO_DEPTH-1) && fifoif.wr_en && (count<=fifoif.FIFO_DEPTH-1)) |=>  $fell(wr_ptr);
endproperty	 
 property Pointer_Wraparound_2;
    @(posedge fifoif.clk)  disable iff(!fifoif.rst_n)  ( (rd_ptr==fifoif.FIFO_DEPTH-1) && fifoif.rd_en && (count>0) )  |=>  $fell(rd_ptr);
endproperty	 
 property Pointer_Wraparound_3;
     @(!fifoif.rst_n)   ( $past(count)==fifoif.FIFO_DEPTH) |-> (count==0);
endproperty	 
// 10
property Pointer_threshold;
    @(posedge fifoif.clk)  disable iff(!fifoif.rst_n)  ((wr_ptr < fifoif.FIFO_DEPTH) && (rd_ptr < fifoif.FIFO_DEPTH) && (count <= fifoif.FIFO_DEPTH));
endproperty
// 11
property wr_rd_simul_empty;
  @(posedge fifoif.clk) disable iff(!fifoif.rst_n)    (fifoif.wr_en && fifoif.rd_en && fifoif.empty) |=> (!fifoif.empty);
endproperty
// 12  
property wr_rd_simul_full;
  @(posedge fifoif.clk) disable iff(!fifoif.rst_n)    (fifoif.wr_en && fifoif.rd_en && fifoif.full) |=> (!fifoif.full);
endproperty

assert property(Write_Acknowledge);
assert property(Overflow_Detection);
assert property(Underflow_Detection);
assert property(Empty_Flag_Assertion);
assert property(Full_Flag_Assertion);
assert property(Almost_Full_Condition);
assert property(Almost_Empty_Condition);
assert property(Pointer_Wraparound_1);
assert property(Pointer_Wraparound_2);
assert property(Pointer_Wraparound_3);
assert property(Pointer_threshold);
assert property (wr_rd_simul_empty);
assert property (wr_rd_simul_full);

// cover
cover   final( (wr_ptr==0) && (rd_ptr==0)  && (count==0));
cover  property(Write_Acknowledge);
cover  property(Overflow_Detection);
cover  property(Underflow_Detection);
cover  property(Empty_Flag_Assertion);
cover  property(Full_Flag_Assertion);
cover  property(Almost_Full_Condition);
cover  property(Almost_Empty_Condition);
cover  property(Pointer_Wraparound_1);
cover  property(Pointer_Wraparound_2);
cover  property(Pointer_Wraparound_3);
cover  property(Pointer_threshold);
cover  property (wr_rd_simul_empty);
cover  property (wr_rd_simul_full);


endmodule










