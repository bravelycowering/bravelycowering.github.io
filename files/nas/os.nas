#globalrandommusic
	call #setupsongs
	setdeathspawn {PlayerCoords} {PlayerYaw} {PlayerPitch}
	setrandrange index 1 {songs}
	kill cef create -n m -sgq bravelycowering.net/files/{song[{index}]}
	kill &fNow playing &b{songname[{index}]}
quit

#onJoin
	call #setupsongs
quit

#setupsongs
	set songs 18
	// NEO TO THE [[CORE]]
	set songname[1] NEO TO THE [[CORE]]
	set song[1] CORE.mp3
	// The End of the
	set songname[2] The End of the
	set song[2] end.ogg
	// Track B (ball)
	set songname[3] Track B (ball)
	set song[3] ball.ogg
	// give me a (break)
	set songname[4] give me a (break)
	set song[4] breakcore.ogg
	// INDEPENDANCE
	set songname[5] INDEPENDANCE
	set song[5] level1.ogg
	// Loss Of Identity
	set songname[6] Loss Of Identity
	set song[6] loss.mp3
	// The End of the Game
	set songname[7] The End of the Game
	set song[7] endgame.ogg
	// The End of the World
	set songname[8] The End of the World
	set song[8] endworld.ogg
	// Magic Trick
	set songname[9] Magic Trick
	set song[9] magic trick.ogg
	// Undertale - Predictable (Fan Song)
	set songname[10] Undertale - Predictable (Fan Song)
	set song[10] predictable.ogg
	// Castle Battle
	set songname[11] Castle Battle
	set song[11] castlebat.ogg
	// Neurospastai
	set songname[12] Neurospastai
	set song[12] avventura.wav
	// Optometrist
	set songname[13] Optometrist
	set song[13] optometrist.ogg
	// Ocean battle
	set songname[14] Ocean battle
	set song[14] goblinbat.mp3
	// Funkle
	set songname[15] Funkle
	set song[15] funkle.mp3
	// And Now For Something Completely Different
	set songname[16] And Now For Something Completely Different
	set song[16] different.mp3
	// Undertale - Another Medium (Remix)
	set songname[17] Undertale - Another Medium (Remix)
	set song[17] medium.ogg
	// Miscellaneous Battle Theme
	set songname[18] Miscellaneous Battle Theme
	set song[18] misc_battle.wav
quit