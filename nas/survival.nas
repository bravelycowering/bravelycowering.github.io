using local_packages
using no_runarg_underscore_conversion

#onJoin
	if LevelName|=|"iloveminecraft1+" cmd g hell
	clickevent sync register #click
	reach 4

	set true true

	set minetimer 0
	set minepos
	set pickaxe 0
	set axe 0
	set spade 0

	set maxhp 30
	set hp {maxhp}
	set iframes 0
	set fireticks 0
	set autosave 50

	set LevelXMax {LevelX}
	setsub LevelXMax 1
	set LevelYMax {LevelY}
	setsub LevelYMax 1
	set LevelZMax {LevelZ}
	setsub LevelZMax 1

set inventory 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	setsplit inventory ,

	set allowMapChanges false
	if LevelName|=|"bravelycowering+survival" set allowMapChanges true
	if LevelName|=|"bravelycowering+2" set allowMapChanges true

	if LevelName|=|"bravelycowering+survivaldev" cpemsg smallannounce Please go to &abravelycowering+survival&f instead
	if LevelName|=|"bravelycowering+survivaldev" cpemsg bigannounce &cNothing saves here

	set DeathSpawn {PlayerCoords} {PlayerYaw} {PlayerPitch}
	set WorldSpawn {DeathSpawn}
	set SpawnBlock none

	cmd holdsilent 0
	gui barColor #ff0000 0.25

	call #version
	msg &fType &a/in changes&f to view the changelog.

	msg &fYou can place and break blocks freely in this map.
	if allowMapChanges msg &aYour progress will be saved in this world.
	else msg &cEverything you do is temporary. Leaving the map will reset your progress.
	msg &fType &a/in&f to view your &ainventory&f.

	call #initStructs

	// compat with id finder thingy
	set blocks[pickaxe].name Pickaxe
	set blocks[axe].name Axe
	set blocks[spade].name Spade

	set isTool(pickaxe) true
	set isTool(axe) true
	set isTool(spade) true

	set allowSaving false
	if allowSaving call #initSave

	cmd oss #tick repeatable
quit

#changelog
	msg &fChanges in the latest major version:
	msg - Fixed a bug where mining the walls would sometimes crash the script
	msg - Your respawn is properly updated if your campfire goes out now
	msg - Slight changes to the quantity of mushrooms in a world
	msg - New recipes for Slab and Stone brick, along with a way of obtaining Glass with the Campfire
	msg - New blocks: Flax, Tombstone
	msg - Flax now generate alongside roses and dandelions, albiet in smaller quantities
	msg - A grave will now spawn containing your items where you die
	// msg - Progress now saves every 5 seconds
#version
	msg &fVersion &a0.3.8
quit

#initSave
	// localname l_msg_1 
	// localname l_break_1 
	set l_x_1 0
	set l_z_1 0
	set l_prefix_1 /nothing2 @p
	#while_1
		#while_2
			setblockmessage l_msg_1 {l_x_1} 0 {l_z_1}
			ifnot l_msg_1|=|"" jump #if_1
				// set save slot and claim block
				set saveSlot {l_x_1} 0 {l_z_1}
				placemessageblock 7 {saveSlot} /nothing2 @p
				quit
			#if_1
			ifnot l_msg_1|has|l_prefix_1 jump #if_2
				// set save slot and load from it
				set saveSlot {l_x_1} 0 {l_z_1}
				jump #load
			#if_2
			setadd l_z_1 1
		if l_z_1|<|LevelZ jump #while_2
		setadd l_x_1 1
	if l_x_1|<|LevelX jump #while_1
quit

#save
	if saveSlot|=|"" quit
	set PlayerPos {PlayerCoordsPrecise} {PlayerYaw} {PlayerPitch}
	set HeldBlock {PlayerHeldBlock}
placemessageblock 7 {saveSlot} /nothing2 @p|{PlayerPos}|{pickaxe}|{axe}|{spade}|{hp}|{maxhp}|{fireticks}|{inventory[0]},{inventory[1]},{inventory[2]},{inventory[3]},{inventory[4]},{inventory[5]},{inventory[6]},{inventory[7]},{inventory[8]},{inventory[9]},{inventory[10]},{inventory[11]},{inventory[12]},{inventory[13]},{inventory[14]},{inventory[15]},{inventory[16]},{inventory[17]},{inventory[18]},{inventory[19]},{inventory[20]},{inventory[21]},{inventory[22]},{inventory[23]},{inventory[24]},{inventory[25]},{inventory[26]},{inventory[27]},{inventory[28]},{inventory[29]},{inventory[30]},{inventory[31]},{inventory[32]},{inventory[33]},{inventory[34]},{inventory[35]},{inventory[36]},{inventory[37]},{inventory[38]},{inventory[39]},{inventory[40]},{inventory[41]},{inventory[42]},{inventory[43]},{inventory[44]},{inventory[45]},{inventory[46]},{inventory[47]},{inventory[48]},{inventory[49]},{inventory[50]},{inventory[51]},{inventory[52]},{inventory[53]},{inventory[54]},{inventory[55]},{inventory[56]},{inventory[57]},{inventory[58]},{inventory[59]},{inventory[60]},{inventory[61]},{inventory[62]},{inventory[63]},{inventory[64]},{inventory[65]},{inventory[66]},{inventory[67]},{inventory[68]},{inventory[69]},{inventory[70]},{inventory[71]},{inventory[72]},{inventory[73]},{inventory[74]},{inventory[75]},{inventory[76]},{inventory[77]},{inventory[78]},{inventory[79]},{inventory[80]},{inventory[81]},{inventory[82]},{inventory[83]}|{DeathSpawn}|{SpawnBlock}|{HeldBlock}
quit

#load
	if saveSlot|=|"" quit
	// localname l_loaddata_1 
	setblockmessage l_loaddata_1 {saveSlot}
	setsplit l_loaddata_1 |
	set l_i_1 1
	ifnot l_i_1|<|saveformat.Length quit
	#while_3
		set {saveformat[{l_i_1}]} {l_loaddata_1[{l_i_1}]}
		setadd l_i_1 1
	if l_i_1|<|l_loaddata_1.Length jump #while_3
	setsplit inventory ,
	ifnot PlayerPos|=|"" cmd tpp {PlayerPos}
	ifnot HeldBlock|=|"" cmd holdsilent {HeldBlock}
quit

// checks against humanoid hitbox (-0.25 to 0.21875)
#setstandingon
	// localname l_exitfalse_1 
	set l_package_1 {runArg1}
	set l_blockfield_1 {runArg2}
	set l_comp_1 {runArg3}
	set l_blockvalue_1 {runArg4}
	set {l_package_1} true
	// package, blockfield, comp, blockvalue
	set l_coords_1 {PlayerCoordsDecimal}
	setsplit l_coords_1 " "
	if l_coords_1[1]|!=|PlayerY jump #l_exitfalse_1
	setsub l_coords_1[1] 0.03125
	set l_y_1 {l_coords_1[1]}
	setrounddown l_y_1

	// add 0.21875 here instead of subtracting 0.25 because its 0.46875 off
	setadd l_coords_1[0] 0.21875
	set l_x_2 {l_coords_1[0]}
	setrounddown l_x_2
	setadd l_coords_1[2] 0.21875
	set l_z_2 {l_coords_1[2]}
	setrounddown l_z_2
	// localname l_id_1 
	call #getblock|l_id_1|{l_x_2}|{l_y_1}|{l_z_2}
	if blocks[{l_id_1}].{l_blockfield_1}|{l_comp_1}|{l_blockvalue_1} quit

	setadd l_coords_1[0] 0.5
	set l_x_2 {l_coords_1[0]}
	setrounddown l_x_2
	call #getblock|l_id_1|{l_x_2}|{l_y_1}|{l_z_2}
	if blocks[{l_id_1}].{l_blockfield_1}|{l_comp_1}|{l_blockvalue_1} quit

	setsub l_coords_1[0] 0.5
	set l_x_2 {l_coords_1[0]}
	setrounddown l_x_2
	setadd l_coords_1[2] 0.5
	set l_z_2 {l_coords_1[2]}
	setrounddown l_z_2
	call #getblock|l_id_1|{l_x_2}|{l_y_1}|{l_z_2}
	if blocks[{l_id_1}].{l_blockfield_1}|{l_comp_1}|{l_blockvalue_1} quit

	setadd l_coords_1[0] 0.5
	set l_x_2 {l_coords_1[0]}
	setrounddown l_x_2
	call #getblock|l_id_1|{l_x_2}|{l_y_1}|{l_z_2}
	if blocks[{l_id_1}].{l_blockfield_1}|{l_comp_1}|{l_blockvalue_1} quit
	
	#l_exitfalse_1
	set {l_package_1} false
