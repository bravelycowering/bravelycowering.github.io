// Pipestone
include os/bravelycowering+

// Print version number
#onJoin
jump #Pipes:version

// Prevent every map ever from breaking
#run
jump #Pipes:messageblock

// White
#Pipes:prerun[36]
	if id|=|36 msg &cWhite cannot be used as a switch
	if id|=|36 jump #Pipes:terminate
quit

// Sign
#Pipes:prerun[171]
	if id|=|171 msg &cSign cannot be used as a switch
	if id|=|171 jump #Pipes:terminate
quit

// Pressure plate
#Pipes:prerun[766]
	if id|=|766 setsub Y 1
quit

// Lamp Off
#Pipes:gizmo[764]
	placeblock 62 {X} {Y} {Z}
quit

// Lamp
#Pipes:gizmo[62]
	placeblock 764 {X} {Y} {Z}
quit

// Light Off
#Pipes:gizmo[765]
	placeblock 215 {X} {Y} {Z}
quit

// Light
#Pipes:gizmo[215]
	placeblock 765 {X} {Y} {Z}
quit

// White
#Pipes:gizmo[36]
	cmd m {X} {Y} {Z}
quit

// Sign
#Pipes:gizmo[171]
	cmd m {X} {Y} {Z}
quit

// Block placer-N
#Pipes:gizmo[758]
	set TEMP {Z}
	setadd TEMP 1
	setblockid tempid {X} {Y} {TEMP}
	if tempid|=|0 placeblock 238 {X} {Y} {TEMP}
	if tempid|=|238 placeblock 0 {X} {Y} {TEMP}
quit

// Block placer-N
#Pipes:gizmo[759]
	set TEMP {Z}
	setsub TEMP 1
	setblockid tempid {X} {Y} {TEMP}
	if tempid|=|0 placeblock 238 {X} {Y} {TEMP}
	if tempid|=|238 placeblock 0 {X} {Y} {TEMP}
quit

// Block placer-E
#Pipes:gizmo[760]
	set TEMP {X}
	setsub TEMP 1
	setblockid tempid {TEMP} {Y} {Z}
	if tempid|=|0 placeblock 238 {TEMP} {Y} {Z}
	if tempid|=|238 placeblock 0 {TEMP} {Y} {Z}
quit

// Block placer-W
#Pipes:gizmo[761]
	set TEMP {X}
	setadd TEMP 1
	setblockid tempid {TEMP} {Y} {Z}
	if tempid|=|0 placeblock 238 {TEMP} {Y} {Z}
	if tempid|=|238 placeblock 0 {TEMP} {Y} {Z}
quit

// Block placer-U
#Pipes:gizmo[762]
	set TEMP {Y}
	setsub TEMP 1
	setblockid tempid {X} {TEMP} {Z}
	if tempid|=|0 placeblock 238 {X} {TEMP} {Z}
	if tempid|=|238 placeblock 0 {X} {TEMP} {Z}
quit

// Block placer-D
#Pipes:gizmo[763]
	set TEMP {Y}
	setadd TEMP 1
	setblockid tempid {X} {TEMP} {Z}
	if tempid|=|0 placeblock 238 {X} {TEMP} {Z}
	if tempid|=|238 placeblock 0 {X} {TEMP} {Z}
quit

// Passthrough
#Pipes:gizmo[756]
	set Pipes.line{Pipes.index}.ceased false
	set Pipes.gizmo{X},{Y},{Z}
	if dir|=|"X+" jump #Pipes:X+
	if dir|=|"X-" jump #Pipes:X-
	if dir|=|"Y+" jump #Pipes:Y+
	if dir|=|"Y-" jump #Pipes:Y-
	if dir|=|"Z+" jump #Pipes:Z+
	if dir|=|"Z-" jump #Pipes:Z-
quit

// Swapper-UD
#Pipes:gizmo[755]
	if dir|=|"Y+" quit
	if dir|=|"Y-" quit
	set TEMP1 {Y}
	setadd TEMP1 1
	setblockid tempid1 {X} {TEMP1} {Z}
	set TEMP2 {Y}
	setsub TEMP2 1
	setblockid tempid2 {X} {TEMP2} {Z}
	if tempid1|>|767 quit
	if tempid2|>|767 quit
	placeblock {tempid1} {X} {TEMP2} {Z}
	placeblock {tempid2} {X} {TEMP1} {Z}
quit

// Swapper-NS
#Pipes:gizmo[754]
	if dir|=|"Z+" quit
	if dir|=|"Z-" quit
	set TEMP1 {Z}
	setadd TEMP1 1
	setblockid tempid1 {X} {Y} {TEMP1}
	set TEMP2 {Z}
	setsub TEMP2 1
	setblockid tempid2 {X} {Y} {TEMP2}
	if tempid1|>|767 quit
	if tempid2|>|767 quit
	placeblock {tempid1} {X} {Y} {TEMP2}
	placeblock {tempid2} {X} {Y} {TEMP1}
quit

// Swapper-WE
#Pipes:gizmo[753]
	if dir|=|"X+" quit
	if dir|=|"X-" quit
	set TEMP1 {X}
	setadd TEMP1 1
	setblockid tempid1 {TEMP1} {Y} {Z}
	set TEMP2 {X}
	setsub TEMP2 1
	setblockid tempid2 {TEMP2} {Y} {Z}
	if tempid1|>|767 quit
	if tempid2|>|767 quit
	placeblock {tempid1} {TEMP2} {Y} {Z}
	placeblock {tempid2} {TEMP1} {Y} {Z}
quit