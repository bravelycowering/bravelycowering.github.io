include os/shinyiris+towerlib

#onJoin
	set ctohlib.is.in.parkour true
	setblockmessage data 0 1 0
	setsplit data ||
	set i 0
	#readDataLoop
		set {data[i]}
		setadd i 1
	if i|<|data.Length
	msg {msg}
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

msg welcome to probably the most annoying map you will play today||ctohlib.DEFAULT.MOTD -hax -push -slap model=humanoid|0.5 jumpheight=0.6
