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
	call #numberblocks
quit

#numberblocks
	set Digit->Block[0] 484
	set Block->Digit[484] 0
	set Digit->Block[1] 485
	set Block->Digit[485] 1
	set Digit->Block[2] 486
	set Block->Digit[486] 2
	set Digit->Block[3] 487
	set Block->Digit[487] 3
	set Digit->Block[4] 488
	set Block->Digit[488] 4
	set Digit->Block[5] 489
	set Block->Digit[489] 5
	set Digit->Block[6] 490
	set Block->Digit[490] 6
	set Digit->Block[7] 491
	set Block->Digit[491] 7
	set Digit->Block[8] 492
	set Block->Digit[492] 8
	set Digit->Block[9] 493
	set Block->Digit[493] 9
quit

#died
	ifnot Alive quit
	set Alive false
	cpemsg bigannounce &cGame Over!
	cpemsg smallannounce &eScore: &f{Score}
	cpemsg top1
	cs me explosion2
quit

#readhighscore
	set {runArg1}
	set l_x 64
	#readhighscorestartloop
		setblockid l_id {l_x} 70 48
		setsub l_x 1
		ifnot l_id|=|0 set {runArg1} {Block->Digit[{l_id}]}{{runArg1}}
	ifnot l_id|=|0 jump #readhighscorestartloop
	set l_x 65
	#readhighscoreendloop
		setblockid l_id {l_x} 70 48
		setadd l_x 1
		ifnot l_id|=|0 set {runArg1} {{runArg1}}{Block->Digit[{l_id}]}
	ifnot l_id|=|0 jump #readhighscoreendloop
	if {runArg1}|=|"" set {runArg1} 0
quit

#printhighscore
	call #readhighscore|l_hs
	msg {l_hs}
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
	if PlayerZ|<|46 quit
	set l_pos {PlayerZ}
	set l_reltpdist 0
	#dojumps
		setadd l_reltpdist 4
		setsub l_pos 4
		setadd Score 1
		set l_modscore {Score}
		setmod l_modscore 10
		if l_modscore|=|0 set l_milestonetext &uScore: &f{Score}
		if l_modscore|=|0 set l_milestonesound collect pizza
		set l_modscore {Score}
		setmod l_modscore 50
		if l_modscore|=|0 set l_milestonetext &6Score: &f{Score}
		if l_modscore|=|0 set l_milestonesound collect giant pizza
	ifnot l_pos|<|46 jump #dojumps
	cmd reltp 0 0 -{l_reltpdist}
	cpemsg top1 &eScore: &f{Score}
	allowmbrepeat
	cs me ding:choose(4):cut(0.1) ding:choose(4):pitch(2)
	ifnot l_milestonetext|=|"" cpemsg smallannounce {l_milestonetext}
	ifnot l_milestonesound|=|"" cs me {l_milestonesound}
	tempchunk 4 2 48 4 2 49 4 2 44
	delay 100
	tempblock 215 4 2 44
	delay 100
	tempblock 215 4 2 45
quit