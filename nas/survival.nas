using local_packages
using no_runarg_underscore_conversion

#onJoin
	clickevent sync register #click
	reach 5

	set minetimer 0
	set minepos
	set pickaxe 0
	set axe 0
	set spade 0

	set maxhp 30
	set hp {maxhp}
	set iframes 0
	set fireticks 0

	set allowMapChanges false
	if LevelName|=|"bravelycowering+survival" set allowMapChanges true

	cmd descend
	set worldSpawn {PlayerCoords}

	cmd holdsilent 0
	gui barColor #ff0000 0.25

	msg &fYou can place and break blocks freely in this map.
	if allowMapChanges msg &fMap changes will save, &cbut your items will not.
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

	cmd oss #tick repeatable
quit

// start scope
	set l_wpJDfc_PrevPlayerCoords 
	set l_UwJjQh_prevhp 
	set l_MKEjvs_hpbar 
	set l_dTivlb_myblock 
	#tick
		call #getblock|l_dTivlb_myblock|{PlayerX}|{PlayerY}|{PlayerZ}
		if blocks[{l_dTivlb_myblock}].catchFire set fireticks 100
		ifnot blocks[{l_dTivlb_myblock}].extinguishFire jump #if_cbfIGU
			ifnot fireticks|>|0 jump #if_LngUYC
				gui barSize 0
				set fireticks 0
			#if_LngUYC
		#if_cbfIGU
		ifnot blocks[{l_dTivlb_myblock}].damage|=|"" call #damage|{blocks[{l_dTivlb_myblock}].damage}|{blocks[{l_dTivlb_myblock}].damageType}
		ifnot PlayerCoords|=|l_wpJDfc_PrevPlayerCoords set usingWorkbench false
		ifnot PlayerCoords|=|l_wpJDfc_PrevPlayerCoords set usingStonecutter false
		set l_wpJDfc_PrevPlayerCoords {PlayerCoords}
		delay 100
		// cpemsg top1 &c{actionCount}/60000
		if hp|=|l_UwJjQh_prevhp jump #ifnot_EkRvjj
			set l_UwJjQh_prevhp {hp}
			call #makebar|l_MKEjvs_hpbar|c|{hp}|{maxhp}
			cpemsg bot1 &c♥ {l_MKEjvs_hpbar}
		#ifnot_EkRvjj
		if inventory[{PlayerHeldBlock}]|>|0 cpemsg bot2 Holding: &6{blocks[{PlayerHeldBlock}].name} &f(x{inventory[{PlayerHeldBlock}]})
		else cpemsg bot2 Holding: &cNothing
		cpemsg bot3 {toollevel[{pickaxe}]} Pickaxe &f| {toollevel[{axe}]} Axe &f| {toollevel[{spade}]} Spade
		ifnot iframes|>|0 jump #if_nXlJEa
			setsub iframes 1
			ifnot iframes|<|2 gui barColor #ff0000 0.25
			if iframes|<|2 gui barSize 0
			else gui barSize 1
		#if_nXlJEa
		ifnot fireticks|>|0 jump #if_qehmSB
			setsub fireticks 1
			ifnot iframes|<|2 jump #if_JDNQWG
				gui barColor #ffcc00 0.15
				gui barSize 1
			#if_JDNQWG
			set firetickmod {fireticks}
			setmod firetickmod 10
			if firetickmod|=|0 call #damage|2|burn
		#if_qehmSB
		if actionCount|>=|60000 cmd oss #tick repeatable
		if actionCount|>|60000 terminate
	jump #tick
// end scope

#generate
	// get seed
	msg Generating
	call #generate.setupCommands
	replysilent 1|Start generating!|#generate.start
	quit
	#generate.start
	call #generate.plantGrass
	call #generate.flood
	call #generate.caves
	call #generate.trees
	call #generate.ores
	call #generate.lavaFloor
	call #generate.cleanupCommands
quit

#generate.setupCommands
	msg &cPLEASE USE THE FOLLOWING COMMANDS FIRST
	msg &f/os texture bravelycowering.net/files/default2.zip
	msg &f/os lb copyall bravelycowering+survivaldev
	msg &f/os blockprops 764 grass 767
	msg &f/os blockprops 765 grass 766
	msg &aWHEN YOU ARE DONE, TYPE &f1
quit

#generate.plantGrass
	localmsg smallannounce Isolating terrain...
	cmd replaceall 8-11 17-18 37-40 0
	cmd replaceall 1-767 764
	localmsg smallannounce Soiling ground...
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
	cmd replace 0 9
	cmd m 0 0 0
	cmd m {LevelX} 63 {LevelY}
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