quit

#setdist
	// package, x1, y1, z1, x2, y2, z2
	set l_a_1 {runArg5}
	setsub l_a_1 {runArg2}
	setmul l_a_1 {l_a_1}
	set l_b_1 {runArg6}
	setsub l_b_1 {runArg3}
	setmul l_b_1 {l_b_1}
	set l_c_1 {runArg7}
	setsub l_c_1 {runArg4}
	setmul l_c_1 {l_c_1}
	setadd l_a_1 {l_b_1}
	setadd l_a_1 {l_c_1}
	setsqrt {runArg1} {l_a_1}
quit

#tick
	// localname l_PrevPlayerCoords_1 
	// localname l_prevhp_1 
	// localname l_myblock_1 
	ifnot saveSlot|=|"" setsub autosave 1
	if autosave|<|0 call #save
	if autosave|<|0 set autosave 50
	call #getblock|l_myblock_1|{PlayerX}|{PlayerY}|{PlayerZ}
	ifnot blocks[{l_myblock_1}].catchFire jump #if_3
		set fireticks 100
		cpemsg smallannounce &6▐▐▐▐▐▐▐▐▐▐
	#if_3
	ifnot blocks[{l_myblock_1}].extinguishFire jump #if_4
		ifnot fireticks|>|0 jump #if_5
			gui barSize 0
			set fireticks 0
		#if_5
	#if_4
	ifnot blocks[{l_myblock_1}].damage|=|"" call #damage|{blocks[{l_myblock_1}].damage}|{blocks[{l_myblock_1}].damageType}
	ifnot PlayerCoords|=|l_PrevPlayerCoords_1 set usingWorkbench false
	ifnot PlayerCoords|=|l_PrevPlayerCoords_1 set usingStonecutter false
	set l_PrevPlayerCoords_1 {PlayerCoords}
	delay 100
	if debug cpemsg top1 &c{actionCount}/60000
	if hp|=|l_prevhp_1 jump #ifnot_1
		set l_prevhp_1 {hp}
		// localname l_hpbar_1 
		call #makebar|l_hpbar_1|c|{hp}|{maxhp}
		cpemsg bot1 &c♥ {l_hpbar_1}
	#ifnot_1
	if inventory[{PlayerHeldBlock}]|>|0 cpemsg bot2 Holding: &6{blocks[{PlayerHeldBlock}].name} &f(x{inventory[{PlayerHeldBlock}]})
	else cpemsg bot2 Holding: &cNothing
	cpemsg bot3 {toollevel[{pickaxe}]} Pickaxe &f| {toollevel[{axe}]} Axe &f| {toollevel[{spade}]} Spade
	ifnot iframes|>|0 jump #if_6
		setsub iframes 1
		ifnot iframes|<|2 gui barColor #ff0000 0.25
		if iframes|<|2 gui barSize 0
		else gui barSize 1
	#if_6
	ifnot fireticks|>|0 jump #if_7
		setsub fireticks 1
		set l_firetickmod_1 {fireticks}
		setmod l_firetickmod_1 10
		ifnot l_firetickmod_1|=|0 jump #if_8
			ifnot fireticks|>|0 jump #if_9
				// localname l_temp_1 
				set l_temp_1 {fireticks}
				setdiv l_temp_1 10
				// localname l_firebar_1 
				call #makecharbar|l_firebar_1|▐|6|{l_temp_1}|10
				cpemsg smallannounce {l_firebar_1}
			#if_9
			ifnot fireticks|>|0 cpemsg smallannounce
			call #damage|2|burn
		#if_8
	#if_7
	// random tick
	// localname l_x_3 
	setrandrange l_x_3 0 {LevelXMax}
	// localname l_y_2 
	setrandrange l_y_2 0 {LevelYMax}
	// localname l_z_3 
	setrandrange l_z_3 0 {LevelZMax}
	// localname l_id_2 
	setblockid l_id_2 {l_x_3} {l_y_2} {l_z_3}
	if label #blocktick[{l_id_2}] call #blocktick[{l_id_2}]|{l_x_3}|{l_y_2}|{l_z_3}
	if actionCount|>=|60000 cmd oss #tick repeatable
	if actionCount|>|60000 terminate
	jump #tick
quit

#grow
	cmd brush replace
	cmd outline {runArg1} up 0 {runArg2}
	cmd ma
	cmd brush normal
quit

#generate
	// get seed
	msg Generating
	call #generate.setupCommands
	replysilent 1|Start generating!|#generate.start
	quit
	#generate.start
	call #generate.isolate
	call #generate.plantGrass
	call #generate.flood
	call #generate.caves
	call #generate.plugholes
	call #generate.ores
	call #generate.lavaFloor
	call #generate.plants
	call #generate.cleanupCommands
quit

#generate.setupCommands
	localmsg smallannounce Preparing generation...
	localmsg chat Preparing generation...
	msg &cPLEASE USE THE FOLLOWING COMMANDS FIRST
	msg &f/os texture bravelycowering.net/files/default2.zip
	msg &f/os lb copyall bravelycowering+survivaldev
	msg &f/os blockprops 764 grass 767
	msg &f/os blockprops 765 grass 766
	msg &f/os blockprops 7 mb
	msg &f/os blockprops 82 mb
	msg &f/os blockprops 83 mb
	msg &aWHEN YOU ARE DONE, TYPE &f1
quit

#generate.isolate
	localmsg smallannounce Isolating terrain...
	localmsg chat Isolating terrain...
	cmd replaceall 8-11 17-18 37-40 0
	cmd replaceall 1-767 764
quit

#generate.plantGrass
	localmsg smallannounce Soiling ground...
	localmsg chat Soiling ground...
	cmd fixgrassarea
	cmd ma
	cmd replaceall 764 765
	cmd fixgrassarea
	cmd ma
	cmd fixgrassarea
	cmd ma
	cmd fixgrassarea
	cmd ma
	cmd replaceall 767 2
	cmd replaceall 766 3
	cmd replaceall 765 1
quit

#generate.flood
	localmsg smallannounce Flooding lakes...
	localmsg chat Flooding lakes...
	// fill water
	cmd replace 0 8
	cmd m 0 0 0
	cmd m {LevelX} 63 {LevelY}
	// replace grass w sand
	cmd replace 2 12
	cmd m 0 0 0
	cmd m {LevelX} 63 {LevelY}
	setrandrange seed -999999999 9999999999
	cmd replacebrush 12 cloudy 13 s={seed}
	cmd m 0 0 0
	cmd m {LevelX} 62 {LevelY}
quit

#generate.caves
	localmsg smallannounce Carving caves...
	localmsg chat Carving caves...
	setrandrange seed1 -999999999 9999999999
	setrandrange seed2 -999999999 9999999999
	setrandrange seed3 -999999999 9999999999

	cmd replacebrush 1 cloudy 767/2 a=2 f=.5 p=20 s={seed1}
	cmd ma
	cmd replacebrush 767 cloudy 1/2 0 a=2 f=.2 p=20 s={seed2}
	cmd ma

	cmd replacebrush 2 cloudy 767/2 a=2 f=.5 p=20 s={seed1}
	cmd ma
	cmd replacebrush 767 cloudy 2/2 767 a=2 f=.2 p=20 s={seed2}
	cmd ma
	cmd replacebrush 767 cloudy 2/3 0 a=2 f=.2 p=20 s={seed3}
	cmd ma

	cmd replacebrush 3 cloudy 767/3 a=2 f=.5 p=20 s={seed1}
	cmd m 0 63 0
	cmd m {LevelX} {LevelY} {LevelZ}
	cmd replacebrush 767 cloudy 3/2 767 a=2 f=.2 p=20 s={seed2}
	cmd m 0 63 0
	cmd m {LevelX} {LevelY} {LevelZ}
	cmd replacebrush 767 cloudy 3/3 0 a=2 f=.2 p=20 s={seed3}
	cmd m 0 63 0
	cmd m {LevelX} {LevelY} {LevelZ}
