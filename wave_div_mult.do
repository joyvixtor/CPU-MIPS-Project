onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu/clk
add wave -noupdate /cpu/reset
add wave -noupdate -radix decimal /cpu/controlUnit/STATE
add wave -noupdate -radix decimal /cpu/HI/Load
add wave -noupdate -radix decimal /cpu/HI/Entrada
add wave -noupdate -radix decimal /cpu/HI/Saida
add wave -noupdate -radix decimal /cpu/LOW/Entrada
add wave -noupdate -radix decimal /cpu/LOW/Saida
add wave -noupdate -childformat {{/cpu/Registers/Cluster(0) -radix decimal} {/cpu/Registers/Cluster(1) -radix decimal} {/cpu/Registers/Cluster(2) -radix decimal} {/cpu/Registers/Cluster(3) -radix decimal} {/cpu/Registers/Cluster(4) -radix decimal} {/cpu/Registers/Cluster(5) -radix decimal} {/cpu/Registers/Cluster(6) -radix decimal} {/cpu/Registers/Cluster(7) -radix decimal} {/cpu/Registers/Cluster(8) -radix decimal} {/cpu/Registers/Cluster(9) -radix decimal} {/cpu/Registers/Cluster(10) -radix decimal} {/cpu/Registers/Cluster(11) -radix decimal} {/cpu/Registers/Cluster(12) -radix decimal} {/cpu/Registers/Cluster(13) -radix decimal} {/cpu/Registers/Cluster(14) -radix decimal} {/cpu/Registers/Cluster(15) -radix decimal} {/cpu/Registers/Cluster(16) -radix decimal} {/cpu/Registers/Cluster(17) -radix decimal} {/cpu/Registers/Cluster(18) -radix decimal} {/cpu/Registers/Cluster(19) -radix decimal} {/cpu/Registers/Cluster(20) -radix decimal} {/cpu/Registers/Cluster(21) -radix decimal} {/cpu/Registers/Cluster(22) -radix decimal} {/cpu/Registers/Cluster(23) -radix decimal} {/cpu/Registers/Cluster(24) -radix decimal} {/cpu/Registers/Cluster(25) -radix decimal} {/cpu/Registers/Cluster(26) -radix decimal} {/cpu/Registers/Cluster(27) -radix decimal} {/cpu/Registers/Cluster(28) -radix decimal} {/cpu/Registers/Cluster(29) -radix decimal} {/cpu/Registers/Cluster(30) -radix decimal} {/cpu/Registers/Cluster(31) -radix decimal}} -expand -subitemconfig {/cpu/Registers/Cluster(0) {-height 15 -radix decimal} /cpu/Registers/Cluster(1) {-height 15 -radix decimal} /cpu/Registers/Cluster(2) {-height 15 -radix decimal} /cpu/Registers/Cluster(3) {-height 15 -radix decimal} /cpu/Registers/Cluster(4) {-height 15 -radix decimal} /cpu/Registers/Cluster(5) {-height 15 -radix decimal} /cpu/Registers/Cluster(6) {-height 15 -radix decimal} /cpu/Registers/Cluster(7) {-height 15 -radix decimal} /cpu/Registers/Cluster(8) {-height 15 -radix decimal} /cpu/Registers/Cluster(9) {-height 15 -radix decimal} /cpu/Registers/Cluster(10) {-height 15 -radix decimal} /cpu/Registers/Cluster(11) {-height 15 -radix decimal} /cpu/Registers/Cluster(12) {-height 15 -radix decimal} /cpu/Registers/Cluster(13) {-height 15 -radix decimal} /cpu/Registers/Cluster(14) {-height 15 -radix decimal} /cpu/Registers/Cluster(15) {-height 15 -radix decimal} /cpu/Registers/Cluster(16) {-height 15 -radix decimal} /cpu/Registers/Cluster(17) {-height 15 -radix decimal} /cpu/Registers/Cluster(18) {-height 15 -radix decimal} /cpu/Registers/Cluster(19) {-height 15 -radix decimal} /cpu/Registers/Cluster(20) {-height 15 -radix decimal} /cpu/Registers/Cluster(21) {-height 15 -radix decimal} /cpu/Registers/Cluster(22) {-height 15 -radix decimal} /cpu/Registers/Cluster(23) {-height 15 -radix decimal} /cpu/Registers/Cluster(24) {-height 15 -radix decimal} /cpu/Registers/Cluster(25) {-height 15 -radix decimal} /cpu/Registers/Cluster(26) {-height 15 -radix decimal} /cpu/Registers/Cluster(27) {-height 15 -radix decimal} /cpu/Registers/Cluster(28) {-height 15 -radix decimal} /cpu/Registers/Cluster(29) {-height 15 -radix decimal} /cpu/Registers/Cluster(30) {-height 15 -radix decimal} /cpu/Registers/Cluster(31) {-height 15 -radix decimal}} /cpu/Registers/Cluster
add wave -noupdate -radix decimal /cpu/div/quotient
add wave -noupdate -radix decimal /cpu/div/remainder
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12797 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ps
update
WaveRestoreZoom {12268 ps} {13268 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue HiZ -period 100ps -dutycycle 50 -starttime 0ps -endtime 50000ps sim:/cpu/clk 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 50000ps sim:/cpu/reset 
wave edit invert -start 0ps -end 100ps Edit:/cpu/reset 
WaveCollapseAll -1
wave clipboard restore