#generate.trees
	localmsg smallannounce Planting trees...
	// plant notch trees
	cmd replacebrush 2 random 2/499 767
	cmd ma
	cmd foreach 767 tree notch,m ~ ~1 ~
	cmd replaceall 767 3
	// plant big oak trees
	cmd replacebrush 2 random 2/999 767
	cmd ma
	cmd foreach 767 tree oak,m ~ ~1 ~
	cmd replaceall 767 3
quit

#generate.ores
	localmsg smallannounce Placing ores...
	cmd replacebrush 1 random 1/1993 14/2 15/2 16/2 52
	cmd ma
quit

#generate.lavaFloor
	localmsg smallannounce Melting core...
	cmd z 7
	cmd m 0 0 0
	cmd m {LevelX} 0 {LevelZ}
	cmd replace 0 11
	cmd m 0 1 0
	cmd m {LevelX} 3 {LevelZ}
quit

#generate.cleanupCommands
	localmsg smallannounce Done!
	msg &cDONT FORGET TO SET THE MOTD!:
	if allowMapChanges msg &f/os map motd -hax +thirdperson model=humanoid -aura
	else msg &f/os map motd -hax +thirdperson -push model=humanoid -aura
quit

#damage
	if iframes|>|0 quit
	setsub hp {runArg1}
	set iframes 4
	cs me ow:select(7)
	ifnot hp|<=|0 jump #if_HUUwYC
		kill {deathmessages.{runArg2}}
		set fireticks 0
		set hp {maxhp}
	#if_HUUwYC
quit

#click
	set coords {click.coords}
	setsplit coords " "
	if coords[0]|>|1000 quit
	if coords[1]|>|1000 quit
	if coords[2]|>|1000 quit
	if click.button|=|"Left" jump #mine|{coords[0]}|{coords[1]}|{coords[2]}
	if click.button|=|"Right" jump #place|{coords[0]}|{coords[1]}|{coords[2]}
	if click.button|=|"Middle" jump #pick|{coords[0]}|{coords[1]}|{coords[2]}
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
	ifnot minetimer|>|0 jump #if_msyItF
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
		cmd tempbot tp minemeter {x} {boty} {z} 0 0
		quit
	#if_msyItF
	set minepos
	if toomuch jump #ifnot_pwungZ
		if label #loot[{id}] call #loot[{id}]
		else call #give|{id}|1
	#ifnot_pwungZ
	if blocks[{id}].remainder|=|"" set empty 0
	else set empty {blocks[{id}].remainder}
	ifnot spawnblock|=|coords jump #if_eOPCGH
		set spawnblock
		setdeathspawn {worldSpawn} 0 0
	#if_eOPCGH
	jump #setblock|{empty}|{x}|{y}|{z}
quit

#give
	ifnot isTool({runArg1}) jump #if_pVjhwN
		set {runArg1} {runArg2}
		quit
	#if_pVjhwN
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
	#while_cGtHPp
		set inventory[{i}] 9999
		setadd i 1
	if i|<|{blocks.Length} jump #while_cGtHPp
quit

#place
	set x {runArg1}
	set y {runArg2}
	set z {runArg3}
	call #getblock|id|{x}|{y}|{z}
	if label #use[{id}:{PlayerHeldBlock}] jump #use[{id}:{PlayerHeldBlock}]|{x}|{y}|{z}
	if label #use[{id}] jump #use[{id}]|{x}|{y}|{z}
	if blocks[{id}].replaceable quit
	if click.face|=|"AwayX" setadd x 1
	if click.face|=|"AwayY" setadd y 1
	if click.face|=|"AwayZ" setadd z 1
	if click.face|=|"TowardsX" setsub x 1
	if click.face|=|"TowardsY" setsub y 1
	if click.face|=|"TowardsZ" setsub z 1
	call #getblock|id|{x}|{y}|{z}
	ifnot blocks[{id}].replaceable quit
	if blocks[{PlayerHeldBlock}].replaceable jump #ifnot_vSUlHm
		ifnot inventory[{PlayerHeldBlock}]|>|0 msg &cYou don't have any &f{blocks[{PlayerHeldBlock}].name}!
	#ifnot_vSUlHm
	ifnot inventory[{PlayerHeldBlock}]|>|0 jump #if_pVwSmR
		call #take|{playerHeldBlock}|1
		jump #setblock|{PlayerHeldBlock}|{x}|{y}|{z}
	#if_pVwSmR
