#onJoin
	set starttime {epochMS}
	msg &aWelcome to Walking Simulator!
	delay 3000
	msg &fAll you have to do to win is walk to the end of the hall.
	delay 3000
	msg &fYour time started when you joined the map.
quit

#finish
	set time {epochMS}
	setsub time {starttime}
	setdiv time 1000
	msg &aCongratulations! You win!
	delay 3000
	msg &fThat took you {time} seconds.
	delay 3000
	msg &fThink you can do it any faster?
quit