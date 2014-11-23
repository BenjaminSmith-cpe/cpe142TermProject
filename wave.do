onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TopLevel /stimulus/dut/program_memory/memory
add wave -noupdate -expand -group TopLevel /stimulus/dut/clk
add wave -noupdate -expand -group TopLevel /stimulus/dut/rst
add wave -noupdate -expand -group TopLevel /stimulus/dut/PC_address
add wave -noupdate -expand -group TopLevel /stimulus/dut/PC_next_jump
add wave -noupdate -expand -group TopLevel /stimulus/dut/PC_next_nojump
add wave -noupdate -expand -group TopLevel /stimulus/dut/alucontrol
add wave -noupdate -expand -group TopLevel /stimulus/dut/aluin
add wave -noupdate -expand -group TopLevel /stimulus/dut/aluout
add wave -noupdate -expand -group TopLevel /stimulus/dut/alustat
add wave -noupdate -expand -group TopLevel /stimulus/dut/instruction
add wave -noupdate -group {register file} /stimulus/dut/register_file/rst
add wave -noupdate -group {register file} /stimulus/dut/register_file/clk
add wave -noupdate -group {register file} /stimulus/dut/register_file/halt_sys
add wave -noupdate -group {register file} /stimulus/dut/register_file/R0_read
add wave -noupdate -group {register file} /stimulus/dut/register_file/ra1
add wave -noupdate -group {register file} /stimulus/dut/register_file/ra2
add wave -noupdate -group {register file} /stimulus/dut/register_file/write_en
add wave -noupdate -group {register file} /stimulus/dut/register_file/R0_en
add wave -noupdate -group {register file} /stimulus/dut/register_file/write_address
add wave -noupdate -group {register file} /stimulus/dut/register_file/write_data
add wave -noupdate -group {register file} /stimulus/dut/register_file/write_data_low
add wave -noupdate -group {register file} /stimulus/dut/register_file/write_data_high
add wave -noupdate -group {register file} /stimulus/dut/register_file/registers
add wave -noupdate -group {register file} /stimulus/dut/register_file/rd2
add wave -noupdate -group {register file} /stimulus/dut/register_file/rd1
add wave -noupdate -expand -group ALU /stimulus/dut/main_alu/control
add wave -noupdate -expand -group ALU /stimulus/dut/main_alu/in
add wave -noupdate -expand -group ALU /stimulus/dut/main_alu/out
add wave -noupdate -expand -group ALU /stimulus/dut/main_alu/stat
add wave -noupdate -expand -group ALU /stimulus/dut/main_alu/carry
add wave -noupdate -expand -group alu_control /stimulus/dut/alu_control/ALUop
add wave -noupdate -expand -group alu_control /stimulus/dut/alu_control/func
add wave -noupdate -expand -group alu_control /stimulus/dut/alu_control/alu_ctrl
add wave -noupdate -expand -group Main_Control /stimulus/dut/Control_unit/div0
add wave -noupdate -expand -group Main_Control /stimulus/dut/Control_unit/func
add wave -noupdate -expand -group Main_Control /stimulus/dut/Control_unit/opcode
add wave -noupdate -expand -group Main_Control /stimulus/dut/Control_unit/overflow
add wave -noupdate -expand -group Main_Control /stimulus/dut/Control_unit/ALUop
add wave -noupdate -expand -group Main_Control /stimulus/dut/Control_unit/R0_read
add wave -noupdate -expand -group Main_Control /stimulus/dut/Control_unit/halt_sys
add wave -noupdate -expand -group Main_Control /stimulus/dut/Control_unit/mem2r
add wave -noupdate -expand -group Main_Control /stimulus/dut/Control_unit/memwr
add wave -noupdate -expand -group Main_Control /stimulus/dut/Control_unit/offset_sel
add wave -noupdate -expand -group Main_Control /stimulus/dut/Control_unit/reg_wr
add wave -noupdate -expand -group Main_Control /stimulus/dut/Control_unit/se_imm_a
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {69 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 303
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {74 ns} {102 ns}
