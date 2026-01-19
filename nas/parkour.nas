using local_packages

#play
	cmd tp 4 3 44 180 0
	set Score 0
	set Alive true
	cpemsg bigannounce
	cpemsg smallannounce
	cpemsg top1 &eScore: &f{Score}
	boost 0 0 0 1 1 1
	allowmbrepeat
	tempchunk 4 2 43 4 2 45 4 2 43
quit

#died
	ifnot Alive quit
	set Alive false
	cpemsg bigannounce &cGame Over!
	cpemsg smallannounce &eScore: &f{Score}
	cpemsg top1
	cs me explosion2
quit

#checkjump
	#checkjumploop
		setsplit PlayerCoordsDecimal " "
		ifnot Alive quit
		ifnot PlayerCoordsDecimal[1]|=|3 jump #checkjumploop2
		delay 100
	jump #checkjumploop
	#checkjumploop2
		setsplit PlayerCoordsDecimal " "
		delay 100
		ifnot Alive quit
	ifnot PlayerCoordsDecimal[1]|=|3 jump #checkjumploop2
	msg {actionCount}
	msg {PlayerZ}
	if PlayerZ|<|46 quit
	cmd reltp 0 0 -4
	setadd Score 1
	cpemsg top1 &eScore: &f{Score}
	cs me ding:choose(4):cut(0.1) ding:choose(4):pitch(2)
	allowmbrepeat
	set l_modscore {Score}
	setmod l_modscore 10
	if l_modscore|=|0 cs me collect pizza
	if l_modscore|=|0 newthread #animtext|Score:_{Score}|u
	set l_modscore {Score}
	setmod l_modscore 50
	if l_modscore|=|0 cs me collect giant pizza
	if l_modscore|=|0 newthread #animtext|Score:_{Score}|6
	tempchunk 4 2 48 4 2 49 4 2 44
	delay 100
	tempblock 215 4 2 44
	delay 100
	tempblock 215 4 2 45
quit

#animtext
	cpemsg smallannounce &{runArg2}{runArg1}
	delay 100
	cpemsg smallannounce {runArg1}
	delay 100
	cpemsg smallannounce &{runArg2}{runArg1}
	delay 100
	cpemsg smallannounce {runArg1}
	delay 100
	cpemsg smallannounce &{runArg2}{runArg1}
	delay 100
	cpemsg smallannounce {runArg1}
	delay 100
	cpemsg smallannounce &{runArg2}{runArg1}
	delay 100
	cpemsg smallannounce {runArg1}
	delay 100
	cpemsg smallannounce &{runArg2}{runArg1}
	delay 100
	cpemsg smallannounce {runArg1}
quit