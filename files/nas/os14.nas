#onJoin
	set starttime {epochMS}
	delay 500
	if triggeredend quit
	msg &aWelcome to Walking Simulator!
	delay 3000
	if triggeredend quit
	msg &fAll you have to do to win is walk to the end of the hall.
	delay 3000
	if triggeredend quit
	msg &fYour time started when you joined the map.
quit

#checkpoint
	allowmbrepeat
	if checkpoint{MBZ} quit
	set checkpoint{MBZ} true
	setadd checkpoints 1
quit

#win
	if triggeredend quit
	set triggeredend true
	set time {epochMS}
	setsub time {starttime}
	setdiv time 1000
	if PlayerX|<|63 jump #outofbounds
	if PlayerX|>|65 jump #outofbounds
	if PlayerZ|<|63 jump #outofbounds
	if PlayerZ|>|65 jump #outofbounds
	if time|<|5 jump #tooquick
	if checkpoints|<|28 jump #notenoughcheckpoints
	msg &aCongratulations!
	delay 3000
	msg &fThat took you {time} seconds.
	delay 3000
	msg &fThink you can do it any faster?
quit

#outofbounds
	if PlayerCoords|=|"64 64 121" jump #literallyjustguessedandranwin
quit

#notenoughcheckpoints
	msg &fCongratulations!
	delay 3000
	msg &fThat took you {time} seconds.
	delay 3000
	msg &fThough, we both know you didn't actually walk that hallway.
	delay 3000
	msg &fNice try though.
quit

#tooquick
	msg &fCongratulations!
	delay 3000
	msg &fYou fucking cheated!
	delay 3000
	msg &fI hope you feel good about yourself.
	delay 3000
	msg &fI mean come on, if you are going to cheat, get more creative than just teleporting.
quit

#literallyjustguessedandranwin
	msg &fNice try, but no.
	delay 3000
	msg &fYou cannot just run the #win label.
quit