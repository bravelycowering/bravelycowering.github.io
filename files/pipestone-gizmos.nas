include os/bravelycowering+

#run
jump #Pipes.messageblock

#Pipes.prerun
if id|=|36 msg &cWhite cannot be used as a switch
if id|=|36 terminate
if id|=|171 msg &cSign cannot be used as a switch
if id|=|171 terminate
if id|=|766 setsub Y 1
quit

#Pipes.gizmo
// LEDS
if id|=|765 placeblock 215 {X} {Y} {Z}
if id|=|215 placeblock 765 {X} {Y} {Z}
// Lamps
if id|=|764 placeblock 62 {X} {Y} {Z}
if id|=|62 placeblock 764 {X} {Y} {Z}
// Message Blocks
if id|=|36 cmd m {X} {Y} {Z}
// Signs
if id|=|171 cmd m {X} {Y} {Z}
// Block dispensors
if id|=|758 jump #BP-N
if id|=|759 jump #BP-S
if id|=|760 jump #BP-E
if id|=|761 jump #BP-W
if id|=|762 jump #BP-U
if id|=|763 jump #BP-D
// Passthroughs
if id|=|756 jump #passthrough
// Swappers
if id|=|755 jump #BS-UD
if id|=|754 jump #BS-NS
if id|=|753 jump #BS-WE
quit

#passthrough
set temp:gizmo{X},{Y},{Z}
if dir|=|"X+" jump #Pipes.X+
if dir|=|"X-" jump #Pipes.X-
if dir|=|"Y+" jump #Pipes.Y+
if dir|=|"Y-" jump #Pipes.Y-
if dir|=|"Z+" jump #Pipes.Z+
if dir|=|"Z-" jump #Pipes.Z-
quit

#BP-W
set TEMP {X}
setadd TEMP 1
setblockid tempid {TEMP} {Y} {Z}
if tempid|=|0 placeblock 238 {TEMP} {Y} {Z}
if tempid|=|238 placeblock 0 {TEMP} {Y} {Z}
quit

#BP-E
set TEMP {X}
setsub TEMP 1
setblockid tempid {TEMP} {Y} {Z}
if tempid|=|0 placeblock 238 {TEMP} {Y} {Z}
if tempid|=|238 placeblock 0 {TEMP} {Y} {Z}
quit

#BP-N
set TEMP {Z}
setadd TEMP 1
setblockid tempid {X} {Y} {TEMP}
if tempid|=|0 placeblock 238 {X} {Y} {TEMP}
if tempid|=|238 placeblock 0 {X} {Y} {TEMP}
quit

#BP-S
set TEMP {Z}
setsub TEMP 1
setblockid tempid {X} {Y} {TEMP}
if tempid|=|0 placeblock 238 {X} {Y} {TEMP}
if tempid|=|238 placeblock 0 {X} {Y} {TEMP}
quit

#BP-D
set TEMP {Y}
setadd TEMP 1
setblockid tempid {X} {TEMP} {Z}
if tempid|=|0 placeblock 238 {X} {TEMP} {Z}
if tempid|=|238 placeblock 0 {X} {TEMP} {Z}
quit

#BP-U
set TEMP {Y}
setsub TEMP 1
setblockid tempid {X} {TEMP} {Z}
if tempid|=|0 placeblock 238 {X} {TEMP} {Z}
if tempid|=|238 placeblock 0 {X} {TEMP} {Z}
quit

#BS-UD
if dir|=|"Y+" quit
if dir|=|"Y-" quit
set TEMP1 {Y}
setadd TEMP1 1
setblockid tempid1 {X} {TEMP1} {Z}
set TEMP2 {Y}
setsub TEMP2 1
setblockid tempid2 {X} {TEMP2} {Z}
placeblock {tempid1} {X} {TEMP2} {Z}
placeblock {tempid2} {X} {TEMP1} {Z}
quit

#BS-NS
if dir|=|"Z+" quit
if dir|=|"Z-" quit
set TEMP1 {Z}
setadd TEMP1 1
setblockid tempid1 {X} {Y} {TEMP1}
set TEMP2 {Z}
setsub TEMP2 1
setblockid tempid2 {X} {Y} {TEMP2}
placeblock {tempid1} {X} {Y} {TEMP2}
placeblock {tempid2} {X} {Y} {TEMP1}
quit

#BS-WE
if dir|=|"X+" quit
if dir|=|"X-" quit
set TEMP1 {X}
setadd TEMP1 1
setblockid tempid1 {TEMP1} {Y} {Z}
set TEMP2 {X}
setsub TEMP2 1
setblockid tempid2 {TEMP2} {Y} {Z}
placeblock {tempid1} {TEMP2} {Y} {Z}
placeblock {tempid2} {TEMP1} {Y} {Z}
quit