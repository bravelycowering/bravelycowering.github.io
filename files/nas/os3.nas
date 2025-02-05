// Pipes related
include os/pipestone+

#run
jump #Pipes:messageblock

#Pipes:prerun[765]
	setsub Y 1
quit
#Pipes:prerun[757]
	setsub X 1
quit
#Pipes:prerun[758]
	setadd X 1
quit
#Pipes:prerun[759]
	setadd Z 1
quit
#Pipes:prerun[760]
	setsub Z 1
quit

// lamp off
#Pipes:gizmo[762]
	if state{X},{Y},{Z} set state{X},{Y},{Z} false
	else set state{X},{Y},{Z} true
	else tempblock 762 {X} {Y} {Z}
	else tempblock 763 {X} {Y} {Z}
quit

// lamp on
#Pipes:gizmo[763]
	if state{X},{Y},{Z} set state{X},{Y},{Z} false
	else set state{X},{Y},{Z} true
	else tempblock 763 {X} {Y} {Z}
	else tempblock 762 {X} {Y} {Z}
quit

// door
#Pipes:gizmo[756]
	setadd X 1
	setblockid id {X} {Y} {Z}
	if id|=|595 jump #dodoor|X|1
	setsub X 2
	setblockid id {X} {Y} {Z}
	if id|=|595 jump #dodoor|X|-1
	setadd X 1
	setadd Z 1
	setblockid id {X} {Y} {Z}
	if id|=|595 jump #dodoor|Z|1
	setsub Z 2
	setblockid id {X} {Y} {Z}
	if id|=|595 jump #dodoor|Z|-1
quit

#dodoor
// direction, velocity
	setsub Y 1
	setblockid id {X} {Y} {Z}
	if id|=|595 jump #dodoor
	setadd Y 1
	set start {{runArg1}}
	jump #doorloop
	#resetdoorloop
		set {runArg1} {start}
		setadd Y 1
		setblockid id {X} {Y} {Z}
		ifnot id|=|595 quit
		delay 150
	#doorloop
		setblockid id {X} {Y} {Z}
		if id|=|595 tempblock 0 {X} {Y} {Z}
		else jump #resetdoorloop
		setadd {runArg1} {runArg2}
	jump #doorloop
quit

#Pipes:gizmo[0]
	if rivitediron{X},{Y},{Z} jump #Pipes:softbox
quit

// Block placer-D
#Pipes:gizmo[749]
	setadd Y 1
	setblockid id {X} {Y} {Z}
	if id|=|0 jump #place
quit
#place
	if rivitediron{X},{Y},{Z} set rivitediron{X},{Y},{Z} false
	else set rivitediron{X},{Y},{Z} true
	else tempblock 0 {X} {Y} {Z}
	else tempblock 238 {X} {Y} {Z}
quit

// hax with vision
#hax
	motd +hax
	env maxfog 0
quit

// code related
include os/backtick+21

#save
msg &fYour save code is:
msg &a
msg &fCopy it somewhere you will remember it!

// plot
#onJoin
	set plot 0
	env fog 775533
quit

#1
	if PlayerX|>|264 quit
	if PlayerX|<|262 quit
	if PlayerZ|>|238 quit
	if PlayerZ|<|236 quit
	if plot|>=|1 quit
	set plot 1
	msg You hear a rumble...
	freeze
	delay 2000
	tempchunk 262 190 231 264 193 233 262 191 231
	delay 300
	tempchunk 262 190 231 264 193 233 262 192 231
	unfreeze
	delay 300
	tempchunk 262 190 231 264 193 233 262 193 231
	delay 300
	tempchunk 262 190 231 264 193 233 262 194 231
quit

#freeze
	freeze
	boost 0 0 0 1 0 1
quit

#unfreeze
	unfreeze
quit

#breakfloor
	set Y {MBY}
	setsub Y 1
	tempblock 0 {MBX} {Y} {MBZ}
quit

#2
	if plot|>=|2 quit
	set plot 2
	env fog 000
	unfreeze
	delay 1200
	tempblock 763 263 73 232
	delay 300
	tempblock 762 263 73 232
	delay 50
	tempblock 763 263 73 232
quit