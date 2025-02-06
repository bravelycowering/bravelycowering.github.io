include os/pipestone+
include os/backtick+21

// Pipes related
#run
jump #Pipes:messageblock

#Pipes:prerun[765]
	setsub Y 1
quit

#Pipes:prerun[735]
	ifnot key jump #nokeys
	jump #Pipes:prerun[757]
#Pipes:prerun[745]
	ifnot keycard jump #nokeycards
	tempblock 740 {X} {Y} {Z}
#Pipes:prerun[757]
	setsub X 1
quit

#Pipes:prerun[736]
	ifnot key jump #nokeys
	jump #Pipes:prerun[758]
#Pipes:prerun[746]
	ifnot keycard jump #nokeycards
	tempblock 741 {X} {Y} {Z}
#Pipes:prerun[758]
	setadd X 1
quit

#Pipes:prerun[737]
	ifnot key jump #nokeys
	jump #Pipes:prerun[759]
#Pipes:prerun[747]
	ifnot keycard jump #nokeycards
	tempblock 742 {X} {Y} {Z}
#Pipes:prerun[759]
	setadd Z 1
quit

#Pipes:prerun[738]
	ifnot key jump #nokeys
	jump #Pipes:prerun[760]
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

// Block placer-N
#Pipes:gizmo[727]
	setadd Z 1
	setblockid id {X} {Y} {Z}
	if id|=|0 jump #place
	if id|=|744 jump #unplace
quit

// Block placer-S
#Pipes:gizmo[726]
	setsub Z 1
	setblockid id {X} {Y} {Z}
	if id|=|0 jump #place
	if id|=|744 jump #unplace
quit

// Block placer-E
#Pipes:gizmo[725]
	setsub X 1
	setblockid id {X} {Y} {Z}
	if id|=|0 jump #place
	if id|=|744 jump #unplace
quit

// Block placer-W
#Pipes:gizmo[724]
	setadd X 1
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

// delay
#Pipes:gizmo[731]
	tempblock 730 {X} {Y} {Z}
	jump #Pipes:schedulebox|10
quit

#Pipes:box[731]
	tempblock 731 {X} {Y} {Z}
quit

// Passthrough
#Pipes:gizmo[739]
	set Pipes.line{Pipes.index}.ceased false
	set Pipes.gizmo{X},{Y},{Z}
	if dir|=|"X+" jump #Pipes:X+
	if dir|=|"X-" jump #Pipes:X-
	if dir|=|"Y+" jump #Pipes:Y+
	if dir|=|"Y-" jump #Pipes:Y-
	if dir|=|"Z+" jump #Pipes:Z+
	if dir|=|"Z-" jump #Pipes:Z-
quit

// hax with vision
#hax
	ifnot canhax cmd goto hell
	if hax set hax false
	else set hax true
	else cmd maphack off
	else cmd maphack
	else env maxfog 20
	else env maxfog 0
	else env sun 775533
	else env sun fff
	else env shadow 292929
	else env shadow fff
quit

#uselesschest
	if state{MBX},{MBY},{MBZ} quit
	set state{MBX},{MBY},{MBZ} true
	tempblock 624 {MBCoords}
	msg There's nothing of use inside.
quit

#usefulchest1
	if keycard quit
	set keycard true
	tempblock 624 {MBCoords}
	msg You found the &6ID CARD
	cpemsg bot2 &6ID CARD
quit

#foundkey
	if key quit
	set key true
	tempblock 0 {MBCoords}
	msg You found the &6KEY
	cpemsg bot3 &6KEY
quit

// util
#looptp
	set lockname tplockX
	if runArg1|=|0 set lockname tplockZ
	if {lockname} quit
	set {lockname} true
	cmd reltp {runArg1} 0 {runArg2}
	allowmbrepeat
	delay 100
	set {lockname} false
quit

// plot
#onJoin
	cpemsg bot1 POCKETS: &u$0
	cpemsg bot2 &gNOTHING
	cpemsg bot3 &gNOTHING
	set plot 0
	setrandrange safecode 111111 999999
	motd -hax -push model=humanoid horspeed=1 maxspeed=1.5
	env fog 775533
	set canhax false
	set PlayerName @p
	if PlayerName|=|"bravelycowering+" set canhax true
	if PlayerName|=|"backtick+" set canhax true
quit

#1
	set onit true
	if PlayerX|>|264 set onit false
	if PlayerX|<|262 set onit false
	if PlayerZ|>|233 set onit false
	if PlayerZ|<|231 set onit false
	if plot|>=|1 quit
	set plot 1
	msg You hear a rumble...
	freeze
	delay 2000
	tempchunk 262 190 231 264 193 233 262 191 231
	if onit cmd reltp 0 1 0
	delay 300
	tempchunk 262 190 231 264 193 233 262 192 231
	if onit cmd reltp 0 1 0
	else unfreeze
	delay 300
	tempchunk 262 190 231 264 193 233 262 193 231
	if onit cmd reltp 0 1 0
	delay 300
	tempchunk 262 190 231 264 193 233 262 194 231
	if onit cmd reltp 0 1 0
	if onit unfreeze
quit

#treesecret
	if foundtreesecret quit
	set foundtreesecret true
	msg * You pressed the switch...
	delay 3000
	msg * Click!
	delay 1000
	msg * Nothing happened.
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
	msg *CRUNCH*
	delay 1000
	msg You can't feel your legs...
	delay 3000
	unfreeze
	motd -hax -push model=humanoid
	delay 1200
	tempblock 763 263 73 232
	delay 300
	tempblock 762 263 73 232
	delay 50
	tempblock 763 263 73 232
quit