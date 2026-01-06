using local_packages
using no_runarg_underscore_conversion

#onJoin
	ifnot LevelName|has|"bravelycowering+" jump #unregistered-hypercam-2

	set allowMapChanges false
	if LevelName|=|"bravelycowering+survival" set allowMapChanges true

	if allowMapChanges call #initBlacklist
	ifnot blacklist.@p|=|"" jump #blacklisted
	clickevent sync register #click
	reach 4

	cpemsg bigannounce Check &a/in rules

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

	env cloudheight 144
	env shadow 505050

	set LevelXMax {LevelX}
	setsub LevelXMax 1
	set LevelYMax {LevelY}
	setsub LevelYMax 1
	set LevelZMax {LevelZ}
	setsub LevelZMax 1

	set RandomTickSpeed 0

	include initinventory
	setsplit inventory ,

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

#unregistered-hypercam-2
	menumsg bigannounce &4Unregistered Hypercam 2
quit

#blacklisted
	setrandlist msg You can look, but you can't touch!|Mistakes were made!|And you made it everyone else's problem.|Not my problem anymore!|Holy smokes, read the rules!
	cpemsg announce &c{msg}
	menumsg smallannounce Blacklist Reason: &c{blacklist.@p}
quit

#rules
	msg &eMap Rules:
	msg 1. &mNo&u major griefing &7(minor grief is fine, don't make it everyone's problem)&u.
	msg 2. &mNo&u abusing exploits or intentionally crashing the script &7(if you find a bug, tell me!)&u.
	msg 3. &uFollow the server &a/rules&u where applicable.
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
	msg &fChanges in the latest minor version:
	msg - Various bugfixes
	msg - There is now a build blacklist
	// msg - Saplings now grow over time
	// msg - Dirt will slowly grow back into grass if placed next to other grass
	// msg - Grass will slowly turn into dirt under other blocks
	// msg - Ores in generation have a much different distribution: diamonds are rarer and found in specific places
	// msg - Progress now saves every 5 seconds
#version
	msg &fVersion &a0.3.26
quit

function #initSave
	localname msg
	localname break
	local x 0
	local z 0
	local prefix /nothing2 @p
	while if *x|<|LevelX
		while if *z|<|LevelZ
			setblockmessage *msg {x} 0 {z}
			if *msg|=|"" then
				// set save slot and claim block
				set saveSlot {x} 0 {z}
				placemessageblock 7 {saveSlot} /nothing2 @p
				quit
			end
			if *msg|has|*prefix then
				// set save slot and load from it
				set saveSlot {x} 0 {z}
				jump #load
			end
			setadd *z 1
		end
		setadd *x 1
	end
end

function #save
	if saveSlot|=|"" quit
	set PlayerPos {PlayerCoordsPrecise} {PlayerYaw} {PlayerPitch}
	set HeldBlock {PlayerHeldBlock}
	include savestring
end

function #load
	if saveSlot|=|"" quit
	localname loaddata
	setblockmessage *loaddata {saveSlot}
	setsplit *loaddata |
	local i 1
	ifnot *i|<|saveformat.Length quit
	while if *i|<|*loaddata.Length
		set {saveformat[{i}]} {*loaddata[{i}]}
		setadd *i 1
	end
	setsplit inventory ,
	ifnot PlayerPos|=|"" cmd tpp {PlayerPos}
	ifnot HeldBlock|=|"" cmd holdsilent {HeldBlock}
end