quit

#generate.plugholes
	localmsg smallannounce Plugging holes...
	localmsg chat Plugging holes...
	// plug holes w dirt
	cmd brush replace
	cmd outline 8 layer 0 3
	cmd ma
	cmd outline 8 down 0 3
	cmd ma
	cmd brush normal
quit

#generate.ores
	localmsg smallannounce Placing ores...
	localmsg chat Placing ores...
	cmd replacebrush 1 random 1/1993 14/2 15/2 16/2 52
	cmd ma
quit

#generate.plants
	localmsg smallannounce Planting vegetation...
	localmsg chat Planting vegetation...
	// plant notch trees in forests
	cmd replacebrush 2 cloudy 767 f=0.1
	cmd ma
	cmd replacebrush 767 random 2/199 767
	cmd ma
	cmd foreach 767 tree notch,m ~ ~1 ~
	cmd replaceall 767 3
	// plant big oak trees sparsely everywhere
	cmd replacebrush 2 random 2/999 767
	cmd ma
	cmd foreach 767 tree oak,m ~ ~1 ~
	cmd replaceall 767 3
	// flowers
	call #grow|2|767
	cmd replacebrush 767 cloudy 0/4 767 f=2
	cmd ma
	cmd replacebrush 767 cloudy 0 37/2 f=.2
	cmd ma
	cmd replacebrush 37 random 37/4 38/4 78/1 0/24
	cmd ma
	// mushrooms
	call #grow|1|767
	cmd replacebrush 767 cloudy 0/4 767
	cmd ma
	cmd replacebrush 767 cloudy 0 39/2 f=.2
	cmd ma
	cmd replacebrush 39 random 39 40 0/12
	cmd ma
quit

#generate.lavaFloor
	localmsg smallannounce Melting core...
	localmsg chat Melting core...
	// lava and bedrock
	cmd z 7
	cmd m 0 0 0
	cmd m {LevelX} 0 {LevelZ}
	cmd replace 0 10
	cmd m 0 1 0
	cmd m {LevelX} 3 {LevelZ}
	// magma
	cmd replacebrush 1 random 50 1
	cmd m 0 1 0
	cmd m {LevelX} 3 {LevelZ}
	cmd replacebrush 1 random 50 1/2
	cmd m 0 4 0
	cmd m {LevelX} 4 {LevelZ}
	cmd replacebrush 1 random 50 1/4
	cmd m 0 5 0
	cmd m {LevelX} 5 {LevelZ}
	// fire
	call #grow|50|54
	cmd replacebrush 54 random 0/4 54
	cmd ma
quit

#generate.cleanupCommands
	localmsg smallannounce Done!
	localmsg chat Done!
	msg &cDONT FORGET TO SET THE MOTD AND AD!:
	if allowMapChanges msg &f/os map motd -hax +thirdperson model=humanoid -aura -tp
	else msg &f/os map motd -hax +thirdperson -push model=humanoid -aura -tp
	msg &f/ad
quit

#damage
	if iframes|>|0 quit
	setsub hp {runArg1}
	set iframes 4
	cs me ow:select(7)
	if hp|<=|0 jump #die|{deathmessages.{runArg2}}
quit

#die
	set deathmsg {runArg1}
	if deathmsg|=|"" set deathmsg {deathmessages.unknown}
	if SpawnBlock|=|"none" jump #ifnot_2
		setsplit SpawnBlock " "
		call #getblock|spawnblockid|{SpawnBlock[0]}|{SpawnBlock[1]}|{SpawnBlock[2]}
		ifnot spawnblockid|!=|68 jump #if_10
			set SpawnBlock none
			set DeathSpawn {WorldSpawn}
			setdeathspawn {DeathSpawn}
		#if_10
	#ifnot_2
	set deathY {PlayerY}
	call #setblock|82|{PlayerX}|{deathY}|{PlayerZ}
set inventory {inventory[0]},{inventory[1]},{inventory[2]},{inventory[3]},{inventory[4]},{inventory[5]},{inventory[6]},{inventory[7]},{inventory[8]},{inventory[9]},{inventory[10]},{inventory[11]},{inventory[12]},{inventory[13]},{inventory[14]},{inventory[15]},{inventory[16]},{inventory[17]},{inventory[18]},{inventory[19]},{inventory[20]},{inventory[21]},{inventory[22]},{inventory[23]},{inventory[24]},{inventory[25]},{inventory[26]},{inventory[27]},{inventory[28]},{inventory[29]},{inventory[30]},{inventory[31]},{inventory[32]},{inventory[33]},{inventory[34]},{inventory[35]},{inventory[36]},{inventory[37]},{inventory[38]},{inventory[39]},{inventory[40]},{inventory[41]},{inventory[42]},{inventory[43]},{inventory[44]},{inventory[45]},{inventory[46]},{inventory[47]},{inventory[48]},{inventory[49]},{inventory[50]},{inventory[51]},{inventory[52]},{inventory[53]},{inventory[54]},{inventory[55]},{inventory[56]},{inventory[57]},{inventory[58]},{inventory[59]},{inventory[60]},{inventory[61]},{inventory[62]},{inventory[63]},{inventory[64]},{inventory[65]},{inventory[66]},{inventory[67]},{inventory[68]},{inventory[69]},{inventory[70]},{inventory[71]},{inventory[72]},{inventory[73]},{inventory[74]},{inventory[75]},{inventory[76]},{inventory[77]},{inventory[78]},{inventory[79]},{inventory[80]},{inventory[81]},{inventory[82]},{inventory[83]}
	call #setblockdata|{PlayerX}|{deathY}|{PlayerZ}|@p|{epochMS}|* &f{deathmsg}|{inventory}
	setsub deathY 1
	call #getblock|id|{PlayerX}|{deathY}|{PlayerZ}
	if blocks[{id}].nonsolid call #setblock|3|{PlayerX}|{deathY}|{PlayerZ}
	if blocks[{id}].grounded call #setblock|3|{PlayerX}|{deathY}|{PlayerZ}
	if allowMapChanges kill {deathmsg}
	else kill
	set fireticks 0
	set hp {maxhp}
	cpemsg bigannounce &cYou Died!
	cpemsg smallannounce {deathmsg}
set inventory 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	setsplit inventory ,
	cmd holdsilent 0
quit

#heal
	setadd hp {runArg1}
	if hp|>|maxhp set hp {maxhp}
	cpemsg smallannounce &c+{runArg1} ♥
quit

#click
	set coords {click.coords}
	setsplit coords " "
	if coords[0]|>|1000 jump #airclick
	if coords[1]|>|1000 jump #airclick
	if coords[2]|>|1000 jump #airclick
	setblockid id {coords}
	if id|=|65535 jump #airclick
	set PlayerEyeY {PlayerY}
	setadd PlayerEyeY 1
	call #setdist|dist|{PlayerX}|{PlayerEyeY}|{PlayerZ}|{coords[0]}|{coords[1]}|{coords[2]}
	if dist|>|5.5 jump #toofar
	if click.button|=|"Left" jump #mine|{coords[0]}|{coords[1]}|{coords[2]}
	if click.button|=|"Right" jump #place|{coords[0]}|{coords[1]}|{coords[2]}
	if click.button|=|"Middle" jump #pick|{coords[0]}|{coords[1]}|{coords[2]}
quit

#toofar
	// silent
	reach 4
	// msg &cYou can't reach that block!
quit

#airclick
	if click.button|=|"Right" jump #itemuse
quit

#mine
	set x {runArg1}
	set y {runArg2}
	set z {runArg3}
	set coords {x} {y} {z}
	call #getblock|id|{runArg1}|{runArg2}|{runArg3}
	cmd tempbot remove minemeter
	if blocks[{id}].unbreakable quit
	ifnot minepos|=|coords set minetimer {blocks[{id}].hardness}
	ifnot minepos|=|coords set minepos {coords}
	set minespeed 1
	ifnot blocks[{id}].tooltype|=|"" setadd minespeed {blocks[{id}].tooltype}
	if blocks[{id}].toughness|>|{blocks[{id}].tooltype} set toomuch true
	else set toomuch false
	if blocks[{id}].tooltype|=|"" set toomuch false
	if blocks[{id}].toughness|=|"" set toomuch false
	if toomuch set barcol c
	else set barcol a
	setsub minetimer {minespeed}
	ifnot minetimer|>|0 jump #if_11
		call #makebar|bar|{barcol}|{minetimer}|{blocks[{id}].hardness}
		set model {minetimer}
		setdiv model {blocks[{id}].hardness}
		setmul model 10
		setrounddown model
		setadd model 758
		set boty {y}
		setsub boty 0.01
		cmd tempbot add minemeter -20 -20 -20 0 0 skin &f
		cmd tempbot model minemeter {model}|1.07
		ifnot blocks[{id}].breakScale|=|"" cmd tempbot scale minemeter {blocks[{id}].breakScale}
		cmd tempbot tp minemeter {x} {boty} {z} 0 0
		quit
	#if_11
	set minepos
	jump #destroyblock|{x}|{y}|{z}|{toomuch}
