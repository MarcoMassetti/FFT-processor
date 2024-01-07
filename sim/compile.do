vlib work

vcom ../File_VHD/BUTTERFLY.vhd
vcom ../File_VHD/CU.vhd
vcom ../File_VHD/DP.vhd
vcom ../File_VHD/FFT_Adder.vhd
vcom ../File_VHD/FFT_Multiplier.vhd
vcom ../File_VHD/FFT_RoundingHU.vhd
vcom ../File_VHD/FFT_Subtractor.vhd
vcom ../File_VHD/MUX2to1_Nbit.vhd
vcom ../File_VHD/MUX2to1_Nbit_sf.vhd
vcom ../File_VHD/MUX4to1_Nbit.vhd
vcom ../File_VHD/PIPE.vhd
vcom ../File_VHD/PLA.vhd
vcom ../File_VHD/REG.vhd
vcom ../File_VHD/FF_D.vhd
vcom ../File_VHD/ROM.vhd
vcom ../File_VHD/testbench_BUTTERFLY.vhd
vcom ../File_VHD/testbench_BUTTERFLY_MOD_CONTINUA.vhd
vcom ../File_VHD/uAR.vhd
vcom ../File_VHD/uIR.vhd

#vsim -c work.testbench_BUTTERFLY
vsim -c work.testbench_BUTTERFLY_MOD_CONTINUA


run 20ms

quit -f
