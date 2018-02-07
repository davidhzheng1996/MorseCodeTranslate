transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/VGA_Audio_PLL.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/Reset_Delay.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/skeleton.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/PS2_Interface.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/PS2_Controller.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/pll.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/imem.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/Hexadecimal_To_Seven_Segment.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/Altera_UP_PS2_Data_In.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/Altera_UP_PS2_Command_Out.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/vga_controller.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/video_sync_generator.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/img_index.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/img_data.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/ascii_to_seven_seg.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored/db {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/db/pll_altpll.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/processor.v}
vlog -sv -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/lcd.sv}

vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/Fall\ 2017/ECE\ 350/Final\ Project/lab7/lab7_restored {C:/Users/David/Documents/Fall 2017/ECE 350/Final Project/lab7/lab7_restored/skeleton_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  skeleton_tb

add wave *
view structure
view signals
run -all