// checks against humanoid hitbox (-0.25 to 0.21875)
function #setstandingon
	localname exitfalse
	local package {runArg1}
	local blockfield {runArg2}
	local comp {runArg3}
	local blockvalue {runArg4}
	set {package} true
	// package, blockfield, comp, blockvalue
	local coords {PlayerCoordsDecimal}
	setsplit *coords " "
	if *coords[1]|!=|PlayerY jump #*exitfalse
	setsub *coords[1] 0.03125
	local y {*coords[1]}
	setrounddown *y

	// add 0.21875 here instead of subtracting 0.25 because its 0.46875 off
	setadd *coords[0] 0.21875
	local x {*coords[0]}
	setrounddown *x
	setadd *coords[2] 0.21875
	local z {*coords[2]}
	setrounddown *z
	localname id
	call #getblock|*id|{x}|{y}|{z}
	if blocks[{id}].{blockfield}|{comp}|{blockvalue} quit

	setadd *coords[0] 0.5
	set *x {*coords[0]}
	setrounddown *x
	call #getblock|*id|{x}|{y}|{z}
	if blocks[{id}].{blockfield}|{comp}|{blockvalue} quit

	setsub *coords[0] 0.5
	set *x {*coords[0]}
	setrounddown *x
	setadd *coords[2] 0.5
	set *z {*coords[2]}
	setrounddown *z
	call #getblock|*id|{x}|{y}|{z}
	if blocks[{id}].{blockfield}|{comp}|{blockvalue} quit

	setadd *coords[0] 0.5
	set *x {*coords[0]}
	setrounddown *x
	call #getblock|*id|{x}|{y}|{z}
	if blocks[{id}].{blockfield}|{comp}|{blockvalue} quit
	
	#*exitfalse
	set {package} false
end

function #setdist
	// package, x1, y1, z1, x2, y2, z2
	local a {runArg5}
	setsub *a {runArg2}
	setmul *a {a}
	local b {runArg6}
	setsub *b {runArg3}
	setmul *b {b}
	local c {runArg7}
	setsub *c {runArg4}
	setmul *c {c}
	setadd *a {b}
	setadd *a {c}
	setsqrt {runArg1} {a}
end

function #tick
	localname PrevPlayerCoords
	localname prevhp
	localname myblock
	ifnot saveSlot|=|"" setsub autosave 1
	if autosave|<|0 call #save
	if autosave|<|0 set autosave 50
	call #getblock|*myblock|{PlayerX}|{PlayerY}|{PlayerZ}
	if blocks[{myblock}].catchFire then
		set fireticks 100
		cpemsg smallannounce &6▐▐▐▐▐▐▐▐▐▐
	end
	if blocks[{myblock}].extinguishFire then
		if fireticks|>|0 then
			gui barSize 0
			set fireticks 0
		end
	end
	ifnot blocks[{myblock}].damage|=|"" call #damage|{blocks[{myblock}].damage}|{blocks[{myblock}].damageType}
	ifnot PlayerCoords|=|*PrevPlayerCoords set usingWorkbench false
	ifnot PlayerCoords|=|*PrevPlayerCoords set usingStonecutter false
	set *PrevPlayerCoords {PlayerCoords}
	delay 100
	if debug cpemsg top1 {actionCount}/60000
	ifnot hp|=|*prevhp then
		set *prevhp {hp}
		localname hpbar
		call #makebar|*hpbar|c|{hp}|{maxhp}
		cpemsg bot1 &c♥ {hpbar}
	end
	if inventory[{PlayerHeldBlock}]|>|0 cpemsg bot2 Holding: &6{blocks[{PlayerHeldBlock}].name} &f(x{inventory[{PlayerHeldBlock}]})
	else cpemsg bot2 Holding: &cNothing
	cpemsg bot3 {toollevel[{pickaxe}]} Pickaxe &f| {toollevel[{axe}]} Axe &f| {toollevel[{spade}]} Spade
	if iframes|>|0 then
		setsub iframes 1
		ifnot iframes|<|2 gui barColor #ff0000 0.25
		if iframes|<|2 gui barSize 0
		else gui barSize 1
	end
	if fireticks|>|0 then
		setsub fireticks 1
		local *firetickmod {fireticks}
		setmod *firetickmod 10
		if *firetickmod|=|0 then
			if fireticks|>|0 then
				localname temp
				set *temp {fireticks}
				setdiv *temp 10
				localname firebar
				call #makecharbar|*firebar|▐|6|{temp}|10
				cpemsg smallannounce {firebar}
			end
			ifnot fireticks|>|0 cpemsg smallannounce
			call #damage|2|burn
		end
	end
	if RandomTickSpeed|>|0 then
		set RandomTicks {RandomTickSpeed}
		#randomticks
			if actionCount|>=|60000 cmd oss #randomticks repeatable
			if actionCount|>|60000 terminate
			setsub RandomTicks 1
			// random tick
			localname x
			setrandrange *x 0 {LevelXMax}
			localname y
			setrandrange *y 0 {LevelYMax}
			localname z
			setrandrange *z 0 {LevelZMax}
			localname id
			setblockid *id {x} {y} {z}
			if label #blocktick[{id}] call #blocktick[{id}]|{x}|{y}|{z}
		if RandomTicks|>|0 jump #randomticks
	end
	if actionCount|>=|60000 cmd oss #tick repeatable
	if actionCount|>|60000 terminate
	jump #tick
