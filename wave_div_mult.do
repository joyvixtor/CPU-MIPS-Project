onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu/clk
add wave -noupdate /cpu/reset
add wave -noupdate -radix decimal /cpu/HI/Entrada
add wave -noupdate -radix decimal /cpu/HI/Saida
add wave -noupdate -radix decimal /cpu/HI/Load
add wave -noupdate -radix decimal /cpu/LOW/Entrada
add wave -noupdate -radix decimal /cpu/LOW/Saida
add wave -noupdate -radix decimal /cpu/LOW/Load
add wave -noupdate -childformat {{/cpu/Registers/Cluster(0) -radix decimal} {/cpu/Registers/Cluster(1) -radix decimal} {/cpu/Registers/Cluster(2) -radix decimal} {/cpu/Registers/Cluster(3) -radix decimal} {/cpu/Registers/Cluster(4) -radix decimal} {/cpu/Registers/Cluster(5) -radix decimal} {/cpu/Registers/Cluster(6) -radix decimal} {/cpu/Registers/Cluster(7) -radix decimal} {/cpu/Registers/Cluster(8) -radix decimal} {/cpu/Registers/Cluster(9) -radix decimal} {/cpu/Registers/Cluster(10) -radix decimal} {/cpu/Registers/Cluster(11) -radix decimal} {/cpu/Registers/Cluster(12) -radix decimal} {/cpu/Registers/Cluster(13) -radix decimal} {/cpu/Registers/Cluster(14) -radix decimal} {/cpu/Registers/Cluster(15) -radix decimal} {/cpu/Registers/Cluster(16) -radix decimal} {/cpu/Registers/Cluster(17) -radix decimal} {/cpu/Registers/Cluster(18) -radix decimal} {/cpu/Registers/Cluster(19) -radix decimal} {/cpu/Registers/Cluster(20) -radix decimal} {/cpu/Registers/Cluster(21) -radix decimal} {/cpu/Registers/Cluster(22) -radix decimal} {/cpu/Registers/Cluster(23) -radix decimal} {/cpu/Registers/Cluster(24) -radix decimal} {/cpu/Registers/Cluster(25) -radix decimal} {/cpu/Registers/Cluster(26) -radix decimal} {/cpu/Registers/Cluster(27) -radix decimal} {/cpu/Registers/Cluster(28) -radix decimal} {/cpu/Registers/Cluster(29) -radix decimal} {/cpu/Registers/Cluster(30) -radix decimal} {/cpu/Registers/Cluster(31) -radix decimal}} -expand -subitemconfig {/cpu/Registers/Cluster(0) {-height 15 -radix decimal} /cpu/Registers/Cluster(1) {-height 15 -radix decimal} /cpu/Registers/Cluster(2) {-height 15 -radix decimal} /cpu/Registers/Cluster(3) {-height 15 -radix decimal} /cpu/Registers/Cluster(4) {-height 15 -radix decimal} /cpu/Registers/Cluster(5) {-height 15 -radix decimal} /cpu/Registers/Cluster(6) {-height 15 -radix decimal} /cpu/Registers/Cluster(7) {-height 15 -radix decimal} /cpu/Registers/Cluster(8) {-height 15 -radix decimal} /cpu/Registers/Cluster(9) {-height 15 -radix decimal} /cpu/Registers/Cluster(10) {-height 15 -radix decimal} /cpu/Registers/Cluster(11) {-height 15 -radix decimal} /cpu/Registers/Cluster(12) {-height 15 -radix decimal} /cpu/Registers/Cluster(13) {-height 15 -radix decimal} /cpu/Registers/Cluster(14) {-height 15 -radix decimal} /cpu/Registers/Cluster(15) {-height 15 -radix decimal} /cpu/Registers/Cluster(16) {-height 15 -radix decimal} /cpu/Registers/Cluster(17) {-height 15 -radix decimal} /cpu/Registers/Cluster(18) {-height 15 -radix decimal} /cpu/Registers/Cluster(19) {-height 15 -radix decimal} /cpu/Registers/Cluster(20) {-height 15 -radix decimal} /cpu/Registers/Cluster(21) {-height 15 -radix decimal} /cpu/Registers/Cluster(22) {-height 15 -radix decimal} /cpu/Registers/Cluster(23) {-height 15 -radix decimal} /cpu/Registers/Cluster(24) {-height 15 -radix decimal} /cpu/Registers/Cluster(25) {-height 15 -radix decimal} /cpu/Registers/Cluster(26) {-height 15 -radix decimal} /cpu/Registers/Cluster(27) {-height 15 -radix decimal} /cpu/Registers/Cluster(28) {-height 15 -radix decimal} /cpu/Registers/Cluster(29) {-height 15 -radix decimal} /cpu/Registers/Cluster(30) {-height 15 -radix decimal} /cpu/Registers/Cluster(31) {-height 15 -radix decimal}} /cpu/Registers/Cluster
add wave -noupdate -radix decimal /cpu/controlUnit/STATE
add wave -noupdate -radix decimal /cpu/controlUnit/COUNTER
add wave -noupdate -radix decimal -childformat {{/cpu/alu/S(31) -radix decimal} {/cpu/alu/S(30) -radix decimal} {/cpu/alu/S(29) -radix decimal} {/cpu/alu/S(28) -radix decimal} {/cpu/alu/S(27) -radix decimal} {/cpu/alu/S(26) -radix decimal} {/cpu/alu/S(25) -radix decimal} {/cpu/alu/S(24) -radix decimal} {/cpu/alu/S(23) -radix decimal} {/cpu/alu/S(22) -radix decimal} {/cpu/alu/S(21) -radix decimal} {/cpu/alu/S(20) -radix decimal} {/cpu/alu/S(19) -radix decimal} {/cpu/alu/S(18) -radix decimal} {/cpu/alu/S(17) -radix decimal} {/cpu/alu/S(16) -radix decimal} {/cpu/alu/S(15) -radix decimal} {/cpu/alu/S(14) -radix decimal} {/cpu/alu/S(13) -radix decimal} {/cpu/alu/S(12) -radix decimal} {/cpu/alu/S(11) -radix decimal} {/cpu/alu/S(10) -radix decimal} {/cpu/alu/S(9) -radix decimal} {/cpu/alu/S(8) -radix decimal} {/cpu/alu/S(7) -radix decimal} {/cpu/alu/S(6) -radix decimal} {/cpu/alu/S(5) -radix decimal} {/cpu/alu/S(4) -radix decimal} {/cpu/alu/S(3) -radix decimal} {/cpu/alu/S(2) -radix decimal} {/cpu/alu/S(1) -radix decimal} {/cpu/alu/S(0) -radix decimal}} -subitemconfig {/cpu/alu/S(31) {-height 14 -radix decimal} /cpu/alu/S(30) {-height 14 -radix decimal} /cpu/alu/S(29) {-height 14 -radix decimal} /cpu/alu/S(28) {-height 14 -radix decimal} /cpu/alu/S(27) {-height 14 -radix decimal} /cpu/alu/S(26) {-height 14 -radix decimal} /cpu/alu/S(25) {-height 14 -radix decimal} /cpu/alu/S(24) {-height 14 -radix decimal} /cpu/alu/S(23) {-height 14 -radix decimal} /cpu/alu/S(22) {-height 14 -radix decimal} /cpu/alu/S(21) {-height 14 -radix decimal} /cpu/alu/S(20) {-height 14 -radix decimal} /cpu/alu/S(19) {-height 14 -radix decimal} /cpu/alu/S(18) {-height 14 -radix decimal} /cpu/alu/S(17) {-height 14 -radix decimal} /cpu/alu/S(16) {-height 14 -radix decimal} /cpu/alu/S(15) {-height 14 -radix decimal} /cpu/alu/S(14) {-height 14 -radix decimal} /cpu/alu/S(13) {-height 14 -radix decimal} /cpu/alu/S(12) {-height 14 -radix decimal} /cpu/alu/S(11) {-height 14 -radix decimal} /cpu/alu/S(10) {-height 14 -radix decimal} /cpu/alu/S(9) {-height 14 -radix decimal} /cpu/alu/S(8) {-height 14 -radix decimal} /cpu/alu/S(7) {-height 14 -radix decimal} /cpu/alu/S(6) {-height 14 -radix decimal} /cpu/alu/S(5) {-height 14 -radix decimal} /cpu/alu/S(4) {-height 14 -radix decimal} /cpu/alu/S(3) {-height 14 -radix decimal} /cpu/alu/S(2) {-height 14 -radix decimal} /cpu/alu/S(1) {-height 14 -radix decimal} /cpu/alu/S(0) {-height 14 -radix decimal}} /cpu/alu/S
add wave -noupdate -radix decimal /cpu/auxMuxMultDivA/data_0
add wave -noupdate -radix decimal /cpu/auxMuxMultDivB/data_0
add wave -noupdate /cpu/clk
add wave -noupdate /cpu/reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8543 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 189
configure wave -valuecolwidth 42
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1030 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue HiZ -period 100ps -dutycycle 50 -starttime 0ps -endtime 20000ps sim:/cpu/clk 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 20000ps sim:/cpu/reset 
wave edit invert -start 0ps -end 100ps Edit:/cpu/reset 
wave edit extend -extend to -time 50000ps 
wave edit extend -extend to -time 50000ps 
WaveCollapseAll -1
wave clipboard restore
