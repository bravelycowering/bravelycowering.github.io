// Pipes related
include os/pipestone+

#run
jump #Pipes:messageblock

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