end

#grow
	cmd brush replace
	cmd outline {runArg1} up 0 {runArg2}
	cmd ma
	cmd brush normal
quit

#generate
	// get seed
	set RandomTickSpeed 0
	call #generate.setupCommands
	replysilent 1|Start generating!|#generate.start
	quit
	#generate.start
	msg Generating
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
	cmd m {LevelX} 64 {LevelY}
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
	// coal
	cmd replacebrush 1 cloudy 1/75 16 f=1.5 o=2
	cmd ma
	// iron
	cmd replacebrush 1 cloudy 1/200 15 f=2 o=4 a=3 l=1.5
	cmd m 0 0 0
	cmd m {LevelX} 70 {LevelZ}
	// gold concentrate
	cmd replacebrush 1 cloudy 1/75 14 f=1.5 o=5
	cmd m 0 16 0
	cmd m {LevelX} 42 {LevelZ}
	// gold
	cmd replacebrush 1 random 1/999 14
	cmd ma
	// diamond
	cmd replacebrush 1 random 1/1499 52
	cmd m 0 0 0
	cmd m {LevelX} 20 {LevelZ}
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
	ifnot SpawnBlock|=|"none" then
		setsplit SpawnBlock " "
		call #getblock|spawnblockid|{SpawnBlock[0]}|{SpawnBlock[1]}|{SpawnBlock[2]}
		if spawnblockid|!=|68 then
			set SpawnBlock none
			set DeathSpawn {WorldSpawn}
			setdeathspawn {DeathSpawn}
		end
	end
	set deathY {PlayerY}
	call #setblock|82|{PlayerX}|{deathY}|{PlayerZ}
	include setinvstring
	call #setblockdata|{PlayerX}|{deathY}|{PlayerZ}|@p|{epochMS}|* &f{deathmsg}|{inventory}
	setsub deathY 1
	call #getblock|id|{PlayerX}|{deathY}|{PlayerZ}
	if blocks[{id}].nonsolid call #setblock|3|{PlayerX}|{deathY}|{PlayerZ}
	if allowMapChanges kill {deathmsg}
	else kill
	set fireticks 0
	set hp {maxhp}
	cpemsg bigannounce &cYou Died!
	cpemsg smallannounce {deathmsg}
	include initinventory
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
	if minetimer|>|0 then
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
	end
	set minepos
	jump #destroyblock|{x}|{y}|{z}|{toomuch}
quit

#destroyblock
	set x {runArg1}
	set y {runArg2}
	set z {runArg3}
	set toomuch {runArg4}
	call #getblock|id|{x}|{y}|{z}
	ifnot toomuch then
		set dontDestroyBlock false
		if label #loot[{id}] call #loot[{id}]
		else call #give|{id}|1
		if dontDestroyBlock quit
	end
	if blocks[{id}].remainder|=|"" set empty 0
	else set empty {blocks[{id}].remainder}
	call #setblock|{empty}|{x}|{y}|{z}
	setadd y 1
	call #getblock|id|{x}|{y}|{z}
	if blocks[{id}].grounded jump #destroyblock|{x}|{y}|{z}|false
