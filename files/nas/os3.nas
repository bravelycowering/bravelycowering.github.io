// Pipes related
include os/pipestone+

#run
jump #Pipes:messageblock

#Pipes:prerun[765]
	setsub Y 1
quit
#Pipes:prerun[745]
	ifnot keycard jump #nokeycards
	tempblock 740 {X} {Y} {Z}
#Pipes:prerun[757]
	setsub X 1
quit
#Pipes:prerun[746]
	ifnot keycard jump #nokeycards
	tempblock 741 {X} {Y} {Z}
#Pipes:prerun[758]
	setadd X 1
quit
#Pipes:prerun[747]
	ifnot keycard jump #nokeycards
	tempblock 742 {X} {Y} {Z}
#Pipes:prerun[759]
	setadd Z 1
quit
#Pipes:prerun[748]
	ifnot keycard jump #nokeycards
	tempblock 743 {X} {Y} {Z}
#Pipes:prerun[760]
	setsub Z 1
quit

#nokeycards
	msg Seems like a scanner of some kind...
	msg You will need an &6ID CARD&7 to get past this.
quit

#nokeys
	msg Seems like a lock of some kind...
	msg You will need a &6KEY&7 to unlock this.
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
	if state{X},{Y},{Z} set state{X},{Y},{Z} false
	else set state{X},{Y},{Z} true
	else jump #closer
	else jump #opener
quit

#opener
	setadd X 1
	setblockid id {X} {Y} {Z}
	if id|=|595 jump #opendoor|X|1
	setsub X 2
	setblockid id {X} {Y} {Z}
	if id|=|595 jump #opendoor|X|-1
	setadd X 1
	setadd Z 1
	setblockid id {X} {Y} {Z}
	if id|=|595 jump #opendoor|Z|1
	setsub Z 2
	setblockid id {X} {Y} {Z}
	if id|=|595 jump #opendoor|Z|-1
quit
#closer
	setadd X 1
	setblockid id {X} {Y} {Z}
	if id|=|595 jump #closedoor|X|1
	setsub X 2
	setblockid id {X} {Y} {Z}
	if id|=|595 jump #closedoor|X|-1
	setadd X 1
	setadd Z 1
	setblockid id {X} {Y} {Z}
	if id|=|595 jump #closedoor|Z|1
	setsub Z 2
	setblockid id {X} {Y} {Z}
	if id|=|595 jump #closedoor|Z|-1
quit

#opendoor
// direction, velocity
	setsub Y 1
	setblockid id {X} {Y} {Z}
	if id|=|595 jump #opendoor
	setadd Y 1
	set start {{runArg1}}
	jump #opendoorloop
	#resetopendoorloop
		set {runArg1} {start}
		setadd Y 1
		setblockid id {X} {Y} {Z}
		ifnot id|=|595 quit
		delay 150
	#opendoorloop
		setblockid id {X} {Y} {Z}
		if id|=|595 tempblock 0 {X} {Y} {Z}
		else jump #resetopendoorloop
		setadd {runArg1} {runArg2}
	jump #opendoorloop
quit

#closedoor
// direction, velocity
	setadd Y 1
	setblockid id {X} {Y} {Z}
	if id|=|595 jump #closedoor
	setsub Y 1
	set start {{runArg1}}
	jump #closedoorloop
	#resetclosedoorloop
		set {runArg1} {start}
		setsub Y 1
		setblockid id {X} {Y} {Z}
		ifnot id|=|595 quit
		delay 150
	#closedoorloop
		setblockid id {X} {Y} {Z}
		if id|=|595 tempblock 595 {X} {Y} {Z}
		else jump #resetclosedoorloop
		setadd {runArg1} {runArg2}
	jump #closedoorloop
quit

#Pipes:gizmo[0]
	if rivitediron{X},{Y},{Z} jump #Pipes:softbox
quit

#Pipes:gizmo[744]
	ifnot state{X},{Y},{Z} jump #Pipes:softbox
quit

// Block placer-D
#Pipes:gizmo[749]
	setadd Y 1
	setblockid id {X} {Y} {Z}
	if id|=|0 jump #place
	if id|=|744 jump #unplace
quit
#place
	if rivitediron{X},{Y},{Z} set rivitediron{X},{Y},{Z} false
	else set rivitediron{X},{Y},{Z} true
	else tempblock 0 {X} {Y} {Z}
	else tempblock 238 {X} {Y} {Z}
quit
#unplace
	if state{X},{Y},{Z} set state{X},{Y},{Z} false
	else set state{X},{Y},{Z} true
	else tempblock 744 {X} {Y} {Z}
	else tempblock 0 {X} {Y} {Z}
quit

// hax with vision
#hax
	motd +hax
	env maxfog 0
quit

#uselesschest
	if state{MBX},{MBY},{MBZ} quit
	set state{MBX},{MBY},{MBZ} true
	tempblock 624 {MBCoords}
	msg There's nothing of use inside.
quit

#usefulchest1
	if state{MBX},{MBY},{MBZ} quit
	set state{MBX},{MBY},{MBZ} true
	set keycard true
	tempblock 624 {MBCoords}
	msg You found the &6ID CARD
	cpemsg bot1 ITEMS:
	cpemsg bot2 &6ID CARD
quit

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