quit

#destroyblock
	set x {runArg1}
	set y {runArg2}
	set z {runArg3}
	set toomuch {runArg4}
	call #getblock|id|{x}|{y}|{z}
	if toomuch jump #ifnot_3
		set dontDestroyBlock false
		if label #loot[{id}] call #loot[{id}]
		else call #give|{id}|1
		if dontDestroyBlock quit
	#ifnot_3
	if blocks[{id}].remainder|=|"" set empty 0
	else set empty {blocks[{id}].remainder}
	call #setblock|{empty}|{x}|{y}|{z}
	setadd y 1
	call #getblock|id|{x}|{y}|{z}
	if blocks[{id}].grounded jump #destroyblock|{x}|{y}|{z}|false
quit

#give
	ifnot isTool({runArg1}) jump #if_12
		set {runArg1} {runArg2}
		quit
	#if_12
	if inventory[{runArg1}]|=|0 cmd holdsilent {runArg1}
	setadd inventory[{runArg1}] {runArg2}
quit

#take
	setsub inventory[{runArg1}] {runArg2}
	if inventory[{runArg1}]|<|0 set inventory[{runArg1}] 0
	if inventory[{runArg1}]|=|0 cmd holdsilent 0
quit

#giveall
	set pickaxe 8
	set axe 8
	set spade 8
	set i 0
	#while_4
		set inventory[{i}] 9999
		setadd i 1
	if i|<|{blocks.Length} jump #while_4
quit

#clearall
	set pickaxe 0
	set axe 0
	set spade 0
	set i 0
	#while_5
		set inventory[{i}] 0
		setadd i 1
	if i|<|{blocks.Length} jump #while_5
quit

#place
	set x {runArg1}
	set y {runArg2}
	set z {runArg3}
	call #getblock|id|{x}|{y}|{z}
	if label #use[{id}:{PlayerHeldBlock}] jump #use[{id}:{PlayerHeldBlock}]|{x}|{y}|{z}
	if label #use[{id}] jump #use[{id}]|{x}|{y}|{z}
	if blocks[{PlayerHeldBlock}].replaceable jump #ifnot_4
		ifnot inventory[{PlayerHeldBlock}]|>|0 msg &cYou don't have any &f{blocks[{PlayerHeldBlock}].name}!
	#ifnot_4
	ifnot inventory[{PlayerHeldBlock}]|>|0 quit
	if blocks[{id}].replaceable quit
	if blocks[{id}].mergeInto|=|"" jump #ifnot_5
		ifnot PlayerHeldBlock|=|blocks[{id}].merger jump #if_13
			ifnot blocks[{id}].mergeFace|=|click.face jump #if_14
				call #take|{playerHeldBlock}|1
				jump #setblock|{blocks[{id}].mergeInto}|{x}|{y}|{z}
				quit
			#if_14
		#if_13
	#ifnot_5
	if click.face|=|"AwayX" setadd x 1
	if click.face|=|"AwayY" setadd y 1
	if click.face|=|"AwayZ" setadd z 1
	if click.face|=|"TowardsX" setsub x 1
	if click.face|=|"TowardsY" setsub y 1
	if click.face|=|"TowardsZ" setsub z 1
	call #getblock|id|{x}|{y}|{z}
	if blocks[{id}].mergeInto|=|"" jump #ifnot_6
		ifnot PlayerHeldBlock|=|blocks[{id}].merger jump #if_15
			call #take|{playerHeldBlock}|1
			jump #setblock|{blocks[{id}].mergeInto}|{x}|{y}|{z}
			quit
		#if_15
	#ifnot_6
	ifnot blocks[{id}].replaceable quit
	ifnot blocks[{PlayerHeldBlock}].grounded jump #if_16
		setsub y 1
		call #getblock|id|{x}|{y}|{z}
		if blocks[{id}].grounded quit
		if blocks[{id}].nonsolid quit
		setadd y 1
	#if_16
	call #take|{playerHeldBlock}|1
	jump #setblock|{PlayerHeldBlock}|{x}|{y}|{z}
quit

#itemuse
	if blocks[{PlayerHeldBlock}].food|=|"" jump #ifnot_7
		ifnot inventory[{PlayerHeldBlock}]|>|0 msg &cYou don't have any &f{blocks[{PlayerHeldBlock}].name}!
		ifnot inventory[{PlayerHeldBlock}]|>|0 quit
		ifnot hp|<|maxhp jump #if_17
			call #take|{playerHeldBlock}|1
			call #heal|{blocks[{PlayerHeldBlock}].food}
		#if_17
	#ifnot_7
quit

#pick
	call #getblock|id|{runArg1}|{runArg2}|{runArg3}
	if inventory[{id}]|>|0 cmd holdsilent {id}
quit

#getblock
	set {runArg1} {world[{runArg2},{runArg3},{runArg4}]}
	if {runArg1}|=|"" setblockid {runArg1} {runArg2} {runArg3} {runArg4}
quit

#setblock
	if allowMapChanges jump #ifnot_8
		tempblock {runArg1} {runArg2} {runArg3} {runArg4}
		set world[{runArg2},{runArg3},{runArg4}] {runArg1}
		set world[{runArg2},{runArg3},{runArg4}].msg
		quit
	#ifnot_8
	placemessageblock {runArg1} {runArg2} {runArg3} {runArg4}
quit

#getblockdata
	set {runArg1} {world[{runArg2},{runArg3},{runArg4}].msg}
	if {runArg1}|=|"" setblockmessage {runArg1} {runArg2} {runArg3} {runArg4}
	ifnot {runArg1}|=|"" set {runArg1} |{{runArg1}}
	ifnot {runArg1}|=|"" setsplit {runArg1} |/nothing2 {}
quit

#setblockdata
	set msg /nothing2 {runArg4}
	if runArg5|=|"" jump #ifnot_9
		set l_i_2 5
		#while_6
			set msg {msg}|/nothing2 {runArg{l_i_2}}
			setadd l_i_2 1
		ifnot runArg{l_i_2}|=|"" jump #while_6
	#ifnot_9
	setblockid id {runArg1} {runArg2} {runArg3}
	ifnot allowMapChanges set world[{runArg1},{runArg2},{runArg3}].msg {msg}
	else placemessageblock {id} {runArg1} {runArg2} {runArg3} {msg}
quit

#makebar
// package, color, amount, max
	set i 0
	set {runArg1} &{runArg2}
	ifnot i|<|{runArg3} jump #if_18
		#while_7
			set {runArg1} {{runArg1}}|
			setadd i 1
		if i|<|{runArg3} jump #while_7
	#if_18
	set {runArg1} {{runArg1}}&0
	ifnot i|<|{runArg4} jump #if_19
		#while_8
			set {runArg1} {{runArg1}}|
			setadd i 1
		if i|<|{runArg4} jump #while_8
	#if_19
quit

#makecharbar
// package, char, color, amount, max
	set i 0
	set {runArg1} &{runArg3}
	ifnot i|<|{runArg4} jump #if_20
		#while_9
			set {runArg1} {{runArg1}}{runArg2}
			setadd i 1
		if i|<|{runArg4} jump #while_9
	#if_20
	set {runArg1} {{runArg1}}&0
	ifnot i|<|{runArg5} jump #if_21
		#while_10
			set {runArg1} {{runArg1}}{runArg2}
			setadd i 1
		if i|<|{runArg5} jump #while_10
	#if_21
quit