quit

#pick
	call #getblock|id|{runArg1}|{runArg2}|{runArg3}
	cmd holdsilent {id}
quit

#getblock
	ifnot allowMapChanges set {runArg1} {world[{runArg2},{runArg3},{runArg4}]}
	if {runArg1}|=|"" setblockid {runArg1} {runArg2} {runArg3} {runArg4}
quit

#setblock
	if allowMapChanges jump #ifnot_ZmwwhI
		tempblock {runArg1} {runArg2} {runArg3} {runArg4}
		set world[{runArg2},{runArg3},{runArg4}] {runArg1}
		quit
	#ifnot_ZmwwhI
	placeblock {runArg1} {runArg2} {runArg3} {runArg4}
quit

#makebar
// package, color, amount, max
	set i 0
	set {runArg1} &{runArg2}
	ifnot i|<|{runArg3} jump #if_JoBclA
		#while_fuBpxd
			set {runArg1} {{runArg1}}|
			setadd i 1
		if i|<|{runArg3} jump #while_fuBpxd
	#if_JoBclA
	set {runArg1} {{runArg1}}&0
	ifnot i|<|{runArg4} jump #if_ScYqxK
		#while_RXbQJH
			set {runArg1} {{runArg1}}|
			setadd i 1
		if i|<|{runArg4} jump #while_RXbQJH
	#if_ScYqxK
quit

#input
	ifnot runArg1|=|"craft" jump #if_Vzywtu
		set craftArgs {runArg2}
		if craftArgs|=|"" jump #ifnot_RZYmnS
			set craftArgs[1] 1
			setsplit craftArgs *
			if isTool({craftArgs[0]}) set craftArgs[1] 1
			call #getBlockByName|blockID|{craftArgs[0]}
			ifnot blockID|=|"" jump #if_Ccepki
				msg &cInvalid item name or ID
				quit
			#if_Ccepki
			call #getRecipeByOutput|recipeID|{blockID}|{craftArgs[1]}
			ifnot recipeID|=|"" jump #if_Lglnks
				msg &cYou cannot craft {blocks[{blockID}].name}!
				quit
			#if_Lglnks
			call #doCraft|{recipeID}|{craftArgs[1]}
			quit
		#ifnot_RZYmnS
		if usingWorkbench msg &eWorkbench Recipes:
		if usingWorkbench jump #ifnot_quACyK
			if usingStonecutter msg &eStonecutter Recipes:
			else msg &eRecipes:
		#ifnot_quACyK
		set i 0
		#while_ZmINXV
			call #checkRecipeAfford|{i}|canAfford|1
			set ingrediantList
			ifnot canAfford jump #if_IxerqC
				ifnot isTool({recipes[{i}].output.id}) msg &f> &6{blocks[{recipes[{i}].output.id}].name}&f (x{recipes[{i}].output.count}):
				else msg &f> &6{blocks[{recipes[{i}].output.id}].name}&f ({toollevel[{recipes[{i}].output.count}]}&f):
				set j 0
				#while_YdsQPY
					set text {recipes[{i}].ingredients[{j}].count} {blocks[{recipes[{i}].ingredients[{j}].id}].name}
					if ingrediantList|=|"" set ingrediantList &f    {text}
					else set ingrediantList {ingrediantList}, {text}
					setadd j 1
				if j|<|{recipes[{i}].ingredients.Length} jump #while_YdsQPY
				msg {ingrediantList}
			#if_IxerqC
			setadd i 1
		if i|<|{recipes.Length} jump #while_ZmINXV
		msg &eType &a/in craft [name]&e to craft something
		quit
	#if_Vzywtu
	set i 0
	msg &eResources:
	#while_KKRQEp
		ifnot inventory[{i}]|=|0 msg &f> &6{blocks[{i}].name}&f (x{inventory[{i}]})
		setadd i 1
	if i|<|{blocks.Length} jump #while_KKRQEp
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
	#while_CFxnmL
		set id {recipes[{recipeID}].ingredients[{j}].id}
		set count {recipes[{recipeID}].ingredients[{j}].count}
		setmul count {recipeCount}
		call #take|{id}|{count}
		setadd j 1
	if j|<|{recipes[{recipeID}].ingredients.Length} jump #while_CFxnmL
	set count {recipes[{recipeID}].output.count}
	setmul count {recipeCount}
	call #give|{blockID}|{count}
	ifnot isTool({blockID}) msg &aCrafted {blocks[{blockID}].name} x{count}
	else msg &aCrafted {toollevel[{count}]} {blocks[{blockID}].name}
