// Pipestone
include os/bravelycowering+

// Print version number
#onJoin
	call #Pipes:version
	msg &fRunning locally...
quit

// Prevent every map ever from breaking
#run
jump #Pipes:messageblock

#setblock
// id x y z
	tempblock {runArg1} {runArg2} {runArg3} {runArg4}
	set tempblock{runArg2},{runArg3},{runArg4} {runArg1}
quit
#getblock
// x y z
	set id tempblock{runArg1},{runArg2},{runArg3}
	if id|=|"" setblockid id {runArg1} {runArg2} {runArg3}
quit

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

// Lamp
#Pipes:gizmo[62]
#Pipes:gizmo[764]
	call #getblock|{X}|{Y}|{Z}
	if id|=|62 call #setblock|764|{X}|{Y}|{Z}
	if id|=|764 call #setblock|62|{X}|{Y}|{Z}
quit

// Light
#Pipes:gizmo[215]
#Pipes:gizmo[765]
	call #getblock|{X}|{Y}|{Z}
	if id|=|215 call #setblock|765|{X}|{Y}|{Z}
	if id|=|765 call #setblock|215|{X}|{Y}|{Z}
quit

// Message blocks
#Pipes:gizmo[36]
#Pipes:gizmo[171]
	cmd m {X} {Y} {Z}
quit

// Block placer-N
#Pipes:gizmo[758]
	set TEMP {Z}
	setadd TEMP 1
	call #getblock|{X}|{Y}|{TEMP}
	if id|=|0 call #setblock|238|{X}|{Y}|{TEMP}
	if id|=|238 call #setblock|0|{X}|{Y}|{TEMP}
quit

// Block placer-N
#Pipes:gizmo[759]
	set TEMP {Z}
	setsub TEMP 1
	call #getblock|{X}|{Y}|{TEMP}
	if id|=|0 call #setblock|238|{X}|{Y}|{TEMP}
	if id|=|238 call #setblock|0|{X}|{Y}|{TEMP}
quit

// Block placer-E
#Pipes:gizmo[760]
	set TEMP {X}
	setsub TEMP 1
	call #getblock|{TEMP}|{Y}|{Z}
	if id|=|0 call #setblock|238|{TEMP}|{Y}|{Z}
	if id|=|238 call #setblock|0|{TEMP}|{Y}|{Z}
quit

// Block placer-W
#Pipes:gizmo[761]
	set TEMP {X}
	setadd TEMP 1
	call #getblock|{TEMP}|{Y}|{Z}
	if id|=|0 call #setblock|238|{TEMP}|{Y}|{Z}
	if id|=|238 call #setblock|0|{TEMP}|{Y}|{Z}
quit

// Block placer-U
#Pipes:gizmo[762]
	set TEMP {Y}
	setsub TEMP 1
	call #getblock|{X}|{TEMP}|{Z}
	if id|=|0 call #setblock|238|{X}|{TEMP}|{Z}
	if id|=|238 call #setblock|0|{X}|{TEMP}|{Z}
quit

// Block placer-D
#Pipes:gizmo[763]
	set TEMP {Y}
	setadd TEMP 1
	call #getblock|{X}|{TEMP}|{Z}
	if id|=|0 call #setblock|238|{X}|{TEMP}|{Z}
	if id|=|238 call #setblock|0|{X}|{TEMP}|{Z}
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
	call #getblock|{X}|{TEMP1}|{Z}
	set tempid {id}
	set TEMP2 {Y}
	setsub TEMP2 1
	call #getblock|{X}|{TEMP2}|{Z}
	if tempid|>|767 quit
	if id|>|767 quit
	call #setblock|{tempid}|{X}|{TEMP2}|{Z}
	call #setblock|{id}|{X}|{TEMP1}|{Z}
quit

// Swapper-NS
#Pipes:gizmo[754]
	if dir|=|"Z+" quit
	if dir|=|"Z-" quit
	set TEMP1 {Z}
	setadd TEMP1 1
	call #getblock|{X}|{Y}|{TEMP1}
	set tempid {id}
	set TEMP2 {Z}
	setsub TEMP2 1
	call #getblock|{X}|{Y}|{TEMP2}
	if tempid|>|767 quit
	if id|>|767 quit
	call #setblock|{tempid}|{X}|{Y}|{TEMP2}
	call #setblock|{id}|{X}|{Y}|{TEMP1}
quit

// Swapper-WE
#Pipes:gizmo[753]
	if dir|=|"X+" quit
	if dir|=|"X-" quit
	set TEMP1 {X}
	setadd TEMP1 1
	call #getblock|{TEMP1}|{Y}|{Z}
	set tempid {id}
	set TEMP2 {X}
	setsub TEMP2 1
	call #getblock|{TEMP2}|{Y}|{Z}
	if tempid|>|767 quit
	if id|>|767 quit
	call #setblock|{tempid}|{TEMP2}|{Y}|{Z}
	call #setblock|{id}|{TEMP1}|{Y}|{Z}
quit