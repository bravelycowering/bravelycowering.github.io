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

#didjump
	cmd reltp 0 0 -4
	setadd Score 1
	cpemsg top1 &eScore: &f{Score}
	set l_modscore {Score}
	setmod l_modscore 10
	allowmbrepeat
	if l_modscore|=|0 jump #animtext|Score:_{Score}
	tempchunk 4 2 48 4 2 49 4 2 44
	delay 100
	tempblock 215 4 2 44
	delay 100
	tempblock 215 4 2 45
	cs me ding:choose(4):cut(0.1) ding:choose(4):pitch(2)
quit

#animtext
	set l_text {runArg1}
	cpemsg smallannounce {l_text}
	tempchunk 4 2 48 4 2 49 4 2 44
	delay 100
	tempblock 215 4 2 44
	delay 100
	tempblock 215 4 2 45
	cs me collect pizza
quit