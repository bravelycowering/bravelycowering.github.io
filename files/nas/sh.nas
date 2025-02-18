#ominoustype
	set targetText {runArg1}
	set text 
	setsplit targetText
	set i 0
	#ominoustypeloop
		set text {text}{targetText[{i}]}
		set length {targetText.Length}
		cpemsg smallannounce &7{text}
		setadd i 1
		delay 150
	if i|<|length jump #ominoustypeloop
	delay 1500
	cpemsg smallannounce &g{text}
	delay 200
	cpemsg smallannounce &8{text}
	delay 200
	cpemsg smallannounce &0{text}
	delay 200
	cpemsg smallannounce
	delay 200
quit

#ominoustypecut
	set targetText {runArg1}
	set text 
	setsplit targetText
	set i 0
	#ominoustypecutloop
		set text {text}{targetText[{i}]}
		set length {targetText.Length}
		cpemsg smallannounce &7{text}
		setadd i 1
		delay 150
	if i|<|length jump #ominoustypecutloop
quit

#onJoin
	gui hotbar false
	gui hand false
	gui crosshair false
	delay 30000
	call #ominoustype|There is nothing for you here.
	call #ominoustype|No story... No world...
	call #ominoustype|Nothing made with you in mind.
	delay 120000
	call #ominoustype|You are quite patient.
	call #ominoustype|Waiting in a world that is not yours...
	call #ominoustype|Peculiar...
	call #ominoustypecut|Maybe we can reach an agre
	cmd tp 64 64 64 0 0
quit