quit

#give
	if isTool({runArg1}) then
		set {runArg1} {runArg2}
		quit
	end
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
	while if i|<|{blocks.Length}
		set inventory[{i}] 9999
		setadd i 1
	end
quit

#clearall
	set pickaxe 0
	set axe 0
	set spade 0
	set i 0
	while if i|<|{blocks.Length}
		set inventory[{i}] 0
		setadd i 1
	end
quit

#place
	set x {runArg1}
	set y {runArg2}
	set z {runArg3}
	call #getblock|id|{x}|{y}|{z}
	if label #use[{id}:{PlayerHeldBlock}] jump #use[{id}:{PlayerHeldBlock}]|{x}|{y}|{z}
	if label #use[{id}] jump #use[{id}]|{x}|{y}|{z}
	ifnot blocks[{PlayerHeldBlock}].replaceable then
		ifnot inventory[{PlayerHeldBlock}]|>|0 msg &cYou don't have any &f{blocks[{PlayerHeldBlock}].name}!
	end
	ifnot inventory[{PlayerHeldBlock}]|>|0 quit
	if blocks[{id}].replaceable quit
	ifnot blocks[{id}].mergeInto|=|"" then
		if PlayerHeldBlock|=|blocks[{id}].merger then
			if blocks[{id}].mergeFace|=|click.face then
				call #take|{playerHeldBlock}|1
				jump #setblock|{blocks[{id}].mergeInto}|{x}|{y}|{z}
				quit
			end
		end
	end
	if click.face|=|"AwayX" setadd x 1
	if click.face|=|"AwayY" setadd y 1
	if click.face|=|"AwayZ" setadd z 1
	if click.face|=|"TowardsX" setsub x 1
	if click.face|=|"TowardsY" setsub y 1
	if click.face|=|"TowardsZ" setsub z 1
	call #getblock|id|{x}|{y}|{z}
	ifnot blocks[{id}].mergeInto|=|"" then
		if PlayerHeldBlock|=|blocks[{id}].merger then
			call #take|{playerHeldBlock}|1
			jump #setblock|{blocks[{id}].mergeInto}|{x}|{y}|{z}
			quit
		end
	end
	ifnot blocks[{id}].replaceable quit
	if blocks[{PlayerHeldBlock}].grounded then
		setsub y 1
		call #getblock|id|{x}|{y}|{z}
		if blocks[{id}].nonsolid quit
		setadd y 1
	end
	call #take|{playerHeldBlock}|1
	jump #setblock|{PlayerHeldBlock}|{x}|{y}|{z}
quit

#itemuse
	ifnot blocks[{PlayerHeldBlock}].food|=|"" then
		ifnot inventory[{PlayerHeldBlock}]|>|0 msg &cYou don't have any &f{blocks[{PlayerHeldBlock}].name}!
		ifnot inventory[{PlayerHeldBlock}]|>|0 quit
		if hp|<|maxhp then
			call #take|{playerHeldBlock}|1
			call #heal|{blocks[{PlayerHeldBlock}].food}
		end
	end
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
	setblockid id {runArg2} {runArg3} {runArg4}
	if id|=|65535 quit
	ifnot allowMapChanges then
		tempblock {runArg1} {runArg2} {runArg3} {runArg4}
		set world[{runArg2},{runArg3},{runArg4}] {runArg1}
		set world[{runArg2},{runArg3},{runArg4}].msg
		quit
	end
	placemessageblock {runArg1} {runArg2} {runArg3} {runArg4}
quit

