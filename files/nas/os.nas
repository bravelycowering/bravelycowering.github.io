#globalrandommusic
	setrandrange song 1 {songs}
	call #setsong|{song}
	call #playsong
quit

#playsong
	setdeathspawn {PlayerCoords} {PlayerYaw} {PlayerPitch}
	kill cef play -n m -sq bravelycowering.net/files/{song[{song}]}
	kill &fNow playing &b{songname[{song}]}
	placeblock {songblock[{song}]} 69 69 67
quit

#onJoin
	msg cef create -n m -sgq
	call #setupsongs
quit

#setsong
	set song {runArg1}
	msg &fSelected &b{songname[{song}]}
	cpemsg bot1 &fSelected song:
	cpemsg bot2 &b{songname[{song}]}
quit

#togglesong
	setblockid id 69 69 67
	if id|=|709 jump #playsong
	placeblock 709 69 69 67
	setdeathspawn {PlayerCoords} {PlayerYaw} {PlayerPitch}
	kill cef stop -n m
quit

#fakeshelf
	set X {MBX}
	set Y {MBY}
	set Z {MBZ}
	setadd X 1
	setsub Y 1
	cmd m {X} {Y} {Z}
quit

#setupsongs
	set songs 18
	// NEO TO THE [[CORE]]
	set songname[1] NEO TO THE [[CORE]]
	set song[1] CORE.mp3
	set songblock[1] 371
	// The End of the
	set songname[2] End
	set song[2] end.ogg
	set songblock[2] 353
	// Track B (ball)
	set songname[3] Track B (ball)
	set song[3] ball.ogg
	set songblock[3] 379
	// give me a (break)
	set songname[4] give me a (break)
	set song[4] breakcore.ogg
	set songblock[4] 367
	// INDEPENDANCE
	set songname[5] INDEPENDANCE
	set song[5] level1.ogg
	set songblock[5] 365
	// Loss Of Identity
	set songname[6] Loss Of Identity
	set song[6] loss.mp3
	set songblock[6] 373
	// The End of the Game
	set songname[7] The End of the Game
	set song[7] endgame.ogg
	set songblock[7] 387
	// The End of the World
	set songname[8] The End of the World
	set song[8] endworld.ogg
	set songblock[8] 642
	// Magic Trick
	set songname[9] Magic Trick
	set song[9] magictrick.ogg
	set songblock[9] 383
	// Undertale - Predictable (Fan Song)
	set songname[10] Undertale - Predictable (Fan Song)
	set song[10] predictable.ogg
	set songblock[10] 381
	// Castle Battle
	set songname[11] Castle Battle
	set song[11] castlebat.ogg
	set songblock[11] 361
	// Neurospastai
	set songname[12] Neurospastai
	set song[12] avventura.wav
	set songblock[12] 363
	// Optometrist
	set songname[13] Optometrist
	set song[13] optometrist.ogg
	set songblock[13] 377
	// Ocean battle
	set songname[14] Ocean battle
	set song[14] goblinbat.mp3
	set songblock[14] 369
	// Funkle
	set songname[15] Funkle
	set song[15] funkle.mp3
	set songblock[15] 355
	// And Now For Something Completely Different
	set songname[16] And Now For Something Completely Different
	set song[16] different.mp3
	set songblock[16] 385
	// Undertale - Another Medium (Remix)
	set songname[17] Undertale - Another Medium (Remix)
	set song[17] medium.ogg
	set songblock[17] 375
	// Miscellaneous Battle Theme
	set songname[18] Miscellaneous Battle Theme
	set song[18] misc_battle.wav
	set songblock[18] 359
quit