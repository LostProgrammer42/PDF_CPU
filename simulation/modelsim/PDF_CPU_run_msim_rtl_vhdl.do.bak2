transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {E:/Semester_4/Microprocessor_Project/Gates.vhdl}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/shift_eight.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/8_X_1_Mux_16_Bit.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/8_X_1_Demux_16_Bit.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/Register_File.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/shift_one.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/preprocessing.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/postprocessing.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/PIPO_Register.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/kogge_stone_node.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/Kogge_stone_adder_subtractor.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/kogge_stone.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/D_Flip_Flop.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/4_X_1_Mux_16_bit.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/2_X_1_Mux_16_Bit.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/2_X_1_Mux.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/Datapath.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/ALU.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/shift_four.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/shift_two.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/Shifter.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/PIPO_Register_3_Bit.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/2_X_1_Mux_3_Bit.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/Controlpath.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/Data_Memory.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/PDF_CPU.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/8_X_1_Demux_1_Bit.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/zero_padding.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/sixteen_bit_full_adder.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/Multiplier.vhd}
vcom -93 -work work {E:/Semester_4/Microprocessor_Project/full_adder.vhd}

vcom -93 -work work {E:/Semester_4/Microprocessor_Project/Testbench.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  CPU_Testbench

add wave *
view structure
view signals
run -all