quit

#checkRecipeAfford
	set j 0
	set {runArg2} false
	if recipes[{runArg1}].condition|=|"" jump #ifnot_YNwmHg
		ifnot {recipes[{runArg1}].condition} quit
	#ifnot_YNwmHg
	ifnot isTool({recipes[{runArg1}].output.id}) jump #if_TgYvfk
		if {recipes[{runArg1}].output.id}|>=|recipes[{runArg1}].output.count quit
	#if_TgYvfk
	#while_iYDuwy
		set id {recipes[{runArg1}].ingredients[{j}].id}
		set count {recipes[{runArg1}].ingredients[{j}].count}
		setmul count {runArg3}
		if count|>|{inventory[{id}]} quit
		setadd j 1
	if j|<|{recipes[{runArg1}].ingredients.Length} jump #while_iYDuwy
	set {runArg2} true
quit

#getBlockByName
	set {runArg1}
	if blocks[{runArg2}].name|=|"" jump #ifnot_zZTOZj
		set {runArg1} {runArg2}
		quit
	#ifnot_zZTOZj
	set i 0
	#while_ictZFK
		ifnot blocks[{i}].name|=|runArg2 jump #if_ItnCZC
			set {runArg1} {i}
			quit
		#if_ItnCZC
		setadd i 1
	if i|<|{blocks.Length} jump #while_ictZFK
quit

#getRecipeByOutput
	set pname {runArg1}
	set bid {runArg2}
	set c {runArg3}
	set {pname}
	set i 0
	#while_MygxDB
		ifnot recipes[{i}].output.id|=|bid jump #if_GpKjUR
			call #checkRecipeAfford|{i}|canAfford|{c}
			ifnot canAfford jump #if_JDgitx
				set {pname} {i}
				quit
			#if_JDgitx
		#if_GpKjUR
		setadd i 1
	if i|<|{recipes.Length} jump #while_MygxDB
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
	if blocks[{PlayerHeldBlock}].campfireLighter|=|"" jump #ifnot_GsllOt
		ifnot inventory[{PlayerHeldBlock}]|>|0 jump #if_FGRPqF
			call #setblock|68|{runArg1}|{runArg2}|{runArg3}
			call #take|{PlayerHeldBlock}|1
			call #give|{blocks[{PlayerHeldBlock}].campfireLighter}|1
			setdeathspawn {PlayerCoords} {PlayerYaw} {PlayerPitch}
			set spawnblock {runArg1} {runArg2} {runArg3}
			msg &fRespawn point set
		#if_FGRPqF
	#ifnot_GsllOt
quit

#use[68]
	setdeathspawn {PlayerCoords} {PlayerYaw} {PlayerPitch}
	set spawnblock {runArg1} {runArg2} {runArg3}
	msg &fRespawn point set
quit

#use[70:80]
#use[68:80]
	ifnot inventory[80]|>|0 jump #if_yzsDqc
		call #take|80|1
		call #give|70|1
	#if_yzsDqc
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
jump #give|72|4

#loot[20]
#loot[50]
#loot[54]
#loot[60]
#loot[68]
#loot[69]
quit

