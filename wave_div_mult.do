view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue HiZ -period 100ps -dutycycle 50 -starttime 0ps -endtime 50000ps sim:/cpu/clk 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 50000ps sim:/cpu/reset 
wave edit invert -start 0ps -end 100ps Edit:/cpu/reset 
WaveCollapseAll -1
wave clipboard restore
