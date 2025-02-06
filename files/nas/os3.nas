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

#extremelyuselesschest
	if replying quit
	if state{MBX},{MBY},{MBZ} quit
	set state{MBX},{MBY},{MBZ} true
	setadd extremelyuselesschestsopened 1
	if extremelyuselesschestsopened|<|10 tempblock 624 {MBCoords}
	jump #extremelyuselessmsg{extremelyuselesschestsopened}
quit

#extremelyuselessmsg1
	msg There's nothing of use inside.
quit

#extremelyuselessmsg2
	msg You look inside, it's empty.
quit

#extremelyuselessmsg3
	msg Looking inside, you discover a distinct lack of anything useful.
quit

#extremelyuselessmsg4
	msg Incredibly, the chest is empty.
quit

#extremelyuselessmsg5
	freeze
	msg You look inside, it's-
	delay 1000
	msg Wait! What's that???
	delay 2000
	msg Amazing...
	delay 3000
	msg It's an empty chest.
	unfreeze
quit

#extremelyuselessmsg6
	freeze
	msg There's nothing in this one either.
	delay 3000
	msg Actually, it couldn't be emptier. There's not even a speck of dust in here.
	unfreeze
quit

#extremelyuselessmsg7
	freeze
	msg You got the &6CHEST LID&7.
	delay 2000
	msg You try putting it in your pockets, but it doesn't fit.
	unfreeze
quit

#extremelyuselessmsg8
	freeze
	msg This is the 8th chest in this room that you've opened.
	delay 3000
	msg This room is kind of baffling when you think about it.
	delay 3000
	msg Why would anyone in their right mind create this room...
	delay 3000
	msg Guard it behind needing special clearance via the &6ID CARD&7...
	delay 3000
	msg Just to fill it with nothing?
	delay 3000
	msg This must be some kind of inside joke between whoever worked here.
	delay 5000
	msg Oh right. That chest was empty by the way.
	unfreeze
quit

#extremelyuselessmsg9
	freeze
	msg There's nothing of use inside.
	delay 3000
	msg Hey, clearly this whole room is scripted.
	delay 3000
	msg Each time you open one of these chests the cutscene gets longer, and you still haven't found anything.
	delay 5000
	msg I mean come on, do you really think anything is going to be in that last chest?
	delay 2000
	set replying true
	reply 2|Yes|#extremelyuselessmsgYes
	reply 3|No|#extremelyuselessmsgNo
quit

#extremelyuselessmsgYes
	msg At least you are optimistic about it.
	delay 3000
	msg Given how long this is taking I would've thrown in the towel by now.
	delay 3000
	msg The world needs more people like you.
	delay 3000
	msg Well, don't let me stop you. Go ahead and open that last chest.
	unfreeze
	set replying false
quit

#extremelyuselessmsgNo
	msg Then don't waste your time here anymore.
	delay 3000
	msg Go ahead and walk back out that other door, I won't judge you if you leave one chest unopened.
	delay 5000
	msg Though, you never know. What if I put something in that last chest just to reward anyone.
	delay 3000
	msg I probably didn't do that though.
	unfreeze
	set replying false
quit

#extremelyuselessmsg10
	freeze
	msg Hey, since this is the last chest in the room, why don't we celebrate before you open it.
	delay 5000
	msg &cC&oO&6N&eG&aR&bA&rT&3U&9L&iA&]T&5I&dO&pN&mS&c!
	delay 2000
	msg I know that it took a lot to get to this point.
	delay 3000
	msg That's 10 whole chests worth of nothing you had to push yourself to open.
	delay 4000
	msg Well, the anticipation is killing me. Let's see what is inside!
	delay 3000
	tempblock 624 {MBCoords}
	delay 5000
	msg What's this?
	delay 2000
	msg Oh my goodness.
	delay 3000
	msg {uselessmsg4}
	setadd dollars 1
	cpemsg bot1 POCKETS: &u${dollars}
	delay 3000
	msg At least all that effort was worth it.
	unfreeze
quit

#uselesschest
	if state{MBX},{MBY},{MBZ} quit
	set state{MBX},{MBY},{MBZ} true
	tempblock 624 {MBCoords}
	setrandrange i 1 4
	msg {uselessmsg{i}}
	if i|<|4 quit
	setadd dollars 1
	cpemsg bot1 POCKETS: &u${dollars}
quit

#usefulchest1
	if keycard quit
	set keycard true
	tempblock 624 {MBCoords}
	msg You found the &6ID CARD&7 and put it in your pockets.
	cpemsg bot2 &6ID CARD
quit

#foundkey
	if key quit
	set key true
	tempblock 0 {MBCoords}
	msg You found the &6KEY&7 and put it in your pockets.
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
	set dollars 0
	setrandrange safecode 111111 999999
	motd -hax -push model=humanoid horspeed=1 maxspeed=1.5
	env fog 775533
	set canhax false
	set PlayerName @p
	if PlayerName|=|"bravelycowering+" set canhax true
	if PlayerName|=|"backtick+" set canhax true
	// useless chest messages
	set uselessmsg1 There's nothing of use inside.
	set uselessmsg2 You look inside, it's empty.
	set uselessmsg3 Looking inside, you discover a distinct lack of anything useful.
	set uselessmsg4 You found &u$1&7! You put it safely in your pockets.
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