#initStructs
set blocks[0].name Air
set blocks[0].unbreakable true
set blocks[0].replaceable true
set blocks[1].name Stone
set blocks[1].hardness 8
set blocks[1].toughness 1
set blocks[1].tooltype pickaxe
set blocks[2].name Grass
set blocks[2].hardness 3
set blocks[2].tooltype spade
set blocks[3].name Dirt
set blocks[3].hardness 3
set blocks[3].tooltype spade
set blocks[4].name Cobblestone
set blocks[4].hardness 6
set blocks[4].toughness 1
set blocks[4].tooltype pickaxe
set blocks[5].name Wood
set blocks[5].hardness 6
set blocks[5].tooltype axe
set blocks[6].name Sapling
set blocks[7].name Bedrock
set blocks[7].unbreakable true
set blocks[8].unbreakable true
set blocks[8].level 8
set blocks[8].name Water
set blocks[8].fluid true
set blocks[8].extinguishFire true
set blocks[8].replaceable true
set blocks[9].unbreakable true
set blocks[9].level 8
set blocks[9].source true
set blocks[9].name Still water
set blocks[9].fluid true
set blocks[9].extinguishFire true
set blocks[9].replaceable true
set blocks[10].damage 6
set blocks[10].unbreakable true
set blocks[10].damageType lava
set blocks[10].level 4
set blocks[10].name Lava
set blocks[10].fluid true
set blocks[10].catchFire true
set blocks[10].replaceable true
set blocks[11].level 4
set blocks[11].fluid true
set blocks[11].catchFire true
set blocks[11].replaceable true
set blocks[11].unbreakable true
set blocks[11].source true
set blocks[11].name Still lava
set blocks[11].damageType lava
set blocks[11].damage 6
set blocks[12].name Sand
set blocks[12].hardness 3
set blocks[12].tooltype spade
set blocks[13].name Gravel
set blocks[13].hardness 3
set blocks[13].tooltype spade
set blocks[14].name Gold ore
set blocks[14].hardness 24
set blocks[14].toughness 3
set blocks[14].tooltype pickaxe
set blocks[15].name Iron ore
set blocks[15].hardness 16
set blocks[15].toughness 2
set blocks[15].tooltype pickaxe
set blocks[16].name Coal ore
set blocks[16].hardness 12
set blocks[16].toughness 1
set blocks[16].tooltype pickaxe
set blocks[17].name Log
set blocks[17].hardness 8
set blocks[17].tooltype axe
set blocks[18].name Leaves
set blocks[18].hardness 2
set blocks[18].tooltype axe
set blocks[19].name Sponge
set blocks[19].hardness 3
set blocks[19].tooltype spade
set blocks[20].name Glass
set blocks[20].hardness 2
set blocks[20].tooltype pickaxe
set blocks[21].name Red
set blocks[22].name Orange
set blocks[23].name Yellow
set blocks[24].name Lime
set blocks[25].name Green
set blocks[26].name Teal
set blocks[27].name Aqua
set blocks[28].name Cyan
set blocks[29].name Blue
set blocks[30].name Indigo
set blocks[31].name Violet
set blocks[32].name Magenta
set blocks[33].name Pink
set blocks[34].name Black
set blocks[35].name Gray
set blocks[36].name White
set blocks[37].name Dandelion
set blocks[38].name Rose
set blocks[39].name Brown mushroom
set blocks[40].name Red mushroom
set blocks[41].name Gold
set blocks[41].hardness 24
set blocks[41].toughness 3
set blocks[41].tooltype pickaxe
set blocks[42].name Iron
set blocks[42].hardness 16
set blocks[42].toughness 2
set blocks[42].tooltype pickaxe
set blocks[43].name Double slab
set blocks[43].hardness 8
set blocks[43].toughness 1
set blocks[43].tooltype pickaxe
set blocks[44].name Slab
set blocks[44].hardness 4
set blocks[44].toughness 1
set blocks[44].tooltype pickaxe
set blocks[45].name Brick
set blocks[45].hardness 6
set blocks[45].toughness 1
set blocks[45].tooltype pickaxe
set blocks[46].name TNT
set blocks[47].name Bookshelf
set blocks[47].hardness 6
set blocks[47].tooltype axe
set blocks[48].name Mossy rocks
set blocks[48].hardness 9
set blocks[48].toughness 1
set blocks[48].tooltype pickaxe
set blocks[49].name Obsidian
set blocks[49].hardness 60
set blocks[49].toughness 8
set blocks[49].tooltype pickaxe
set blocks[50].name Magma
set blocks[50].remainder 10
set blocks[50].hardness 5
set blocks[50].tooltype pickaxe
set blocks[51].name Coal
set blocks[51].hardness 12
set blocks[51].toughness 1
set blocks[51].tooltype pickaxe
set blocks[52].name Diamond ore
set blocks[52].hardness 32
set blocks[52].toughness 3
set blocks[52].tooltype pickaxe
set blocks[53].name Diamond
set blocks[53].hardness 32
set blocks[53].toughness 3
set blocks[53].tooltype pickaxe
set blocks[54].name Fire
set blocks[54].damage 3
set blocks[54].catchFire true
set blocks[54].damageType fire
set blocks[55].name Gold bar
set blocks[56].name Iron bar
set blocks[57].name Coal lump
set blocks[58].name Diamond gem
set blocks[59].name Stone brick
set blocks[59].hardness 8
set blocks[59].toughness 1
set blocks[59].tooltype pickaxe
set blocks[60].name Ice
set blocks[60].remainder 8
set blocks[60].hardness 3
set blocks[60].tooltype pickaxe
set blocks[61].name Workbench
set blocks[61].hardness 8
set blocks[61].tooltype axe
set blocks[62].name Stonecutter
set blocks[62].hardness 8
set blocks[62].tooltype pickaxe
set blocks[63].name Brown mushroom top
set blocks[63].hardness 4
set blocks[63].tooltype spade
set blocks[64].name Red mushroom top
set blocks[64].hardness 4
set blocks[64].tooltype spade
set blocks[65].name Mushroom stem
set blocks[65].hardness 8
set blocks[65].tooltype spade
set blocks[66].name Stick
set blocks[67].name Campfire
set blocks[67].hardness 3
set blocks[67].tooltype axe
set blocks[68].damage 3
set blocks[68].name Lit campfire
set blocks[68].remainder 67
set blocks[68].catchFire true
set blocks[68].damageType fire
set blocks[69].name Cobweb
set blocks[69].hardness 5
set blocks[69].tooltype spade
set blocks[70].name Lit torch
set blocks[70].campfireLighter 70
set blocks[71].name Snow
set blocks[71].hardness 2
set blocks[71].tooltype spade
set blocks[72].name Snow ball
set blocks[73].unbreakable true
set blocks[73].level 7
set blocks[73].name Water
set blocks[73].fluid true
set blocks[73].replaceable true
set blocks[74].unbreakable true
set blocks[74].level 6
set blocks[74].name Water
set blocks[74].fluid true
set blocks[74].replaceable true
set blocks[75].unbreakable true
set blocks[75].level 5
set blocks[75].name Water
set blocks[75].fluid true
set blocks[75].replaceable true
set blocks[76].unbreakable true
set blocks[76].level 4
set blocks[76].name Water
set blocks[76].fluid true
set blocks[76].replaceable true
set blocks[77].unbreakable true
set blocks[77].level 3
set blocks[77].name Water
set blocks[77].fluid true
set blocks[77].replaceable true
set blocks[78].unbreakable true
set blocks[78].level 2
set blocks[78].name Water
set blocks[78].fluid true
set blocks[78].replaceable true
set blocks[79].unbreakable true
set blocks[79].level 1
set blocks[79].name Water
set blocks[79].fluid true
set blocks[79].replaceable true
set blocks[80].name Torch
set blocks[80].campfireLighter 70
set blocks.Length 81
set recipes[0].ingredients[0].count 3
set recipes[0].ingredients[0].id 58
set recipes[0].ingredients[1].count 2
set recipes[0].ingredients[1].id 66
set recipes[0].ingredients.Length 2
set recipes[0].output.count 8
set recipes[0].output.id pickaxe
set recipes[0].condition usingWorkbench
set recipes[1].ingredients[0].count 3
set recipes[1].ingredients[0].id 58
set recipes[1].ingredients[1].count 2
set recipes[1].ingredients[1].id 66
set recipes[1].ingredients.Length 2
set recipes[1].output.count 8
set recipes[1].output.id axe
set recipes[1].condition usingWorkbench
set recipes[2].ingredients[0].count 1
set recipes[2].ingredients[0].id 58
set recipes[2].ingredients[1].count 2
set recipes[2].ingredients[1].id 66
set recipes[2].ingredients.Length 2
set recipes[2].output.count 8
set recipes[2].output.id spade
set recipes[2].condition usingWorkbench
set recipes[3].ingredients[0].count 3
set recipes[3].ingredients[0].id 55
set recipes[3].ingredients[1].count 2
set recipes[3].ingredients[1].id 66
set recipes[3].ingredients.Length 2
set recipes[3].output.count 6
set recipes[3].output.id pickaxe
set recipes[3].condition usingWorkbench
set recipes[4].ingredients[0].count 3
set recipes[4].ingredients[0].id 55
set recipes[4].ingredients[1].count 2
set recipes[4].ingredients[1].id 66
set recipes[4].ingredients.Length 2
set recipes[4].output.count 6
set recipes[4].output.id axe
set recipes[4].condition usingWorkbench
set recipes[5].ingredients[0].count 1
set recipes[5].ingredients[0].id 55
set recipes[5].ingredients[1].count 2
set recipes[5].ingredients[1].id 66
set recipes[5].ingredients.Length 2
set recipes[5].output.count 6
set recipes[5].output.id spade
set recipes[5].condition usingWorkbench
set recipes[6].ingredients[0].count 3
set recipes[6].ingredients[0].id 56
set recipes[6].ingredients[1].count 2
set recipes[6].ingredients[1].id 66
set recipes[6].ingredients.Length 2
set recipes[6].output.count 3
set recipes[6].output.id pickaxe
set recipes[6].condition usingWorkbench
set recipes[7].ingredients[0].count 3
set recipes[7].ingredients[0].id 56
set recipes[7].ingredients[1].count 2
set recipes[7].ingredients[1].id 66
set recipes[7].ingredients.Length 2
set recipes[7].output.count 3
set recipes[7].output.id axe
set recipes[7].condition usingWorkbench
set recipes[8].ingredients[0].count 1
set recipes[8].ingredients[0].id 56
set recipes[8].ingredients[1].count 2
set recipes[8].ingredients[1].id 66
set recipes[8].ingredients.Length 2
set recipes[8].output.count 3
set recipes[8].output.id spade
set recipes[8].condition usingWorkbench
set recipes[9].ingredients[0].count 3
set recipes[9].ingredients[0].id 4
set recipes[9].ingredients[1].count 2
set recipes[9].ingredients[1].id 66
set recipes[9].ingredients.Length 2
set recipes[9].output.count 2
set recipes[9].output.id pickaxe
set recipes[9].condition usingWorkbench
set recipes[10].ingredients[0].count 3
set recipes[10].ingredients[0].id 4
set recipes[10].ingredients[1].count 2
set recipes[10].ingredients[1].id 66
set recipes[10].ingredients.Length 2
set recipes[10].output.count 2
set recipes[10].output.id axe
set recipes[10].condition usingWorkbench
set recipes[11].ingredients[0].count 1
set recipes[11].ingredients[0].id 4
set recipes[11].ingredients[1].count 2
set recipes[11].ingredients[1].id 66
set recipes[11].ingredients.Length 2
set recipes[11].output.count 2
set recipes[11].output.id spade
set recipes[11].condition usingWorkbench
set recipes[12].ingredients[0].count 3
set recipes[12].ingredients[0].id 5
set recipes[12].ingredients[1].count 2
set recipes[12].ingredients[1].id 66
set recipes[12].ingredients.Length 2
set recipes[12].output.count 1
set recipes[12].output.id pickaxe
set recipes[12].condition usingWorkbench
set recipes[13].ingredients[0].count 3
set recipes[13].ingredients[0].id 5
set recipes[13].ingredients[1].count 2
set recipes[13].ingredients[1].id 66
set recipes[13].ingredients.Length 2
set recipes[13].output.count 1
set recipes[13].output.id axe
set recipes[13].condition usingWorkbench
set recipes[14].ingredients[0].count 1
set recipes[14].ingredients[0].id 5
set recipes[14].ingredients[1].count 2
set recipes[14].ingredients[1].id 66
set recipes[14].ingredients.Length 2
set recipes[14].output.count 1
set recipes[14].output.id spade
set recipes[14].condition usingWorkbench
set recipes[15].ingredients[0].count 1
set recipes[15].ingredients[0].id 17
set recipes[15].ingredients.Length 1
set recipes[15].output.count 4
set recipes[15].output.id 5
set recipes[16].ingredients[0].count 2
set recipes[16].ingredients[0].id 5
set recipes[16].ingredients.Length 1
set recipes[16].output.count 4
set recipes[16].output.id 66
set recipes[17].ingredients[0].count 4
set recipes[17].ingredients[0].id 5
set recipes[17].ingredients.Length 1
set recipes[17].output.count 1
set recipes[17].output.id 61
set recipes[18].ingredients[0].count 1
set recipes[18].ingredients[0].id 66
set recipes[18].ingredients[1].count 1
set recipes[18].ingredients[1].id 57
set recipes[18].ingredients.Length 2
set recipes[18].output.count 4
set recipes[18].output.id 80
set recipes[19].ingredients[0].count 3
set recipes[19].ingredients[0].id 66
set recipes[19].ingredients[1].count 1
set recipes[19].ingredients[1].id 57
set recipes[19].ingredients.Length 2
set recipes[19].output.count 1
set recipes[19].output.id 67
set recipes[20].ingredients[0].count 4
set recipes[20].ingredients[0].id 4
set recipes[20].ingredients.Length 1
set recipes[20].output.count 1
set recipes[20].output.id 62
set recipes[21].ingredients[0].count 1
set recipes[21].ingredients[0].id 16
set recipes[21].ingredients.Length 1
set recipes[21].output.count 1
set recipes[21].output.id 57
set recipes[21].condition usingStonecutter
set recipes[22].ingredients[0].count 1
set recipes[22].ingredients[0].id 15
set recipes[22].ingredients.Length 1
set recipes[22].output.count 1
set recipes[22].output.id 56
set recipes[22].condition usingStonecutter
set recipes[23].ingredients[0].count 1
set recipes[23].ingredients[0].id 14
set recipes[23].ingredients.Length 1
set recipes[23].output.count 1
set recipes[23].output.id 55
set recipes[23].condition usingStonecutter
set recipes[24].ingredients[0].count 1
set recipes[24].ingredients[0].id 52
set recipes[24].ingredients.Length 1
set recipes[24].output.count 1
set recipes[24].output.id 58
set recipes[24].condition usingStonecutter
set recipes[25].ingredients[0].count 9
set recipes[25].ingredients[0].id 57
set recipes[25].ingredients.Length 1
set recipes[25].output.count 1
set recipes[25].output.id 51
set recipes[25].condition usingWorkbench
set recipes[26].ingredients[0].count 1
set recipes[26].ingredients[0].id 51
set recipes[26].ingredients.Length 1
set recipes[26].output.count 9
set recipes[26].output.id 57
set recipes[26].condition usingStonecutter
set recipes[27].ingredients[0].count 9
set recipes[27].ingredients[0].id 56
set recipes[27].ingredients.Length 1
set recipes[27].output.count 1
set recipes[27].output.id 42
set recipes[27].condition usingWorkbench
set recipes[28].ingredients[0].count 1
set recipes[28].ingredients[0].id 42
set recipes[28].ingredients.Length 1
set recipes[28].output.count 9
set recipes[28].output.id 56
set recipes[28].condition usingStonecutter
set recipes[29].ingredients[0].count 9
set recipes[29].ingredients[0].id 55
set recipes[29].ingredients.Length 1
set recipes[29].output.count 1
set recipes[29].output.id 41
set recipes[29].condition usingWorkbench
set recipes[30].ingredients[0].count 1
set recipes[30].ingredients[0].id 41
set recipes[30].ingredients.Length 1
set recipes[30].output.count 9
set recipes[30].output.id 55
set recipes[30].condition usingStonecutter
set recipes[31].ingredients[0].count 9
set recipes[31].ingredients[0].id 58
set recipes[31].ingredients.Length 1
set recipes[31].output.count 1
set recipes[31].output.id 53
set recipes[31].condition usingWorkbench
set recipes[32].ingredients[0].count 1
set recipes[32].ingredients[0].id 53
set recipes[32].ingredients.Length 1
set recipes[32].output.count 9
set recipes[32].output.id 58
set recipes[32].condition usingStonecutter
set recipes[33].ingredients[0].count 4
set recipes[33].ingredients[0].id 72
set recipes[33].ingredients.Length 1
set recipes[33].output.count 1
set recipes[33].output.id 71
set recipes[34].ingredients[0].count 1
set recipes[34].ingredients[0].id 71
set recipes[34].ingredients.Length 1
set recipes[34].output.count 4
set recipes[34].output.id 72
set recipes[35].ingredients[0].count 4
set recipes[35].ingredients[0].id 39
set recipes[35].ingredients.Length 1
set recipes[35].output.count 1
set recipes[35].output.id 63
set recipes[36].ingredients[0].count 1
set recipes[36].ingredients[0].id 63
set recipes[36].ingredients.Length 1
set recipes[36].output.count 4
set recipes[36].output.id 39
set recipes[37].ingredients[0].count 4
set recipes[37].ingredients[0].id 40
set recipes[37].ingredients.Length 1
set recipes[37].output.count 1
set recipes[37].output.id 64
set recipes[38].ingredients[0].count 1
set recipes[38].ingredients[0].id 64
set recipes[38].ingredients.Length 1
set recipes[38].output.count 4
set recipes[38].output.id 40
set recipes.Length 39
set toollevel[0] &cNo
set toollevel[1] &sWooden
set toollevel[2] &7Stone
set toollevel[3] &fIron
set toollevel[6] &6Golden
set toollevel[8] &bDiamond
set toollevel.Length 3
set deathmessages.fire @color@nick&f went up in flames
set deathmessages.lava @color@nick&f tried to swim in lava
set deathmessages.drown @color@nick&f drowned
set deathmessages.fall @color@nick&f hit the ground too hard
set deathmessages.burn @color@nick&f was burnt to a crisp
set deathmessages.magma @color@nick&f discovered the floor was lava
set deathmessages.explosion @color@nick&f blew up
set deathmessages.suffocation @color@nick&f suffocated in a wall
set deathmessages.freeze @color@nick&f froze to death
quit