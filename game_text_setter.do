vlib work

vlog -timescale 1ns/1ns game_text_setter.v

vsim game_text_setter

log {/*}

add wave {/*}

force {ingame} 1
force {main_difficulty} 0001
force {x_pointer} 0
force {y_pointer} 0
force {clk} 0 0,1 5 -r 10
force {score} 0000010000000
run 500ns