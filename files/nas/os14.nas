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
	set min {MBZ}
	setsub min 1
	set max {MBZ}
	setadd max 1
	if PlayerZ|<|{min} set cheatedcheckpoints true
	if PlayerZ|>|{max} set cheatedcheckpoints true
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
	if checkpoints|=|0 jump #teleported
	if time|<|5 jump #tooquick
	if checkpoints|<|8 jump #notenoughcheckpoints
	if checkpoints|>|8 jump #toomanycheckpoints
	if cheatedcheckpoints jump #cheatedcheckpoints
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
	msg &fLook, I don't know where you are but you sure as hell aren't at the finish.
	delay 3000
	msg &fRemind me to finish this one, otherwise I will forget.
	delay 3000
	cmd goto hell
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

#cheatedcheckpoints
	msg &fClever... You saw my checkpoint system.
	delay 3000
	msg &fSorry to burst your bubble but you can't just mark them.
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
	msg &fWow, that was fast.
	delay 3000
	msg &fWhat did you enable speed hacks or something?
	delay 3000
	msg &fWell we both know you didn't do that legitimately. So...
	delay 3000
	cmd goto hell
quit

#teleported
	msg &fCongratulations!
	delay 3000
	msg &fYou fucking cheated!
	delay 3000
	msg &fI mean come on, if you are going to cheat, get more creative than just teleporting!
	delay 3000
	msg &fGo to hell
	delay 1000
	cmd goto hell
quit

#literallyjustguessedandranwin
	msg &fNice try, but no.
	delay 3000
	msg &fYou cannot just run the #win label.
	delay 3000
	cmd goto hell
quit