#input
	if runArg1|=|"changes" jump #changelog
	ifnot runArg1|=|"craft" jump #if_22
		set craftArgs {runArg2}
		if craftArgs|=|"" jump #ifnot_10
			set craftArgs[1] 1
			setsplit craftArgs *
			if isTool({craftArgs[0]}) set craftArgs[1] 1
			call #getBlockByName|blockID|{craftArgs[0]}
			ifnot blockID|=|"" jump #if_23
				msg &cInvalid item name or ID
				quit
			#if_23
			call #getRecipeByOutput|recipeID|{blockID}|{craftArgs[1]}
			ifnot recipeID|=|"" jump #if_24
				msg &cYou cannot craft {blocks[{blockID}].name}!
				quit
			#if_24
			call #doCraft|{recipeID}|{craftArgs[1]}
			quit
		#ifnot_10
		if usingWorkbench msg &eWorkbench Recipes:
		if usingWorkbench jump #ifnot_11
			if usingStonecutter msg &eStonecutter Recipes:
			else msg &eRecipes:
		#ifnot_11
		set i 0
		#while_11
			call #checkRecipeAfford|{i}|canAfford
			set ingrediantList
			ifnot canAfford|>|0 jump #if_25
				ifnot isTool({recipes[{i}].output.id}) msg &f> &6{blocks[{recipes[{i}].output.id}].name}&f (x{recipes[{i}].output.count}) &7* {canAfford}
				else msg &f> &6{blocks[{recipes[{i}].output.id}].name}&f ({toollevel[{recipes[{i}].output.count}]}&f)
				set j 0
				#while_12
					set text {recipes[{i}].ingredients[{j}].count} {blocks[{recipes[{i}].ingredients[{j}].id}].name}
					if ingrediantList|=|"" set ingrediantList &f    {text}
					else set ingrediantList {ingrediantList}, {text}
					setadd j 1
				if j|<|{recipes[{i}].ingredients.Length} jump #while_12
				msg {ingrediantList}
			#if_25
			setadd i 1
		if i|<|{recipes.Length} jump #while_11
		msg &eType &a/in craft [name]&e to craft something
		// msg &eTo craft multiple at once, type &a/in craft [name]*<count>
		quit
	#if_22
	set i 0
	msg &eResources:
	#while_13
		ifnot inventory[{i}]|=|0 msg &f> &6{blocks[{i}].name}&f (x{inventory[{i}]})
		setadd i 1
	if i|<|{blocks.Length} jump #while_13
	msg &eTools:
	msg &f> {toollevel[{pickaxe}]} Pickaxe
	msg &f> {toollevel[{axe}]} Axe
	msg &f> {toollevel[{spade}]} Spade
	msg &eType &a/in craft&e to show the crafting menu.
quit

#doCraft
	set recipeID {runArg1}
	set blockID {recipes[{recipeID}].output.id}
	set recipeCount {runArg2}
	set j 0
	#while_14
		set id {recipes[{recipeID}].ingredients[{j}].id}
		set count {recipes[{recipeID}].ingredients[{j}].count}
		setmul count {recipeCount}
		call #take|{id}|{count}
		setadd j 1
	if j|<|{recipes[{recipeID}].ingredients.Length} jump #while_14
	set count {recipes[{recipeID}].output.count}
	setmul count {recipeCount}
	call #give|{blockID}|{count}
	ifnot isTool({blockID}) msg &aCrafted {blocks[{blockID}].name} x{count}
	else msg &aCrafted {toollevel[{count}]} {blocks[{blockID}].name}
quit

#checkRecipeAfford
	set j 0
	set {runArg2} 999
	if recipes[{runArg1}].condition|=|"" jump #ifnot_12
		ifnot {recipes[{runArg1}].condition} set {runArg2} 0
	#ifnot_12
	ifnot isTool({recipes[{runArg1}].output.id}) jump #if_26
		if {recipes[{runArg1}].output.id}|>=|recipes[{runArg1}].output.count set {runArg2} 0
	#if_26
	#while_15
		set id {recipes[{runArg1}].ingredients[{j}].id}
		set count {inventory[{id}]}
		setdiv count {recipes[{runArg1}].ingredients[{j}].count}
		setrounddown count
		if {runArg2}|>|count set {runArg2} {count}
		setadd j 1
	if j|<|{recipes[{runArg1}].ingredients.Length} jump #while_15
quit

#getBlockByName
	set {runArg1}
	if blocks[{runArg2}].name|=|"" jump #ifnot_13
		set {runArg1} {runArg2}
		quit
	#ifnot_13
	set i 0
	#while_16
		ifnot blocks[{i}].name|=|runArg2 jump #if_27
			set {runArg1} {i}
			quit
		#if_27
		setadd i 1
	if i|<|{blocks.Length} jump #while_16
quit

#getRecipeByOutput
	set pname {runArg1}
	set bid {runArg2}
	set c {runArg3}
	set {pname}
	set i 0
	#while_17
		ifnot recipes[{i}].output.id|=|bid jump #if_28
			call #checkRecipeAfford|{i}|canAfford
			ifnot canAfford|>=|c jump #if_29
				set {pname} {i}
				quit
			#if_29
		#if_28
		setadd i 1
	if i|<|{recipes.Length} jump #while_17
quit

#use[61]
	set usingWorkbench true
	call #input|craft
quit

#use[62]
	set usingStonecutter true
	call #input|craft
quit

#use[67]
	if blocks[{PlayerHeldBlock}].campfireLighter|=|"" jump #ifnot_14
		ifnot inventory[{PlayerHeldBlock}]|>|0 jump #if_30
			set SpawnBlock {runArg1} {runArg2} {runArg3}
			call #setblock|68|{runArg1}|{runArg2}|{runArg3}
			call #take|{PlayerHeldBlock}|1
			call #give|{blocks[{PlayerHeldBlock}].campfireLighter}|1
			set DeathSpawn {PlayerCoords} {PlayerYaw} {PlayerPitch}
			setdeathspawn {DeathSpawn}
			msg &fRespawn point set
			quit
		#if_30
	#ifnot_14
	msg &cYou can't light a campfire with that
quit

#use[68]
	set DeathSpawn {PlayerCoords} {PlayerYaw} {PlayerPitch}
	setdeathspawn {DeathSpawn}
	set SpawnBlock {runArg1} {runArg2} {runArg3}
	msg &fRespawn point set
quit

#use[70:80]
#use[68:80]
	ifnot inventory[80]|>|0 jump #if_31
		call #take|80|1
		call #give|70|1
	#if_31
quit

#use[68:12]
	ifnot inventory[12]|>|0 jump #if_32
		call #take|12|1
		call #give|20|1
	#if_32
quit

#use[80:70]
	if inventory[70]|>|0 call #setblock|70|{runArg1}|{runArg2}|{runArg3}
quit

#loot[1]
jump #give|4|1

#loot[2]
jump #give|3|1

#loot[18]
setrandrange sap 1 10
ifnot sap|=|5 quit
jump #give|6|1

#loot[43]
jump #give|44|2

#loot[48]
jump #give|4|1

#loot[67]
call #give|57|1
jump #give|66|3

#loot[63]
setrandrange count 1 4
jump #give|39|{count}

#loot[64]
setrandrange count 1 4
jump #give|40|{count}

#loot[71]
setrandrange count 2 4
jump #give|72|{count}

#loot[74]
jump #give|73|2

#loot[76]
jump #give|75|2

#loot[82]
	// block data contains: grave owner | death time | death message | inventory
	call #getblockdata|data|{x}|{y}|{z}
	if data|=|"" jump #give|82|1
	set canDestroyTombstone false
	if data[0]|=|@p set canDestroyTombstone true
	set timeUntilRob {data[1]}
	setsub timeUntilRob {epochMS}
	if timeUntilRob|<=|0 set canDestroyTombstone true
	ifnot canDestroyTombstone msg * &fThis grave belongs to {data[0]}, you cannot break it!
	ifnot canDestroyTombstone msg * &fCome back 5 minutes after their death however, and it's all yours...
	ifnot canDestroyTombstone set dontDestroyBlock true
	ifnot canDestroyTombstone quit
	setsplit data[3] ,
	set i 0
	#while_18
		if data[3][{i}]|>|0 call #give|{i}|{data[3][{i}]}
		if data[3][{i}]|>|0 msg &a+{data[3][{i}]} {blocks[{i}].name}
		setadd i 1
	if i|<|data[3].Length jump #while_18
jump #give|82|1

#use[82]
	call #getblockdata|data|{x}|{y}|{z}
	if data|=|"" msg * &fThe tombstone is unreadable...
	if data|=|"" quit
	msg * &fThe following is engraved on the tombstone:
	msg {data[2]}
