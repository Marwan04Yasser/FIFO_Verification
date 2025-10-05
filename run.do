vlib work
vlog  -f src_file.list +cover -covercells
vsim -voptargs=+acc work.top -cover  -sv_seed random
add wave /top/fifoif/* 
add wave -position insertpoint sim:/FIFO_scoreboard_pkg/*
coverage save TOP_FIFO.ucdb -du FIFO   -onexit
run -all


