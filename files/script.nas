#hidegui
gui hotbar false
gui hand false
quit

#showgui
gui hotbar true
gui hand true
quit

#os2_die
if hasDied quit
set hasDied true
setspawn 59 2 123 0 0
setdeathspawn 59 2 123 0 0
kill @p&7 hit the floor &chard.
quit

#os2_resetdie
set hasDied false
quit

#os2_setup
boost 0 2 0 1 1 1 1000 0
quit