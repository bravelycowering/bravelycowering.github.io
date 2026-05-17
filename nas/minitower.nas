include os/shinyiris+towerlib

#onJoin
	set ctohlib.is.in.parkour true
	set ctohlib.DEFAULT.MOTD -hax -push -slap model=humanoid|0.5 jumpheight=0.6
	msg &fwelcome to probably the most annoying map you will play today
	msg You can enable practice mode by pressing &aP&7 (or by typing &a/in practice&7)
	definehotkey practice|P
quit

#input
	if runArg1|=|"practice" jump #CTOHLib_TogglePracticeMode
quit

#win
	if ctohlib.is.in.practice.mode jump #winPractice
quit

#winPractice

quit
