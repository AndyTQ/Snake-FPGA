vlib work

vlog -timescale 1ns/1ns snake_top_level.v

vsim Controller

log {/*}

add wave {/*}

force {num_1} 0 0, 1 400
force {num_2} 0
force {num_3} 0
force {direction} 00000
force {clk} 0 0,1 5 -r 10
run 500ns