using local_packages

#play
	cmd tp 4 3 44 180 0
	set Score 0
	set Alive true
	cpemsg bigannounce
	cpemsg smallannounce
	call #readhighscore|69|HighScore
	call #readhighscore|70|Holder
	cpemsg top1 &eScore: &f{Score}
	cpemsg top2 &bHighscore: &f{HighScore} &7({Holder})
	boost 0 0 0 1 1 1
	allowmbrepeat
	tempchunk 4 2 43 4 2 45 4 2 43
	call #charblocks
quit

#charblocks
	set Char->Block[0] 484
	set Block->Char[484] 0
	set Char->Block[1] 485
	set Block->Char[485] 1
	set Char->Block[2] 486
	set Block->Char[486] 2
	set Char->Block[3] 487
	set Block->Char[487] 3
	set Char->Block[4] 488
	set Block->Char[488] 4
	set Char->Block[5] 489
	set Block->Char[489] 5
	set Char->Block[6] 490
	set Block->Char[490] 6
	set Char->Block[7] 491
	set Block->Char[491] 7
	set Char->Block[8] 492
	set Block->Char[492] 8
	set Char->Block[9] 493
	set Block->Char[493] 9

	set Char->Block[A] 494
	set Block->Char[494] A
	set Char->Block[B] 495
	set Block->Char[495] B
	set Char->Block[C] 496
	set Block->Char[496] C
	set Char->Block[D] 497
	set Block->Char[497] D
	set Char->Block[E] 498
	set Block->Char[498] E
	set Char->Block[F] 499
	set Block->Char[499] F
	set Char->Block[G] 500
	set Block->Char[500] G
	set Char->Block[H] 501
	set Block->Char[501] H
	set Char->Block[I] 502
	set Block->Char[502] I
	set Char->Block[J] 503
	set Block->Char[503] J
	set Char->Block[K] 504
	set Block->Char[504] K
	set Char->Block[L] 505
	set Block->Char[505] L
	set Char->Block[M] 506
	set Block->Char[506] M
	set Char->Block[N] 507
	set Block->Char[507] N
	set Char->Block[O] 508
	set Block->Char[508] O
	set Char->Block[P] 509
	set Block->Char[509] P
	set Char->Block[Q] 510
	set Block->Char[510] Q
	set Char->Block[R] 511
	set Block->Char[511] R
	set Char->Block[S] 512
	set Block->Char[512] S
	set Char->Block[T] 513
	set Block->Char[513] T
	set Char->Block[U] 514
	set Block->Char[514] U
	set Char->Block[V] 515
	set Block->Char[515] V
	set Char->Block[W] 516
	set Block->Char[516] W
	set Char->Block[X] 517
	set Block->Char[517] X
	set Char->Block[Y] 518
	set Block->Char[518] Y
	set Char->Block[Z] 519
	set Block->Char[519] Z
	set Char->Block[.] 520
	set Block->Char[520] .
	set Char->Block[_] 45
	set Block->Char[45] _
quit

#died
	ifnot Alive quit
	set Alive false
	set HasBrokenOnRun false
	cpemsg bigannounce &cGame Over!
	cpemsg smallannounce &eScore: &f{Score}
	cpemsg top1
	cpemsg top2
	cs me sh
	cs me explosion2
quit

#readhighscore
	// level, package
	set {runArg2}
	set l_x 64
	#readhighscorestartloop
		setblockid l_id {l_x} {runArg1} 48
		ifnot l_id|=|0 set {runArg2} {Block->Char[{l_id}]}{{runArg2}}
		setsub l_x 1
	ifnot l_id|=|0 jump #readhighscorestartloop
	set l_x 65
	#readhighscoreendloop
		setblockid l_id {l_x} {runArg1} 48
		ifnot l_id|=|0 set {runArg2} {{runArg2}}{Block->Char[{l_id}]}
		setadd l_x 1
	ifnot l_id|=|0 jump #readhighscoreendloop
quit

#clearhighscore
	// level
	set l_x 64
	#clearhighscorestartloop
		setblockid l_id {l_x} {runArg1} 48
		ifnot l_id|=|0 placeblock 0 {l_x} {runArg1} 48
		setsub l_x 1
	ifnot l_id|=|0 jump #clearhighscorestartloop
	set l_x 65
	#clearhighscoreendloop
		setblockid l_id {l_x} {runArg1} 48
		ifnot l_id|=|0 placeblock 0 {l_x} {runArg1} 48
		setadd l_x 1
	ifnot l_id|=|0 jump #clearhighscoreendloop
quit

#writehighscore
	// level, value
	set l_value {runArg2}
	setsplit l_value
	set l_x {l_value.length}
	setdiv l_x -2
	setroundup l_x
	setadd l_x 64
	set l_i 0
	#writehighscoreloop
		placeblock {Char->Block[{l_value[{l_i}]}]} {l_x} {runArg1} 48
		setadd l_i 1
		setadd l_x 1
	if l_i|<|l_value.length jump #writehighscoreloop
quit

#checkupdateleaderboard
	set l_usernameplus @p
	setsplit l_usernameplus +
	set l_username {l_usernameplus[0]}
	call #readhighscore|69|HighScore
	call #readhighscore|70|Holder
	if Score|<=|HighScore quit
	ifnot HasBrokenOnRun jump #hasntbrokenyet
	if Holder|=|l_username jump #endupdateholder
	#hasntbrokenyet
		set HasBrokenOnRun true
		localmsg announce @color@nick&7 just broke the Highscore of &b{HighScore}
		set l_milestonesound collect toppin
		set Holder {l_username}
		call #clearhighscore|70
		call #writehighscore|70|{Holder}
	#endupdateholder
	set HighScore {Score}
	call #writehighscore|69|{HighScore}
quit

#checkjump
	allowmbrepeat
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
	// do post score update things
	call #checkupdateleaderboard
	cpemsg top1 &eScore: &f{Score}
	cpemsg top2 &bHighscore: &f{HighScore} &7({Holder})
	cs me ding:choose(4):cut(0.1) ding:choose(4):pitch(2)
	ifnot l_milestonetext|=|"" cpemsg smallannounce {l_milestonetext}
	ifnot l_milestonesound|=|"" cs me {l_milestonesound}
	// force allow mb repeat (boost so silly)
	boost 0 0 0 0 0 0 0 1
	// do animation stuffs
	tempchunk 4 2 48 4 2 49 4 2 44
	delay 100
	tempblock 215 4 2 44
	delay 100
	tempblock 215 4 2 45
quit

#cleverlydone
	// cheat with chatsounds
	msg &0@truename: cleverly done mr freeman but youre not supposed to be here as a matter of fact you are not:cut(5.5)
	delay 6000
	kill
quit