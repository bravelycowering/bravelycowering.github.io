// Pipes
include os/pipestone+

// Print version number
#onJoin
msg &6Cheesestone
	// The block ID to use for UD pipes
	set Pipes.id.pipe-UD 764
	// The block ID to use for WE pipes
	set Pipes.id.pipe-WE 765
	// The block ID to use for NS pipes
	set Pipes.id.pipe-NS 766
	// The block ID to use for Boxes
	set Pipes.id.box 767
	// The block ID to use for the start of the list of delays
	set Pipes.id.delay 748
jump #Pipes:version

// Prevent every map ever from breaking
#run
jump #Pipes:messageblock

// White
#Pipes:prerun[36]
	if id|=|36 msg &cWhite cannot be used as an activator
	if id|=|36 jump #Pipes:terminate
quit

// Pressure plate
#Pipes:prerun[763]
	setsub Y 1
quit

// Lamp Off
#Pipes:gizmo[761]
	placeblock 762 {X} {Y} {Z}
quit

// Lamp
#Pipes:gizmo[762]
	placeblock 761 {X} {Y} {Z}
quit

// White
#Pipes:gizmo[36]
	cmd m {X} {Y} {Z}
quit

// Cactus
#Pipes:gizmo[106]
	if id|>|767 quit
	setadd Y 1
	setblockid id {X} {Y} {Z}
	ifnot id|=|0 jump #Pipes:gizmo[106]
	placeblock 106 {X} {Y} {Z}
quit

// Spitter-N
#Pipes:gizmo[760]
	if id|>|767 quit
	setadd Z 1
	setblockid id {X} {Y} {Z}
	ifnot id|=|0 jump #Pipes:gizmo[760]
	placeblock 9 {X} {Y} {Z}
quit

// Spitter-S
#Pipes:gizmo[759]
	if id|>|767 quit
	setsub Z 1
	setblockid id {X} {Y} {Z}
	ifnot id|=|0 jump #Pipes:gizmo[759]
	placeblock 9 {X} {Y} {Z}
quit

// Block placer-E
#Pipes:gizmo[757]
	if id|>|767 quit
	setsub X 1
	setblockid id {X} {Y} {Z}
	ifnot id|=|0 jump #Pipes:gizmo[757]
	placeblock 9 {X} {Y} {Z}
quit

// Block placer-W
#Pipes:gizmo[758]
	if id|>|767 quit
	setadd X 1
	setblockid id {X} {Y} {Z}
	ifnot id|=|0 jump #Pipes:gizmo[758]
	placeblock 9 {X} {Y} {Z}
quit

// wet detector
#Pipes:gizmo[754]
	set wet false
	setadd X 1
	setblockid id {X} {Y} {Z}
	if id|=|9 set wet true
	setsub X 2
	setblockid id {X} {Y} {Z}
	if id|=|9 set wet true
	setadd X 1
	setadd Z 1
	setblockid id {X} {Y} {Z}
	if id|=|9 set wet true
	setsub Z 2
	setblockid id {X} {Y} {Z}
	if id|=|9 set wet true
	setadd Z 1
	setadd Y 1
	setblockid id {X} {Y} {Z}
	if id|=|9 set wet true
	setsub Y 2
	setblockid id {X} {Y} {Z}
	if id|=|9 set wet true
	setadd Y 1
	if wet jump #Pipes:softbox
quit

// wet detector prickly
#Pipes:gizmo[753]
	set wet false
	setadd X 1
	setblockid id {X} {Y} {Z}
	if id|=|106 set wet true
	setsub X 2
	setblockid id {X} {Y} {Z}
	if id|=|106 set wet true
	setadd X 1
	setadd Z 1
	setblockid id {X} {Y} {Z}
	if id|=|106 set wet true
	setsub Z 2
	setblockid id {X} {Y} {Z}
	if id|=|106 set wet true
	setadd Z 1
	setadd Y 1
	setblockid id {X} {Y} {Z}
	if id|=|106 set wet true
	setsub Y 2
	setblockid id {X} {Y} {Z}
	if id|=|106 set wet true
	setadd Y 1
	if wet jump #Pipes:softbox
quit

#Pipes:gizmo[756]
	msg kaboom or something
quit

#Pipes:gizmo[747]
	setadd X 1
	setblockid id {X} {Y} {Z}
	if id|=|9 placeblock 0 {X} {Y} {Z}
	setsub X 2
	setblockid id {X} {Y} {Z}
	if id|=|9 placeblock 0 {X} {Y} {Z}
	setadd X 1
	setadd Z 1
	setblockid id {X} {Y} {Z}
	if id|=|9 placeblock 0 {X} {Y} {Z}
	setsub Z 2
	setblockid id {X} {Y} {Z}
	if id|=|9 placeblock 0 {X} {Y} {Z}
	setadd Z 1
	setadd Y 1
	setblockid id {X} {Y} {Z}
	if id|=|9 placeblock 0 {X} {Y} {Z}
	setsub Y 2
	setblockid id {X} {Y} {Z}
	if id|=|9 placeblock 0 {X} {Y} {Z}
	setadd Y 1
quit

#Pipes:gizmo[746]
	if dir|=|X+ quit
	if dir|=|X- quit
	if dir|=|Z+ quit
	if dir|=|Z- quit
	setadd Z 1
	setblockid id1 {X} {Y} {Z}
	setsub Z 1
	setsub X 1
	setblockid id2 {X} {Y} {Z}
	placeblock {id1} {X} {Y} {Z}
	setadd X 1
	setsub Z 1
	setblockid id3 {X} {Y} {Z}
	placeblock {id2} {X} {Y} {Z}
	setadd X 1
	setadd Z 1
	setblockid id4 {X} {Y} {Z}
	placeblock {id3} {X} {Y} {Z}
	setsub X 1
	setadd Z 1
	placeblock {id4} {X} {Y} {Z}
quit

// Passthrough
#Pipes:gizmo[755]
	set Pipes.line{Pipes.index}.ceased false
	set Pipes.gizmo{X},{Y},{Z}
	if dir|=|"X+" jump #Pipes:X+
	if dir|=|"X-" jump #Pipes:X-
	if dir|=|"Y+" jump #Pipes:Y+
	if dir|=|"Y-" jump #Pipes:Y-
	if dir|=|"Z+" jump #Pipes:Z+
	if dir|=|"Z-" jump #Pipes:Z-
quit