quit

#loot[20]
#loot[50]
#loot[54]
#loot[60]
#loot[68]
#loot[69]
quit

#blocktick[1]
	if debug msg I am a block of stone at X: {runArg1}, Y: {runArg2}, Z: {runArg3}!
quit

#initStructs
set blocks.Length 84
set blocks[0].id 0
set blocks[0].name Air
set blocks[0].nonsolid true
set blocks[0].replaceable true
set blocks[0].unbreakable true
set blocks[10].catchFire true
set blocks[10].damage 6
set blocks[10].damageType lava
set blocks[10].fluid true
set blocks[10].id 10
set blocks[10].level 4
set blocks[10].name Lava
set blocks[10].nonsolid true
set blocks[10].replaceable true
set blocks[10].unbreakable true
set blocks[11].catchFire true
set blocks[11].damage 6
set blocks[11].damageType lava
set blocks[11].fluid true
set blocks[11].id 11
set blocks[11].level 4
set blocks[11].name Still lava
set blocks[11].nonsolid true
set blocks[11].replaceable true
set blocks[11].source true
set blocks[11].unbreakable true
set blocks[12].hardness 3
set blocks[12].id 12
set blocks[12].name Sand
set blocks[12].tooltype spade
set blocks[13].hardness 3
set blocks[13].id 13
set blocks[13].name Gravel
set blocks[13].tooltype spade
set blocks[14].hardness 24
set blocks[14].id 14
set blocks[14].name Gold ore
set blocks[14].tooltype pickaxe
set blocks[14].toughness 3
set blocks[15].hardness 16
set blocks[15].id 15
set blocks[15].name Iron ore
set blocks[15].tooltype pickaxe
set blocks[15].toughness 2
set blocks[16].hardness 12
set blocks[16].id 16
set blocks[16].name Coal ore
set blocks[16].tooltype pickaxe
set blocks[16].toughness 1
set blocks[17].hardness 8
set blocks[17].id 17
set blocks[17].name Log
set blocks[17].tooltype axe
set blocks[18].hardness 2
set blocks[18].id 18
set blocks[18].name Leaves
set blocks[18].tooltype axe
set blocks[19].hardness 3
set blocks[19].id 19
set blocks[19].name Sponge
set blocks[19].tooltype spade
set blocks[1].hardness 8
set blocks[1].id 1
set blocks[1].name Stone
set blocks[1].tooltype pickaxe
set blocks[1].toughness 1
set blocks[20].hardness 2
set blocks[20].id 20
set blocks[20].name Glass
set blocks[20].tooltype pickaxe
set blocks[21].id 21
set blocks[21].name Red
set blocks[22].id 22
set blocks[22].name Orange
set blocks[23].id 23
set blocks[23].name Yellow
set blocks[24].id 24
set blocks[24].name Lime
set blocks[25].id 25
set blocks[25].name Green
set blocks[26].id 26
set blocks[26].name Teal
set blocks[27].id 27
set blocks[27].name Aqua
set blocks[28].id 28
set blocks[28].name Cyan
set blocks[29].id 29
set blocks[29].name Blue
set blocks[2].hardness 3
set blocks[2].id 2
set blocks[2].name Grass
set blocks[2].tooltype spade
set blocks[30].id 30
set blocks[30].name Indigo
set blocks[31].id 31
set blocks[31].name Violet
set blocks[32].id 32
set blocks[32].name Magenta
set blocks[33].id 33
set blocks[33].name Pink
set blocks[34].id 34
set blocks[34].name Black
set blocks[35].id 35
set blocks[35].name Gray
set blocks[36].id 36
set blocks[36].name White
set blocks[37].grounded true
set blocks[37].id 37
set blocks[37].name Dandelion
set blocks[38].grounded true
set blocks[38].id 38
set blocks[38].name Rose
set blocks[39].consume true
set blocks[39].food 1
set blocks[39].grounded true
set blocks[39].id 39
set blocks[39].name Brown mushroom
set blocks[3].hardness 3
set blocks[3].id 3
set blocks[3].name Dirt
set blocks[3].tooltype spade
set blocks[40].consume true
set blocks[40].food 3
set blocks[40].grounded true
set blocks[40].id 40
set blocks[40].name Red mushroom
set blocks[41].hardness 24
set blocks[41].id 41
set blocks[41].name Gold
set blocks[41].tooltype pickaxe
set blocks[41].toughness 3
set blocks[42].hardness 16
set blocks[42].id 42
set blocks[42].name Iron
set blocks[42].tooltype pickaxe
set blocks[42].toughness 2
set blocks[43].hardness 8
set blocks[43].id 43
set blocks[43].name Double slab
set blocks[43].tooltype pickaxe
set blocks[43].toughness 1
set blocks[44].breakScale 1.07 0.57 1.07
set blocks[44].hardness 4
set blocks[44].id 44
set blocks[44].mergeFace AwayY
set blocks[44].mergeInto 43
set blocks[44].merger 44
set blocks[44].name Slab
set blocks[44].nonsolid true
set blocks[44].tooltype pickaxe
set blocks[44].toughness 1
set blocks[45].hardness 6
set blocks[45].id 45
set blocks[45].name Brick
set blocks[45].tooltype pickaxe
set blocks[45].toughness 1
set blocks[46].id 46
set blocks[46].name TNT
set blocks[47].hardness 6
set blocks[47].id 47
set blocks[47].name Bookshelf
set blocks[47].tooltype axe
set blocks[48].hardness 9
set blocks[48].id 48
set blocks[48].name Mossy rocks
set blocks[48].tooltype pickaxe
set blocks[48].toughness 1
set blocks[49].hardness 60
set blocks[49].id 49
set blocks[49].name Obsidian
set blocks[49].tooltype pickaxe
set blocks[49].toughness 8
set blocks[4].hardness 6
set blocks[4].id 4
set blocks[4].name Cobblestone
set blocks[4].tooltype pickaxe
set blocks[4].toughness 1
set blocks[50].hardness 5
set blocks[50].id 50
set blocks[50].name Magma
set blocks[50].remainder 10
set blocks[50].tooltype pickaxe
set blocks[51].hardness 12
set blocks[51].id 51
set blocks[51].name Coal
set blocks[51].tooltype pickaxe
set blocks[51].toughness 1
set blocks[52].hardness 32
set blocks[52].id 52
set blocks[52].name Diamond ore
set blocks[52].tooltype pickaxe
set blocks[52].toughness 3
set blocks[53].hardness 32
set blocks[53].id 53
set blocks[53].name Diamond
set blocks[53].tooltype pickaxe
set blocks[53].toughness 3
set blocks[54].catchFire true
set blocks[54].damage 3
set blocks[54].damageType fire
set blocks[54].grounded true
set blocks[54].id 54
set blocks[54].name Fire
set blocks[55].grounded true
set blocks[55].id 55
set blocks[55].name Gold bar
set blocks[56].grounded true
set blocks[56].id 56
set blocks[56].name Iron bar
set blocks[57].grounded true
set blocks[57].id 57
set blocks[57].name Coal lump
set blocks[58].grounded true
set blocks[58].id 58
set blocks[58].name Diamond gem
set blocks[59].hardness 8
set blocks[59].id 59
set blocks[59].name Stone brick
set blocks[59].tooltype pickaxe
set blocks[59].toughness 1
set blocks[5].hardness 6
set blocks[5].id 5
set blocks[5].name Wood
set blocks[5].tooltype axe
set blocks[60].hardness 3
set blocks[60].id 60
set blocks[60].name Ice
set blocks[60].remainder 8
set blocks[60].tooltype pickaxe
set blocks[61].hardness 8
set blocks[61].id 61
set blocks[61].name Workbench
set blocks[61].tooltype axe
set blocks[62].hardness 8
set blocks[62].id 62
set blocks[62].name Stonecutter
set blocks[62].tooltype pickaxe
set blocks[63].hardness 4
set blocks[63].id 63
set blocks[63].name Brown mushroom top
set blocks[63].tooltype spade
set blocks[64].hardness 4
set blocks[64].id 64
set blocks[64].name Red mushroom top
set blocks[64].tooltype spade
set blocks[65].hardness 8
set blocks[65].id 65
set blocks[65].name Mushroom stem
set blocks[65].tooltype spade
set blocks[66].id 66
set blocks[66].name Stick
set blocks[67].breakScale 0.65 0.5 0.65
set blocks[67].grounded true
set blocks[67].hardness 3
set blocks[67].id 67
set blocks[67].name Campfire
set blocks[67].tooltype axe
set blocks[68].catchFire true
set blocks[68].damage 3
set blocks[68].damageType fire
set blocks[68].grounded true
set blocks[68].id 68
set blocks[68].name Lit campfire
set blocks[68].remainder 67
set blocks[69].hardness 5
set blocks[69].id 69
set blocks[69].name Cobweb
set blocks[69].nonsolid true
set blocks[69].tooltype spade
set blocks[6].grounded true
set blocks[6].id 6
set blocks[6].name Sapling
set blocks[70].campfireLighter 70
set blocks[70].grounded true
set blocks[70].id 70
set blocks[70].name Lit torch
set blocks[71].hardness 2
set blocks[71].id 71
set blocks[71].name Snow
set blocks[71].tooltype spade
set blocks[72].grounded true
set blocks[72].id 72
set blocks[72].name Snow ball
set blocks[73].breakScale 1.07 0.57 1.07
set blocks[73].hardness 3
set blocks[73].id 73
set blocks[73].mergeFace AwayY
set blocks[73].mergeInto 74
set blocks[73].merger 73
set blocks[73].name Wood slab
set blocks[73].nonsolid true
set blocks[73].tooltype axe
set blocks[74].hardness 6
set blocks[74].id 74
set blocks[74].name Double wood slab
set blocks[74].tooltype axe
set blocks[75].breakScale 1.07 0.57 1.07
set blocks[75].hardness 3
set blocks[75].id 75
set blocks[75].mergeFace AwayY
set blocks[75].mergeInto 76
set blocks[75].merger 75
set blocks[75].name Cobblestone slab
set blocks[75].nonsolid true
set blocks[75].tooltype pickaxe
set blocks[75].touchness 1
set blocks[76].hardness 6
set blocks[76].id 76
set blocks[76].name Double cobblestone slab
set blocks[76].tooltype pickaxe
set blocks[76].touchness 1
set blocks[77].grounded true
set blocks[77].id 77
set blocks[77].name Bread
set blocks[78].grounded true
set blocks[78].id 78
set blocks[78].name Flax
set blocks[79].grounded true
set blocks[79].id 79
set blocks[79].name Wheat
set blocks[7].id 7
set blocks[7].name Bedrock
set blocks[7].unbreakable true
set blocks[80].campfireLighter 70
set blocks[80].grounded true
set blocks[80].id 80
set blocks[80].name Torch
set blocks[81].breakScale 1.07 0.57 1.07
set blocks[81].hardness 6
set blocks[81].id 81
set blocks[81].name Compost pit
set blocks[81].nonsolid true
set blocks[81].tooltype pickaxe
set blocks[82].breakScale 0.8 0.93 0.3
set blocks[82].grounded true
set blocks[82].hardness 4
set blocks[82].id 82
set blocks[82].name Tombstone
set blocks[83].hardness 8
set blocks[83].id 83
set blocks[83].name Sign
set blocks[83].tooltype axe
set blocks[8].extinguishFire true
set blocks[8].fluid true
set blocks[8].id 8
set blocks[8].level 8
set blocks[8].name Water
set blocks[8].nonsolid true
set blocks[8].replaceable true
set blocks[8].unbreakable true
set blocks[9].extinguishFire true
set blocks[9].fluid true
set blocks[9].id 9
set blocks[9].level 8
set blocks[9].name Still water
set blocks[9].nonsolid true
set blocks[9].replaceable true
set blocks[9].source true
set blocks[9].unbreakable true
set recipes.Length 45
set recipes[0].condition usingWorkbench
set recipes[0].ingredients.Length 2
set recipes[0].ingredients[0].count 3
set recipes[0].ingredients[0].id 58
set recipes[0].ingredients[1].count 2
set recipes[0].ingredients[1].id 66
set recipes[0].output.count 8
set recipes[0].output.id pickaxe
set recipes[10].condition usingWorkbench
set recipes[10].ingredients.Length 2
set recipes[10].ingredients[0].count 3
set recipes[10].ingredients[0].id 4
set recipes[10].ingredients[1].count 2
set recipes[10].ingredients[1].id 66
set recipes[10].output.count 2
set recipes[10].output.id axe
set recipes[11].condition usingWorkbench
set recipes[11].ingredients.Length 2
set recipes[11].ingredients[0].count 1
set recipes[11].ingredients[0].id 4
set recipes[11].ingredients[1].count 2
set recipes[11].ingredients[1].id 66
set recipes[11].output.count 2
set recipes[11].output.id spade
set recipes[12].condition usingWorkbench
set recipes[12].ingredients.Length 2
set recipes[12].ingredients[0].count 3
set recipes[12].ingredients[0].id 5
set recipes[12].ingredients[1].count 2
set recipes[12].ingredients[1].id 66
set recipes[12].output.count 1
set recipes[12].output.id pickaxe
set recipes[13].condition usingWorkbench
set recipes[13].ingredients.Length 2
set recipes[13].ingredients[0].count 3
set recipes[13].ingredients[0].id 5
set recipes[13].ingredients[1].count 2
set recipes[13].ingredients[1].id 66
set recipes[13].output.count 1
set recipes[13].output.id axe
set recipes[14].condition usingWorkbench
set recipes[14].ingredients.Length 2
set recipes[14].ingredients[0].count 1
set recipes[14].ingredients[0].id 5
set recipes[14].ingredients[1].count 2
set recipes[14].ingredients[1].id 66
set recipes[14].output.count 1
set recipes[14].output.id spade
set recipes[15].ingredients.Length 1
set recipes[15].ingredients[0].count 1
set recipes[15].ingredients[0].id 17
set recipes[15].output.count 4
set recipes[15].output.id 5
set recipes[16].ingredients.Length 1
set recipes[16].ingredients[0].count 1
set recipes[16].ingredients[0].id 65
set recipes[16].output.count 2
set recipes[16].output.id 5
set recipes[17].ingredients.Length 1
set recipes[17].ingredients[0].count 2
set recipes[17].ingredients[0].id 5
set recipes[17].output.count 4
set recipes[17].output.id 66
set recipes[18].ingredients.Length 1
set recipes[18].ingredients[0].count 4
set recipes[18].ingredients[0].id 5
set recipes[18].output.count 1
set recipes[18].output.id 61
set recipes[19].ingredients.Length 2
set recipes[19].ingredients[0].count 1
set recipes[19].ingredients[0].id 66
set recipes[19].ingredients[1].count 1
set recipes[19].ingredients[1].id 57
set recipes[19].output.count 4
set recipes[19].output.id 80
set recipes[1].condition usingWorkbench
set recipes[1].ingredients.Length 2
set recipes[1].ingredients[0].count 3
set recipes[1].ingredients[0].id 58
set recipes[1].ingredients[1].count 2
set recipes[1].ingredients[1].id 66
set recipes[1].output.count 8
set recipes[1].output.id axe
set recipes[20].ingredients.Length 2
set recipes[20].ingredients[0].count 3
set recipes[20].ingredients[0].id 66
set recipes[20].ingredients[1].count 1
set recipes[20].ingredients[1].id 57
set recipes[20].output.count 1
set recipes[20].output.id 67
set recipes[21].ingredients.Length 1
set recipes[21].ingredients[0].count 4
set recipes[21].ingredients[0].id 4
set recipes[21].output.count 1
set recipes[21].output.id 62
set recipes[22].condition usingStonecutter
set recipes[22].ingredients.Length 1
set recipes[22].ingredients[0].count 1
set recipes[22].ingredients[0].id 16
set recipes[22].output.count 1
set recipes[22].output.id 57
set recipes[23].condition usingStonecutter
set recipes[23].ingredients.Length 1
set recipes[23].ingredients[0].count 1
set recipes[23].ingredients[0].id 15
set recipes[23].output.count 1
set recipes[23].output.id 56
set recipes[24].condition usingStonecutter
set recipes[24].ingredients.Length 1
set recipes[24].ingredients[0].count 1
set recipes[24].ingredients[0].id 14
set recipes[24].output.count 1
set recipes[24].output.id 55
set recipes[25].condition usingStonecutter
set recipes[25].ingredients.Length 1
set recipes[25].ingredients[0].count 1
set recipes[25].ingredients[0].id 52
set recipes[25].output.count 1
set recipes[25].output.id 58
set recipes[26].condition usingWorkbench
set recipes[26].ingredients.Length 1
set recipes[26].ingredients[0].count 9
set recipes[26].ingredients[0].id 57
set recipes[26].output.count 1
set recipes[26].output.id 51
set recipes[27].condition usingStonecutter
set recipes[27].ingredients.Length 1
set recipes[27].ingredients[0].count 1
set recipes[27].ingredients[0].id 51
set recipes[27].output.count 9
set recipes[27].output.id 57
set recipes[28].condition usingWorkbench
set recipes[28].ingredients.Length 1
set recipes[28].ingredients[0].count 9
set recipes[28].ingredients[0].id 56
set recipes[28].output.count 1
set recipes[28].output.id 42
set recipes[29].condition usingStonecutter
set recipes[29].ingredients.Length 1
set recipes[29].ingredients[0].count 1
set recipes[29].ingredients[0].id 42
set recipes[29].output.count 9
set recipes[29].output.id 56
set recipes[2].condition usingWorkbench
set recipes[2].ingredients.Length 2
set recipes[2].ingredients[0].count 1
set recipes[2].ingredients[0].id 58
set recipes[2].ingredients[1].count 2
set recipes[2].ingredients[1].id 66
set recipes[2].output.count 8
set recipes[2].output.id spade
set recipes[30].condition usingWorkbench
set recipes[30].ingredients.Length 1
set recipes[30].ingredients[0].count 9
set recipes[30].ingredients[0].id 55
set recipes[30].output.count 1
set recipes[30].output.id 41
set recipes[31].condition usingStonecutter
set recipes[31].ingredients.Length 1
set recipes[31].ingredients[0].count 1
set recipes[31].ingredients[0].id 41
set recipes[31].output.count 9
set recipes[31].output.id 55
set recipes[32].condition usingWorkbench
set recipes[32].ingredients.Length 1
set recipes[32].ingredients[0].count 9
set recipes[32].ingredients[0].id 58
set recipes[32].output.count 1
set recipes[32].output.id 53
set recipes[33].condition usingStonecutter
set recipes[33].ingredients.Length 1
set recipes[33].ingredients[0].count 1
set recipes[33].ingredients[0].id 53
set recipes[33].output.count 9
set recipes[33].output.id 58
set recipes[34].ingredients.Length 1
set recipes[34].ingredients[0].count 4
set recipes[34].ingredients[0].id 72
set recipes[34].output.count 1
set recipes[34].output.id 71
set recipes[35].ingredients.Length 1
set recipes[35].ingredients[0].count 1
set recipes[35].ingredients[0].id 71
set recipes[35].output.count 4
set recipes[35].output.id 72
set recipes[36].ingredients.Length 1
set recipes[36].ingredients[0].count 4
set recipes[36].ingredients[0].id 39
set recipes[36].output.count 1
set recipes[36].output.id 63
set recipes[37].ingredients.Length 1
set recipes[37].ingredients[0].count 1
set recipes[37].ingredients[0].id 63
set recipes[37].output.count 4
set recipes[37].output.id 39
set recipes[38].ingredients.Length 1
set recipes[38].ingredients[0].count 4
set recipes[38].ingredients[0].id 40
set recipes[38].output.count 1
set recipes[38].output.id 64
set recipes[39].ingredients.Length 1
set recipes[39].ingredients[0].count 1
set recipes[39].ingredients[0].id 64
set recipes[39].output.count 4
set recipes[39].output.id 40
set recipes[3].condition usingWorkbench
set recipes[3].ingredients.Length 2
set recipes[3].ingredients[0].count 3
set recipes[3].ingredients[0].id 55
set recipes[3].ingredients[1].count 2
set recipes[3].ingredients[1].id 66
set recipes[3].output.count 6
set recipes[3].output.id pickaxe
set recipes[40].condition usingWorkbench
set recipes[40].ingredients.Length 1
set recipes[40].ingredients[0].count 3
set recipes[40].ingredients[0].id 5
set recipes[40].output.count 6
set recipes[40].output.id 73
set recipes[41].condition usingStonecutter
set recipes[41].ingredients.Length 1
set recipes[41].ingredients[0].count 3
set recipes[41].ingredients[0].id 4
set recipes[41].output.count 6
set recipes[41].output.id 75
set recipes[42].condition usingStonecutter
set recipes[42].ingredients.Length 1
set recipes[42].ingredients[0].count 3
set recipes[42].ingredients[0].id 1
set recipes[42].output.count 6
set recipes[42].output.id 44
set recipes[43].condition usingStonecutter
set recipes[43].ingredients.Length 1
set recipes[43].ingredients[0].count 4
set recipes[43].ingredients[0].id 4
set recipes[43].output.count 3
set recipes[43].output.id 1
set recipes[44].condition usingStonecutter
set recipes[44].ingredients.Length 1
set recipes[44].ingredients[0].count 4
set recipes[44].ingredients[0].id 1
set recipes[44].output.count 4
set recipes[44].output.id 59
set recipes[4].condition usingWorkbench
set recipes[4].ingredients.Length 2
set recipes[4].ingredients[0].count 3
set recipes[4].ingredients[0].id 55
set recipes[4].ingredients[1].count 2
set recipes[4].ingredients[1].id 66
set recipes[4].output.count 6
set recipes[4].output.id axe
set recipes[5].condition usingWorkbench
set recipes[5].ingredients.Length 2
set recipes[5].ingredients[0].count 1
set recipes[5].ingredients[0].id 55
set recipes[5].ingredients[1].count 2
set recipes[5].ingredients[1].id 66
set recipes[5].output.count 6
set recipes[5].output.id spade
set recipes[6].condition usingWorkbench
set recipes[6].ingredients.Length 2
set recipes[6].ingredients[0].count 3
set recipes[6].ingredients[0].id 56
set recipes[6].ingredients[1].count 2
set recipes[6].ingredients[1].id 66
set recipes[6].output.count 3
set recipes[6].output.id pickaxe
set recipes[7].condition usingWorkbench
set recipes[7].ingredients.Length 2
set recipes[7].ingredients[0].count 3
set recipes[7].ingredients[0].id 56
set recipes[7].ingredients[1].count 2
set recipes[7].ingredients[1].id 66
set recipes[7].output.count 3
set recipes[7].output.id axe
set recipes[8].condition usingWorkbench
set recipes[8].ingredients.Length 2
set recipes[8].ingredients[0].count 1
set recipes[8].ingredients[0].id 56
set recipes[8].ingredients[1].count 2
set recipes[8].ingredients[1].id 66
set recipes[8].output.count 3
set recipes[8].output.id spade
set recipes[9].condition usingWorkbench
set recipes[9].ingredients.Length 2
set recipes[9].ingredients[0].count 3
set recipes[9].ingredients[0].id 4
set recipes[9].ingredients[1].count 2
set recipes[9].ingredients[1].id 66
set recipes[9].output.count 2
set recipes[9].output.id pickaxe
set toollevel.Length 3
set toollevel[0] &cNo
set toollevel[1] &sWooden
set toollevel[2] &7Stone
set toollevel[3] &fIron
set toollevel[6] &6Golden
set toollevel[8] &bDiamond
set deathmessages.burn @color@nick&f was burnt to a crisp
set deathmessages.drown @color@nick&f ran out of air
set deathmessages.explosion @color@nick&f blew up
set deathmessages.fall @color@nick&f hit the ground too hard
set deathmessages.fire @color@nick&f went up in flames
set deathmessages.freeze @color@nick&f froze to death
set deathmessages.lava @color@nick&f tried to swim in lava
set deathmessages.magma @color@nick&f discovered the floor was lava
set deathmessages.suffocation @color@nick&f suffocated in a wall
set deathmessages.unknown @color@nick&f lost their life to unknown forces
set saveformat.Length 12
set saveformat[0] .
set saveformat[10] SpawnBlock
set saveformat[11] HeldBlock
set saveformat[1] PlayerPos
set saveformat[2] pickaxe
set saveformat[3] axe
set saveformat[4] spade
set saveformat[5] hp
set saveformat[6] maxhp
set saveformat[7] fireticks
set saveformat[8] inventory
set saveformat[9] DeathSpawn
quit