#setblockif
	setblockid id {runArg2} {runArg3} {runArg4}
	ifnot blocks[{id}].{runArg5} quit
	ifnot allowMapChanges then
		tempblock {runArg1} {runArg2} {runArg3} {runArg4}
		set world[{runArg2},{runArg3},{runArg4}] {runArg1}
		set world[{runArg2},{runArg3},{runArg4}].msg
		quit
	end
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
	ifnot runArg5|=|"" then
		local i 5
		while ifnot runArg{i}|=|""
			set msg {msg}|/nothing2 {runArg{i}}
			setadd *i 1
		end
	end
	setblockid id {runArg1} {runArg2} {runArg3}
	ifnot allowMapChanges set world[{runArg1},{runArg2},{runArg3}].msg {msg}
	else placemessageblock {id} {runArg1} {runArg2} {runArg3} {msg}
quit

#makebar
// package, color, amount, max
	set i 0
	set {runArg1} &{runArg2}
	if i|<|{runArg3} then
		while if i|<|{runArg3}
			set {runArg1} {{runArg1}}|
			setadd i 1
		end
	end
	set {runArg1} {{runArg1}}&0
	if i|<|{runArg4} then
		while if i|<|{runArg4}
			set {runArg1} {{runArg1}}|
			setadd i 1
		end
	end
quit

#makecharbar
// package, char, color, amount, max
	set i 0
	set {runArg1} &{runArg3}
	if i|<|{runArg4} then
		while if i|<|{runArg4}
			set {runArg1} {{runArg1}}{runArg2}
			setadd i 1
		end
	end
	set {runArg1} {{runArg1}}&0
	if i|<|{runArg5} then
		while if i|<|{runArg5}
			set {runArg1} {{runArg1}}{runArg2}
			setadd i 1
		end
	end
quit

#input
	if runArg1|=|"changes" jump #changelog
	if runArg1|=|"rules" jump #rules
	if runArg1|=|"craft" then
		set craftArgs {runArg2}
		ifnot craftArgs|=|"" then
			set craftArgs[1] 1
			setsplit craftArgs *
			if isTool({craftArgs[0]}) set craftArgs[1] 1
			call #getBlockByName|blockID|{craftArgs[0]}
			if blockID|=|"" then
				msg &cInvalid item name or ID
				quit
			end
			call #getRecipeByOutput|recipeID|{blockID}|{craftArgs[1]}
			if recipeID|=|"" then
				msg &cYou cannot craft {blocks[{blockID}].name}!
				quit
			end
			call #doCraft|{recipeID}|{craftArgs[1]}
			quit
		end
		if usingWorkbench msg &eWorkbench Recipes:
		ifnot usingWorkbench then
			if usingStonecutter msg &eStonecutter Recipes:
			else msg &eRecipes:
		end
		set i 0
		while if i|<|{recipes.Length}
			call #checkRecipeAfford|{i}|canAfford
			set ingrediantList
			if canAfford|>|0 then
				ifnot isTool({recipes[{i}].output.id}) msg &f> &6{blocks[{recipes[{i}].output.id}].name}&f (x{recipes[{i}].output.count}) &7* {canAfford}
				else msg &f> &6{blocks[{recipes[{i}].output.id}].name}&f ({toollevel[{recipes[{i}].output.count}]}&f)
				set j 0
				while if j|<|{recipes[{i}].ingredients.Length}
					set text {recipes[{i}].ingredients[{j}].count} {blocks[{recipes[{i}].ingredients[{j}].id}].name}
					if ingrediantList|=|"" set ingrediantList &f    {text}
					else set ingrediantList {ingrediantList}, {text}
					setadd j 1
				end
				msg {ingrediantList}
			end
			setadd i 1
		end
		msg &eType &a/in craft [name]&e to craft something
		// msg &eTo craft multiple at once, type &a/in craft [name]*<count>
		quit
	end
	set i 0
	msg &eResources:
	while if i|<|{blocks.Length}
		ifnot inventory[{i}]|=|0 msg &f> &6{blocks[{i}].name}&f (x{inventory[{i}]})
		setadd i 1
	end
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
	while if j|<|{recipes[{recipeID}].ingredients.Length}
		set id {recipes[{recipeID}].ingredients[{j}].id}
		set count {recipes[{recipeID}].ingredients[{j}].count}
		setmul count {recipeCount}
		call #take|{id}|{count}
		setadd j 1
	end
	set count {recipes[{recipeID}].output.count}
	setmul count {recipeCount}
	call #give|{blockID}|{count}
	ifnot isTool({blockID}) msg &aCrafted {blocks[{blockID}].name} x{count}
	else msg &aCrafted {toollevel[{count}]} {blocks[{blockID}].name}
