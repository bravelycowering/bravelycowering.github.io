include os/bravelycowering+

#runoffset
if id|=|36 msg &cWhite cannot be used as a switch
if id|=|36 terminate
if id|=|171 msg &cSign cannot be used as a switch
if id|=|171 terminate
if id|=|766 setsub Y 1
quit

#gizmo
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
quit

#BP-N
set TEMP {X}
setadd TEMP 1
set tempid {TEMP} {Y} {Z}
if tempid|=|0 placeblock 757 {TEMP} {Y} {Z}
if tempid|=|757 placeblock 0 {TEMP} {Y} {Z}
quit

#BP-S
set TEMP {X}
setsub TEMP 1
set tempid {TEMP} {Y} {Z}
if tempid|=|0 placeblock 757 {TEMP} {Y} {Z}
if tempid|=|757 placeblock 0 {TEMP} {Y} {Z}
quit

#BP-W
set TEMP {Z}
setadd TEMP 1
set tempid {X} {Y} {TEMP}
if tempid|=|0 placeblock 757 {X} {Y} {TEMP}
if tempid|=|757 placeblock 0 {X} {Y} {TEMP}
quit

#BP-E
set TEMP {Z}
setsub TEMP 1
set tempid {X} {Y} {TEMP}
if tempid|=|0 placeblock 757 {X} {Y} {TEMP}
if tempid|=|757 placeblock 0 {X} {Y} {TEMP}
quit

#BP-U
set TEMP {Y}
setadd TEMP 1
set tempid {X} {TEMP} {Z}
if tempid|=|0 placeblock 757 {X} {TEMP} {Z}
if tempid|=|757 placeblock 0 {X} {TEMP} {Z}
quit

#BP-D
set TEMP {Y}
setsub TEMP 1
set tempid {X} {TEMP} {Z}
if tempid|=|0 placeblock 757 {X} {TEMP} {Z}
if tempid|=|757 placeblock 0 {X} {TEMP} {Z}
quit