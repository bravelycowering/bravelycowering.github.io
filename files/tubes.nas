#onJoin
resetdata packages box_*
quit

#p
cmd /mb 766 /oss #run
quit

#debug
if debug jump #debugoff
ifnot debug jump #debugon
quit

#debugoff
set debug false
quit

#debugon
set debug true
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
if debug msg PIPE +Y AT {X} {Y} {Z}
setadd Y 1
setblockid id {X} {Y} {Z}
if id|=|550 jump #pipe-aY
if id|=|238 jump #box
jump #gizmo
quit

#pipe-sY
if debug msg PIPE -Y AT {X} {Y} {Z}
setsub Y 1
setblockid id {X} {Y} {Z}
if id|=|550 jump #pipe-sY
if id|=|238 jump #box
jump #gizmo
quit

#pipe-aX
if debug msg PIPE +X AT {X} {Y} {Z}
setadd X 1
setblockid id {X} {Y} {Z}
if id|=|551 jump #pipe-aX
if id|=|238 jump #box
jump #gizmo
quit

#pipe-sX
if debug msg PIPE -X AT {X} {Y} {Z}
setsub X 1
setblockid id {X} {Y} {Z}
if id|=|551 jump #pipe-sX
if id|=|238 jump #box
jump #gizmo
quit

#pipe-aZ
if debug msg PIPE +Z AT {X} {Y} {Z}
setadd Z 1
setblockid id {X} {Y} {Z}
if id|=|552 jump #pipe-aZ
if id|=|238 jump #box
jump #gizmo
quit

#pipe-sZ
if debug msg PIPE -Z AT {X} {Y} {Z}
setsub Z 1
setblockid id {X} {Y} {Z}
if id|=|552 jump #pipe-sZ
if id|=|238 jump #box
jump #gizmo
quit

#gizmo
setblockid id {X} {Y} {Z}
if id|=|764 placeblock 62 {X} {Y} {Z}
if id|=|62 placeblock 764 {X} {Y} {Z}
quit

#box
if debug msg BOX AT {X} {Y} {Z}
// prevent infinite loops
if box_pl_{X}_{Y}_{Z} quit
// add a small delay when using a box
delay 100
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
if id|=|551 call #pipe-aX
setsub b 1
//
// check sub X
set X {box_{b}_X}
set Y {box_{b}_Y}
set Z {box_{b}_Z}
setsub X 1
setblockid id {X} {Y} {Z}
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
setadd b 1
if id|=|552 call #pipe-sZ
setsub b 1
quit