quit

#checkRecipeAfford
	set j 0
	set {runArg2} 999
	ifnot recipes[{runArg1}].condition|=|"" then
		ifnot {recipes[{runArg1}].condition} set {runArg2} 0
	end
	if isTool({recipes[{runArg1}].output.id}) then
		if {recipes[{runArg1}].output.id}|>=|recipes[{runArg1}].output.count set {runArg2} 0
	end
	while if j|<|{recipes[{runArg1}].ingredients.Length}
		set id {recipes[{runArg1}].ingredients[{j}].id}
		set count {inventory[{id}]}
		setdiv count {recipes[{runArg1}].ingredients[{j}].count}
		setrounddown count
		if {runArg2}|>|count set {runArg2} {count}
		setadd j 1
	end
quit

#getBlockByName
	set {runArg1}
	ifnot blocks[{runArg2}].name|=|"" then
		set {runArg1} {runArg2}
		quit
	end
	set i 0
	while if i|<|{blocks.Length}
		if blocks[{i}].name|=|runArg2 then
			set {runArg1} {i}
			quit
		end
		setadd i 1
	end
quit

#getRecipeByOutput
	set pname {runArg1}
	set bid {runArg2}
	set c {runArg3}
	set {pname}
	set i 0
	while if i|<|{recipes.Length}
		if recipes[{i}].output.id|=|bid then
			call #checkRecipeAfford|{i}|canAfford
			if canAfford|>=|c then
				set {pname} {i}
				quit
			end
		end
		setadd i 1
	end
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
	ifnot blocks[{PlayerHeldBlock}].campfireLighter|=|"" then
		if inventory[{PlayerHeldBlock}]|>|0 then
			set SpawnBlock {runArg1} {runArg2} {runArg3}
			call #setblock|68|{runArg1}|{runArg2}|{runArg3}
			call #take|{PlayerHeldBlock}|1
			call #give|{blocks[{PlayerHeldBlock}].campfireLighter}|1
			set DeathSpawn {PlayerCoords} {PlayerYaw} {PlayerPitch}
			setdeathspawn {DeathSpawn}
			msg &fRespawn point set
			quit
		end
	end
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
	if inventory[80]|>|0 then
		call #take|80|1
		call #give|70|1
	end
quit

#use[68:12]
	if inventory[12]|>|0 then
		call #take|12|1
		call #give|20|1
	end
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
	while if i|<|data[3].Length
		if data[3][{i}]|>|0 call #give|{i}|{data[3][{i}]}
		if data[3][{i}]|>|0 msg &a+{data[3][{i}]} {blocks[{i}].name}
		setadd i 1
	end
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

function #blocktick[2]
	local x {runArg1}
	local y {runArg2}
	local z {runArg3}
	localname i
	setadd *y 1
	call #getblock|*i|{x}|{y}|{z}
	setsub *y 1
	ifnot blocks[{i}].nonsolid jump #setblock|3|{x}|{y}|{z}
end

