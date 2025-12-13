using allow_include

// THIS IS THE ORIGINAL IMPLEMENTATION OF PIPESTONE. PLEASE USE THE NEW VERSION.

#p
cmd mb {runArg1} /oss #run
quit

#run
set X {MBX}
set Y {MBY}
set Z {MBZ}
set b 0
setblockid id {MBCoords}
if label #runoffset call #runoffset
call #dogizmo
setblockid id {X} {Y} {Z}
call #box
resetdata packages box_*
allowmbrepeat
quit

#pipe-aY
set box_lastdir{b} aY
set lastdir aY
setadd Y 1
setblockid id {X} {Y} {Z}
if id|=|550 jump #pipe-aY
if id|=|238 jump #box
jump #dogizmo
quit

#pipe-sY
set box_lastdir{b} sY
set lastdir sY
setsub Y 1
setblockid id {X} {Y} {Z}
if id|=|550 jump #pipe-sY
if id|=|238 jump #box
jump #dogizmo
quit

#pipe-aX
set box_lastdir{b} aX
set lastdir aX
setadd X 1
setblockid id {X} {Y} {Z}
if id|=|551 jump #pipe-aX
if id|=|238 jump #box
jump #dogizmo
quit

#pipe-sX
set box_lastdir{b} sX
set lastdir sX
setsub X 1
setblockid id {X} {Y} {Z}
if id|=|551 jump #pipe-sX
if id|=|238 jump #box
jump #dogizmo
quit

#pipe-aZ
set box_lastdir{b} aZ
set lastdir aZ
setadd Z 1
setblockid id {X} {Y} {Z}
if id|=|552 jump #pipe-aZ
if id|=|238 jump #box
jump #dogizmo
quit

#pipe-sZ
set box_lastdir{b} sZ
set lastdir sZ
setsub Z 1
setblockid id {X} {Y} {Z}
if id|=|552 jump #pipe-sZ
if id|=|238 jump #box
jump #dogizmo
quit

#dogizmo
if box_giz_{X}_{Y}_{Z} quit
set box_giz_{X}_{Y}_{Z} true
setblockid id {X} {Y} {Z}
if label #gizmo call #gizmo
quit

#box
// prevent infinite loops
if box_pl_{X}_{Y}_{Z} quit
set box_pl_{X}_{Y}_{Z} true
// save coords of box #
set box_{b}_X {X}
set box_{b}_Y {Y}
set box_{b}_Z {Z}
//
// check add X
// set X {box_{b}_X}
// set Y {box_{b}_Y}
// set Z {box_{b}_Z}
setadd X 1
setblockid id {X} {Y} {Z}
if box_lastdir{b}|=|"sX" set id 0
setadd b 1
if id|=|551 call #pipe-aX
setsub b 1
//
// check sub X
set X {box_{b}_X}
set Y {box_{b}_Y}
set Z {box_{b}_Z}
setsub X 1
setblockid id {X} {Y} {Z}
if box_lastdir{b}|=|"aX" set id 0
setadd b 1
if id|=|551 call #pipe-sX
setsub b 1
//
// check add Y
set X {box_{b}_X}
set Y {box_{b}_Y}
set Z {box_{b}_Z}
setadd Y 1
setblockid id {X} {Y} {Z}
if box_lastdir{b}|=|"sY" set id 0
setadd b 1
if id|=|550 call #pipe-aY
setsub b 1
//
// check sub Y
set X {box_{b}_X}
set Y {box_{b}_Y}
set Z {box_{b}_Z}
setsub Y 1
setblockid id {X} {Y} {Z}
if box_lastdir{b}|=|"aY" set id 0
setadd b 1
if id|=|550 call #pipe-sY
setsub b 1
//
// check add Z
set X {box_{b}_X}
set Y {box_{b}_Y}
set Z {box_{b}_Z}
setadd Z 1
setblockid id {X} {Y} {Z}
if box_lastdir{b}|=|"sZ" set id 0
setadd b 1
if id|=|552 call #pipe-aZ
setsub b 1
//
// check sub Z
set X {box_{b}_X}
set Y {box_{b}_Y}
set Z {box_{b}_Z}
setsub Z 1
setblockid id {X} {Y} {Z}
if box_lastdir{b}|=|"aZ" set id 0
setadd b 1
if id|=|552 call #pipe-sZ
setsub b 1
quit