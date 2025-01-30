#onJoin
resetdata packages box_*
quit

#run
set X {MBX}
set Y {MBY}
set Z {MBZ}
set b 0
setblockid type {MBCoords}
if type|=|766 setsub Y 1
if type|=|766 tempblock 765 {MBCoords}
call #box
resetdata packages box_*
setblockid type {MBCoords}
delay 1000
if type|=|766 tempblock 766 {MBCoords}
allowmbrepeat
quit

#pipe-aY
msg PIPE +Y AT {X} {Y} {Z}
setadd Y 1
setblockid id {X} {Y} {Z}
if id|=|550 jump #pipe-aY
if id|=|238 jump #box
jump #gizmo
quit

#pipe-sY
msg PIPE -Y AT {X} {Y} {Z}
setsub Y 1
setblockid id {X} {Y} {Z}
if id|=|550 jump #pipe-sY
if id|=|238 jump #box
jump #gizmo
quit

#pipe-aX
msg PIPE +X AT {X} {Y} {Z}
setadd X 1
setblockid id {X} {Y} {Z}
if id|=|552 jump #pipe-aX
if id|=|238 jump #box
jump #gizmo
quit

#pipe-sX
msg PIPE -X AT {X} {Y} {Z}
setsub X 1
setblockid id {X} {Y} {Z}
if id|=|552 jump #pipe-sX
if id|=|238 jump #box
jump #gizmo
quit

#pipe-aZ
msg PIPE +Z AT {X} {Y} {Z}
setadd Z 1
setblockid id {X} {Y} {Z}
if id|=|551 jump #pipe-aZ
if id|=|238 jump #box
jump #gizmo
quit

#pipe-sZ
msg PIPE -Z AT {X} {Y} {Z}
setsub Z 1
setblockid id {X} {Y} {Z}
if id|=|551 jump #pipe-sZ
if id|=|238 jump #box
jump #gizmo
quit

#gizmo
setblockid id {X} {Y} {Z}
if id|=|27 placeblock 32 {X} {Y} {Z}
if id|=|32 placeblock 27 {X} {Y} {Z}
msg GIZMO AT {X} {Y} {Z}
quit

#box
msg BOX AT {X} {Y} {Z}
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
setadd b 1
if id|=|552 call #pipe-aX
setsub b 1
//
// check sub X
set X {box_{b}_X}
set Y {box_{b}_Y}
set Z {box_{b}_Z}
setsub X 1
setblockid id {X} {Y} {Z}
setadd b 1
if id|=|552 call #pipe-sX
setsub b 1
//
// check add Y
set X {box_{b}_X}
set Y {box_{b}_Y}
set Z {box_{b}_Z}
setadd Y 1
setblockid id {X} {Y} {Z}
setadd b 1
if id|=|552 call #pipe-aY
setsub b 1
//
// check sub Y
set X {box_{b}_X}
set Y {box_{b}_Y}
set Z {box_{b}_Z}
setsub Y 1
setblockid id {X} {Y} {Z}
setadd b 1
if id|=|552 call #pipe-sY
setsub b 1
//
// check add Z
set X {box_{b}_X}
set Y {box_{b}_Y}
set Z {box_{b}_Z}
setadd Y 1
setblockid id {X} {Y} {Z}
setadd b 1
if id|=|552 call #pipe-aZ
setsub b 1
//
// check sub Z
set X {box_{b}_X}
set Y {box_{b}_Y}
set Z {box_{b}_Z}
setsub Y 1
setblockid id {X} {Y} {Z}
setadd b 1
if id|=|552 call #pipe-sZ
setsub b 1
quit