function #blocktick[3]
	local x {runArg1}
	local y {runArg2}
	local z {runArg3}
	localname i
	setadd *y 1
	call #getblock|*i|{x}|{y}|{z}
	setsub *y 1
	ifnot blocks[{i}].nonsolid quit
	if debug msg trying to convert to grass at {x} {y} {z}
	setadd *x 1
	call #getblock|*i|{x}|{y}|{z}
	setadd *x -1
	if *i|=|2 jump #setblock|2|{x}|{y}|{z}
	setsub *x 1
	call #getblock|*i|{x}|{y}|{z}
	setsub *x -1
	if *i|=|2 jump #setblock|2|{x}|{y}|{z}
	setadd *z 1
	call #getblock|*i|{x}|{y}|{z}
	setadd *z -1
	if *i|=|2 jump #setblock|2|{x}|{y}|{z}
	setsub *z 1
	call #getblock|*i|{x}|{y}|{z}
	setsub *z -1
	if *i|=|2 jump #setblock|2|{x}|{y}|{z}
	if debug msg FAILURE
end

#blocktick[6]
jump #growtree|{runArg1}|{runArg2}|{runArg3}

function #growtree
	local x {runArg1}
	local y {runArg2}
	local z {runArg3}
	localname i
	setsub *y 1
	call #getblock|*i|{x}|{y}|{z}
	ifnot blocks[{i}].soil quit
	call #setblock|3|{x}|{y}|{z}
	setadd *y 1
	setrandrange *i 1 3
	while if *i|>|0
		call #setblockif|17|{x}|{y}|{z}|growreplaceable
		setsub *i 1
		setadd *y 1
	end
	// TREE BIG PART 1
	// at center
	call #setblockif|17|{x}|{y}|{z}|growreplaceable
	setadd *x 1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -3
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	// at far left
	setadd *z 2
	setrandlist *i 0|18
	if *i|=|18 call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 4
	setrandlist *i 0|18
	if *i|=|18 call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *z -4
	setrandlist *i 0|18
	if *i|=|18 call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -4
	setrandlist *i 0|18
	if *i|=|18 call #setblockif|18|{x}|{y}|{z}|growreplaceable
	// at bottom left
	setadd *x 1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *z 4
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	// at x: 1, z: 4
	setadd *z -1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 2
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *z -2
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -2
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 2
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *z 1
	setadd *y 1
	// TREE BIG PART 2
	// at center
	call #setblockif|17|{x}|{y}|{z}|growreplaceable
	setadd *x 1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -3
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	// at far left
	setadd *z 2
	setrandlist *i 0|18
	if *i|=|18 call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 4
	setrandlist *i 0|18
	if *i|=|18 call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *z -4
	setrandlist *i 0|18
	if *i|=|18 call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -4
	setrandlist *i 0|18
	if *i|=|18 call #setblockif|18|{x}|{y}|{z}|growreplaceable
	// at bottom left
	setadd *x 1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *z 4
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	// at x: 1, z: 4
	setadd *z -1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 2
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *z -2
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -2
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 2
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *z 1
	setadd *y 1
	// TREE SMALL PART 1
	// at center
	call #setblockif|17|{x}|{y}|{z}|growreplaceable
	setadd *x 1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *z -1
	setrandlist *i 0|18
	if *i|=|18 call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *z 2
	setrandlist *i 0|18
	if *i|=|18 call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -1
	setrandlist *i 0|18
	if *i|=|18 call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *z -1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *z -1
	setrandlist *i 0|18
	if *i|=|18 call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *z 1
	setadd *y 1
	// TREE SMALL PART 2
	// at center
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x -2
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *x 1
	setadd *z 1
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
	setadd *z -2
	call #setblockif|18|{x}|{y}|{z}|growreplaceable
end

#initBlacklist
	include struct blacklist survival/blacklist
quit

#initStructs
	include struct blocks survival/blocks
	include struct recipes survival/recipes
	include struct toollevel survival/toollevel
	include struct deathmessages survival/deathmessages
	include struct saveformat survival/saveformat
quit