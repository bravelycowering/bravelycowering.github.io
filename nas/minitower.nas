include os/shinyiris+towerlib

#onJoin
	set ctohlib.is.in.parkour true
	set ctohlib.DEFAULT.MOTD -hax -push -slap model=humanoid|0.5 jumpheight=0.6
	msg &fWelcome to probably the most annoying map you will play today
	msg You can enable setting checkpoints by pressing &aP&7 (or by typing &a/in practice&7)
	definehotkey practice|P
	definehotkey reset|R
	jump #resetTime
quit

#reset
	kill
#resetTime
	set start {epochMS}
quit

#input
	if runArg1|=|"practice" jump #CTOHLib_TogglePracticeMode
	if ctohlib.is.in.practice.mode quit
	if runArg1|=|"reset" jump #reset
quit

#CTOHLib_Trigger_PracticeModeOn
	msg &7Practice mode &aENABLED
quit

#CTOHLib_Trigger_PracticeModeOff
	msg &7Practice mode &cDISABLED
quit

#parseTime
	setdiv {runArg1} 1000
quit

#win
	if ctohlib.is.in.practice.mode jump #winPractice
	set final {epochMS}
	setsub final {start}
	call #parseTime|final
	msg &aCongrats on making it to the top!
	msg &fYou had a time of &6{final}s&f.
quit

#winPractice
	msg Congrats on making it to the top!
	msg &bNow complete it without any checkpoints.
	jump #CTOHLib_TogglePracticeMode
quit
