using cef

#puter
	if puter jump #click
	set puter true
	ifnot cef jump #noputer
	msg You turn on the computer...
	msg cef create -n s -t bravelycowering.net/ccputer
	msg cef resolution 64 64
	msg cef size 4 4
	msg cef at 69 66 59.5 270 0
	tempblock 696 69 66 59
quit

#noputer
	msg &cYou need the CEF plugin to use the computer.
quit

#click
	msg cef click -n s
quit

#globalrandommusic
	call #setrandomsong
	call #playsong
quit

#setrandomsong
	ifnot cef jump #nocef
	setrandrange song 1 {songs}
	call #setsong|{song}
quit

#playsong
	ifnot cef jump #nocef
	if song|=|"" jump #nosong
	localmsg chat cef create -n m -sgq bravelycowering.net/files/{song[{song}]}
	localmsg chat &fNow playing &b{songname[{song}]}
	placeblock {songblock[{song}]} 69 69 67
	call #saveepochms
quit

#nosong
	ifnot cef jump #nocef
	msg &cYou must select a song first
quit

#onJoin
	call #setupsongs
	call #setupsnow
	ifnot cef jump #endJoin
	setblockid id 69 69 67
	ifnot id|=|709 call #resumesong
	else msg cef create -n m -sgqa bravelycowering.net/files/womp.mp3
#endJoin
	cmd oss #mainloop repeatable
quit

#setupsnow
	set snowy true
	env weather snow
	env sky d0d7e0
	tempchunk 53 63 47 79 63 53 53 65 47
quit

#setupsun
	set snowy false
	env weather sun
	env sky 99ccff
	tempchunk 53 65 47 79 65 53 53 65 47
quit

#setuprain
	set snowy false
	env weather rain
	env sky 778899
	tempchunk 53 62 47 79 62 53 53 65 47
quit

#mainloop
	ifnot snowy jump #endofsnowy
		set coords {PlayerCoords}
		setblockid id {coords}
		if id|=|706 tempblock 53 {coords} true
	#endofsnowy
	delay 100
	if actionCount|>=|50000 cmd oss #mainloop repeatable
	if actionCount|>|50000 terminate
jump #mainloop

#resumesong
	ifnot cef jump #nocef
	call #getepochms
	setblockid id 69 69 67
	set time {epochMS}
	setsub time {ms}
	setdiv time 1000
	set s {blocksong[{id}]}
	// msg debug: {epochMS} resuming song {id} ({s}: {songname[{s}]}) at epoch {ms} ({time}s) 
	msg cef create -n m -sgq bravelycowering.net/files/{song[{s}]}
	msg cef time -n m {time}
quit

#setsong
	ifnot cef jump #nocef
	set song {runArg1}
	cpemsg bot1 &fSelected song:
	cpemsg bot2 &b{songname[{song}]}
quit

#togglesong
	ifnot cef jump #nocef
	setblockid id 69 69 67
	if id|=|709 jump #playsong
	placeblock 709 69 69 67
	localmsg chat cef stop -n m
quit

#fakeshelf
	set X {MBX}
	set Y {MBY}
	set Z {MBZ}
	setadd X 1
	setsub Y 1
	cmd m {X} {Y} {Z}
quit

#saveepochms
	set ms {epochMS}
	setsplit ms
	set index 0
	#saveloop
		call #getnumblock|{ms[{index}]}
		placeblock {id} {index} 0 0
		setadd index 1
	if index|<|{ms.Length} jump #saveloop
	placeblock 0 {index} 0 0
quit

#getepochms
	set ms
	set index 0
	#getloop
		setblockid id {index} 0 0
		if id|=|0 quit
		call #idtonum|{id}
		set ms {ms}{num}
		setadd index 1
	jump #getloop
quit

#idtonum
	set num {runArg1}
	setsub num 484
quit

#getnumblock
	set id {runArg1}
	setadd id 484
quit

#nocef
	msg &cYou need to have the CEF plugin installed to play or pick up records.
	msg $cef
terminate

#setupsongs
	set songs 18
	// NEO TO THE [[CORE]]
	set songname[1] NEO TO THE [[CORE]]
	set song[1] CORE.mp3
	set songblock[1] 371
	set blocksong[371] 1
	// The End of the
	set songname[2] End
	set song[2] end.ogg
	set songblock[2] 353
	set blocksong[353] 2
	// Track B (ball)
	set songname[3] Track B (ball)
	set song[3] ball.ogg
	set songblock[3] 379
	set blocksong[379] 3
	// give me a (break)
	set songname[4] give me a (break)
	set song[4] breakcore.ogg
	set songblock[4] 367
	set blocksong[367] 4
	// INDEPENDANCE
	set songname[5] INDEPENDANCE
	set song[5] level1.ogg
	set songblock[5] 365
	set blocksong[365] 5
	// Loss Of Identity
	set songname[6] Loss Of Identity
	set song[6] loss.mp3
	set songblock[6] 373
	set blocksong[373] 6
	// The End of the Game
	set songname[7] The End of the Game
	set song[7] endgame.ogg
	set songblock[7] 387
	set blocksong[387] 7
	// The End of the World
	set songname[8] The End of the World
	set song[8] endworld.ogg
	set songblock[8] 642
	set blocksong[642] 8
	// Magic Trick
	set songname[9] Magic Trick
	set song[9] magictrick.ogg
	set songblock[9] 383
	set blocksong[383] 9
	// Undertale - Predictable (Fan Song)
	set songname[10] Predictable
	set song[10] predictable.ogg
	set songblock[10] 381
	set blocksong[381] 10
	// Castle Battle
	set songname[11] Castle Battle
	set song[11] castlebat.ogg
	set songblock[11] 361
	set blocksong[361] 11
	// Neurospastai
	set songname[12] Neurospastai
	set song[12] avventura.wav
	set songblock[12] 363
	set blocksong[363] 12
	// Optometrist
	set songname[13] Optometrist
	set song[13] optometrist.ogg
	set songblock[13] 377
	set blocksong[377] 13
	// Ocean battle
	set songname[14] Ocean battle
	set song[14] goblinbat.mp3
	set songblock[14] 369
	set blocksong[369] 14
	// Funkle
	set songname[15] Funkle
	set song[15] funkle.mp3
	set songblock[15] 355
	set blocksong[355] 15
	// And Now For Something Completely Different
	set songname[16] And Now For Something Completely Different
	set song[16] different.mp3
	set songblock[16] 385
	set blocksong[385] 16
	// Undertale - Another Medium (Remix)
	set songname[17] Another Medium (Remix)
	set song[17] medium.ogg
	set songblock[17] 375
	set blocksong[375] 17
	// Miscellaneous Battle Theme
	set songname[18] Miscellaneous Battle Theme
	set song[18] misc_battle.wav
	set songblock[18] 359
	set blocksong[359] 18
quit