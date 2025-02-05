#onJoin
	if spawn jump #triedrunningonjoin
	set spawn 64 64 121
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

#triedrunningonjoin
	if triggeredend quit
	set triggeredend true
	msg &aWelcome to Walking Simulator!
	delay 3000
	msg &fAll you have to do to win is walk to the end of the hall.
	delay 3000
	msg &fHA! Had you for a second didn't I?
	delay 3000
	msg &fSorry, but no. Try again.
	delay 3000
	cmd goto hell
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
	if PlayerZ|<|4 jump #outofbounds
	if PlayerZ|>|6 jump #outofbounds
	if time|<|5 jump #tooquick
	if checkpoints|<|28 jump #notenoughcheckpoints
	if checkpoints|>|28 jump #toomanycheckpoints
	msg &aCongratulations!
	delay 3000
	msg &fThat took you {time} seconds.
	delay 3000
	msg &fThink you can do it any faster?
	delay 3000
	cmd main
quit

#outofbounds
	if PlayerCoords|=|spawn jump #literallyjustguessedandranwin
quit

#notenoughcheckpoints
	msg &fCongratulations!
	delay 3000
	msg &fThat took you {time} seconds.
	delay 3000
	msg &fThough, we both know you didn't actually walk that hallway.
	delay 3000
	msg &fNice try though.
	delay 3000
	cmd goto hell
quit

#toomanycheckpoints
	msg &f...
	delay 3000
	msg &fSomehow you managed to walk more hallway than exists in the world.
	delay 3000
	cmd goto hell
quit

#tooquick
	msg &fCongratulations!
	delay 3000
	msg &fYou fucking cheated!
	delay 3000
	msg &fI hope you feel good about yourself.
	delay 3000
	msg &fI mean come on, if you are going to cheat, get more creative than just teleporting.
	delay 3000
	cmd goto hell
quit

#literallyjustguessedandranwin
	msg &fNice try, but no.
	delay 3000
	msg &fYou cannot just run the #win label.
	delay 3000
	cmd goto hell
quit