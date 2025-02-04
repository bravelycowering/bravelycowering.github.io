// Pipes related
include os/pipestone+

#run
jump #Pipes:messageblock

// hax with vision
#hax
	motd +hax
	env maxfog 0
quit

// plot
#onJoin
	set plot 0
quit

#1
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