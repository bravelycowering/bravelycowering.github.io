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

	cmd holdsilent 0
	gui barColor #ff0000 0.25

	msg &fYou can place and break blocks freely in this map.
	msg &fType &a/in&f to view your &ainventory&f.

set blocks[0].name Air
set blocks[0].unbreakable true
set blocks[0].replaceable true
set blocks[1].name Stone
set blocks[1].tooltype pickaxe
set blocks[1].hardness 8
set blocks[1].toughness 1
set blocks[2].name Grass
set blocks[2].hardness 3
set blocks[2].tooltype spade
set blocks[3].name Dirt
set blocks[3].hardness 3
set blocks[3].tooltype spade
set blocks[4].name Cobblestone
set blocks[4].tooltype pickaxe
set blocks[4].hardness 6
set blocks[4].toughness 1
set blocks[5].name Wood
set blocks[5].hardness 6
set blocks[5].tooltype axe
set blocks[6].name Sapling
set blocks[7].name Bedrock
set blocks[7].unbreakable true
set blocks[8].unbreakable true
set blocks[8].name Water
set blocks[8].level 8
set blocks[8].replaceable true
set blocks[8].fluid true
set blocks[9].unbreakable true
set blocks[9].level 8
set blocks[9].name Still water
set blocks[9].source true
set blocks[9].replaceable true
set blocks[9].fluid true
set blocks[10].damageType lava
set blocks[10].unbreakable true
set blocks[10].level 4
set blocks[10].name Lava
set blocks[10].damage 6
set blocks[10].replaceable true
set blocks[10].fluid true
set blocks[11].damageType lava
set blocks[11].unbreakable true
set blocks[11].damage 6
set blocks[11].level 4
set blocks[11].name Still lava
set blocks[11].source true
set blocks[11].replaceable true
set blocks[11].fluid true
set blocks[12].name Sand
set blocks[12].hardness 3
set blocks[12].tooltype spade
set blocks[13].name Gravel
set blocks[13].hardness 3
set blocks[13].tooltype spade
set blocks[14].name Gold ore
set blocks[14].tooltype pickaxe
set blocks[14].hardness 24
set blocks[14].toughness 3
set blocks[15].name Iron ore
set blocks[15].tooltype pickaxe
set blocks[15].hardness 16
set blocks[15].toughness 2
set blocks[16].name Coal ore
set blocks[16].tooltype pickaxe
set blocks[16].hardness 12
set blocks[16].toughness 1
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
set blocks[41].tooltype pickaxe
set blocks[41].hardness 24
set blocks[41].toughness 3
set blocks[42].name Iron
set blocks[42].tooltype pickaxe
set blocks[42].hardness 16
set blocks[42].toughness 2
set blocks[43].name Double slab
set blocks[43].tooltype pickaxe
set blocks[43].hardness 8
set blocks[43].toughness 1
set blocks[44].name Slab
set blocks[44].tooltype pickaxe
set blocks[44].hardness 4
set blocks[44].toughness 1
set blocks[45].name Brick
set blocks[45].tooltype pickaxe
set blocks[45].hardness 6
set blocks[45].toughness 1
set blocks[46].name TNT
set blocks[47].name Bookshelf
set blocks[47].hardness 6
set blocks[47].tooltype axe
set blocks[48].name Mossy rocks
set blocks[48].tooltype pickaxe
set blocks[48].hardness 9
set blocks[48].toughness 1
set blocks[49].name Obsidian
set blocks[49].tooltype pickaxe
set blocks[49].hardness 60
set blocks[49].toughness 8
set blocks[50].name Magma
set blocks[50].hardness 5
set blocks[50].remainder 10
set blocks[50].tooltype pickaxe
set blocks[51].name Coal
set blocks[51].tooltype pickaxe
set blocks[51].hardness 12
set blocks[51].toughness 1
set blocks[52].name Diamond ore
set blocks[52].tooltype pickaxe
set blocks[52].hardness 32
set blocks[52].toughness 3
set blocks[53].name Diamond
set blocks[53].tooltype pickaxe
set blocks[53].hardness 32
set blocks[53].toughness 3
set blocks[54].name Fire
set blocks[55].name Gold bar
set blocks[56].name Iron bar
set blocks[57].name Coal lump
set blocks[58].name Diamond gem
set blocks[59].name Stone brick
set blocks[59].toughness 1
set blocks[59].hardness 8
set blocks[59].tooltype pickaxe
set blocks[60].name Ice
set blocks[60].hardness 3
set blocks[60].remainder 8
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
set blocks[68].name Lit campfire
set blocks[68].remainder 67
set blocks[69].name Cobweb
set blocks[69].hardness 5
set blocks[69].tooltype spade
set blocks[70].name Torch
set blocks[71].name Snow
set blocks[71].hardness 2
set blocks[71].tooltype spade
set blocks[72].name Snow ball
set blocks[73].unbreakable true
set blocks[73].name Water
set blocks[73].level 7
set blocks[73].replaceable true
set blocks[73].fluid true
set blocks[74].unbreakable true
set blocks[74].name Water
set blocks[74].level 6
set blocks[74].replaceable true
set blocks[74].fluid true
set blocks[75].unbreakable true
set blocks[75].name Water
set blocks[75].level 5
set blocks[75].replaceable true
set blocks[75].fluid true
set blocks[76].unbreakable true
set blocks[76].name Water
set blocks[76].level 4
set blocks[76].replaceable true
set blocks[76].fluid true
set blocks[77].unbreakable true
set blocks[77].name Water
set blocks[77].level 3
set blocks[77].replaceable true
set blocks[77].fluid true
set blocks[78].unbreakable true
set blocks[78].name Water
set blocks[78].level 2
set blocks[78].replaceable true
set blocks[78].fluid true
set blocks[79].unbreakable true
set blocks[79].name Water
set blocks[79].level 1
set blocks[79].replaceable true
set blocks[79].fluid true
set blocks.Length 80
set recipes[0].output.id pickaxe
set recipes[0].output.count 8
set recipes[0].condition usingWorkbench
set recipes[0].ingredients[0].id 58
set recipes[0].ingredients[0].count 3
set recipes[0].ingredients[1].id 66
set recipes[0].ingredients[1].count 2
set recipes[0].ingredients.Length 2
set recipes[1].output.id pickaxe
set recipes[1].output.count 6
set recipes[1].condition usingWorkbench
set recipes[1].ingredients[0].id 55
set recipes[1].ingredients[0].count 3
set recipes[1].ingredients[1].id 66
set recipes[1].ingredients[1].count 2
set recipes[1].ingredients.Length 2
set recipes[2].output.id pickaxe
set recipes[2].output.count 3
set recipes[2].condition usingWorkbench
set recipes[2].ingredients[0].id 56
set recipes[2].ingredients[0].count 3
set recipes[2].ingredients[1].id 66
set recipes[2].ingredients[1].count 2
set recipes[2].ingredients.Length 2
set recipes[3].output.id pickaxe
set recipes[3].output.count 2
set recipes[3].condition usingWorkbench
set recipes[3].ingredients[0].id 4
set recipes[3].ingredients[0].count 3
set recipes[3].ingredients[1].id 66
set recipes[3].ingredients[1].count 2
set recipes[3].ingredients.Length 2
set recipes[4].output.id pickaxe
set recipes[4].output.count 1
set recipes[4].condition usingWorkbench
set recipes[4].ingredients[0].id 5
set recipes[4].ingredients[0].count 3
set recipes[4].ingredients[1].id 66
set recipes[4].ingredients[1].count 2
set recipes[4].ingredients.Length 2
set recipes[5].output.id axe
set recipes[5].output.count 8
set recipes[5].condition usingWorkbench
set recipes[5].ingredients[0].id 58
set recipes[5].ingredients[0].count 3
set recipes[5].ingredients[1].id 66
set recipes[5].ingredients[1].count 2
set recipes[5].ingredients.Length 2
set recipes[6].output.id axe
set recipes[6].output.count 6
set recipes[6].condition usingWorkbench
set recipes[6].ingredients[0].id 55
set recipes[6].ingredients[0].count 3
set recipes[6].ingredients[1].id 66
set recipes[6].ingredients[1].count 2
set recipes[6].ingredients.Length 2
set recipes[7].output.id axe
set recipes[7].output.count 3
set recipes[7].condition usingWorkbench
set recipes[7].ingredients[0].id 56
set recipes[7].ingredients[0].count 3
set recipes[7].ingredients[1].id 66
set recipes[7].ingredients[1].count 2
set recipes[7].ingredients.Length 2
set recipes[8].output.id axe
set recipes[8].output.count 2
set recipes[8].condition usingWorkbench
set recipes[8].ingredients[0].id 4
set recipes[8].ingredients[0].count 3
set recipes[8].ingredients[1].id 66
set recipes[8].ingredients[1].count 2
set recipes[8].ingredients.Length 2
set recipes[9].output.id axe
set recipes[9].output.count 1
set recipes[9].condition usingWorkbench
set recipes[9].ingredients[0].id 5
set recipes[9].ingredients[0].count 3
set recipes[9].ingredients[1].id 66
set recipes[9].ingredients[1].count 2
set recipes[9].ingredients.Length 2
set recipes[10].output.id spade
set recipes[10].output.count 8
set recipes[10].condition usingWorkbench
set recipes[10].ingredients[0].id 58
set recipes[10].ingredients[0].count 1
set recipes[10].ingredients[1].id 66
set recipes[10].ingredients[1].count 2
set recipes[10].ingredients.Length 2
set recipes[11].output.id spade
set recipes[11].output.count 6
set recipes[11].condition usingWorkbench
set recipes[11].ingredients[0].id 55
set recipes[11].ingredients[0].count 1
set recipes[11].ingredients[1].id 66
set recipes[11].ingredients[1].count 2
set recipes[11].ingredients.Length 2
set recipes[12].output.id spade
set recipes[12].output.count 3
set recipes[12].condition usingWorkbench
set recipes[12].ingredients[0].id 56
set recipes[12].ingredients[0].count 1
set recipes[12].ingredients[1].id 66
set recipes[12].ingredients[1].count 2
set recipes[12].ingredients.Length 2
set recipes[13].output.id spade
set recipes[13].output.count 2
set recipes[13].condition usingWorkbench
set recipes[13].ingredients[0].id 4
set recipes[13].ingredients[0].count 1
set recipes[13].ingredients[1].id 66
set recipes[13].ingredients[1].count 2
set recipes[13].ingredients.Length 2
set recipes[14].output.id spade
set recipes[14].output.count 1
set recipes[14].condition usingWorkbench
set recipes[14].ingredients[0].id 5
set recipes[14].ingredients[0].count 1
set recipes[14].ingredients[1].id 66
set recipes[14].ingredients[1].count 2
set recipes[14].ingredients.Length 2
set recipes[15].ingredients[0].id 5
set recipes[15].ingredients[0].count 2
set recipes[15].ingredients.Length 1
set recipes[15].output.id 66
set recipes[15].output.count 4
set recipes[16].ingredients[0].id 17
set recipes[16].ingredients[0].count 1
set recipes[16].ingredients.Length 1
set recipes[16].output.id 5
set recipes[16].output.count 4
set recipes[17].ingredients[0].id 5
set recipes[17].ingredients[0].count 4
set recipes[17].ingredients.Length 1
set recipes[17].output.id 61
set recipes[17].output.count 1
set recipes.Length 18
set toollevel[0] &cNo
set toollevel[1] &sWooden
set toollevel[2] &7Stone
set toollevel[3] &fIron
set toollevel[6] &6Golden
set toollevel[8] &bDiamond
set toollevel.Length 3
set deathmessages.fire @color@nick&f went up in flames
set deathmessages.fall @color@nick&f hit the ground too hard
set deathmessages.burn @color@nick&f was burnt to a crisp
set deathmessages.magma @color@nick&f discovered the floor was lava
set deathmessages.drown @color@nick&f drowned
set deathmessages.freeze @color@nick&f froze to death
set deathmessages.lava @color@nick&f tried to swim in lava
set deathmessages.suffocation @color@nick&f suffocated in a wall
set deathmessages.explosion @color@nick&f blew up

	// compat with id finder thingy
	set blocks[pickaxe].name Pickaxe
	set blocks[axe].name Axe
	set blocks[spade].name Spade

	set isTool(pickaxe) true
	set isTool(axe) true
	set isTool(spade) true

	cmd oss #tick repeatable
quit

#tick
	call #getblock|{PlayerX}|{PlayerY}|{PlayerZ}
	ifnot blocks[{id}].damage|=|"" call #damage|{blocks[{id}].damage}|{blocks[{id}].damageType}
	ifnot PlayerCoords|=|PrevPlayerCoords set usingWorkbench false
	set PrevPlayerCoords {PlayerCoords}
	delay 100
	cpemsg top1 &c{actionCount}/60000
	if hp|=|prevhp jump #ifnot_qEwCgLCZJPwtXUVg
		set prevhp hp
		call #makebar|hpbar|c|{hp}|{maxhp}
		cpemsg bot1 &c♥ {hpbar}
	#ifnot_qEwCgLCZJPwtXUVg
	if inventory[{PlayerHeldBlock}]|>|0 cpemsg bot2 Holding: &6{blocks[{PlayerHeldBlock}].name} &f(x{inventory[{PlayerHeldBlock}]})
	else cpemsg bot2 Holding: &cNothing
	cpemsg bot3 {toollevel[{pickaxe}]} Pickaxe &f| {toollevel[{axe}]} Axe &f| {toollevel[{spade}]} Spade
	ifnot iframes|>|0 jump #if_lPCJXjItsdCfQcjP
		setsub iframes 1
		if iframes|<|2 gui barSize 0
		else gui barSize 1
	#if_lPCJXjItsdCfQcjP
	if actionCount|>=|60000 cmd oss #tick repeatable
	if actionCount|>|60000 terminate
jump #tick

#damage
	if iframes|>|0 quit
	setsub hp {runArg1}
	set iframes 4
	cs me ow
	ifnot hp|<|0 jump #if_kCSznEoaCTsMVVZI
		kill {deathmessages.{runArg2}}
		set hp {maxhp}
	#if_kCSznEoaCTsMVVZI
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
	call #getblock|{runArg1}|{runArg2}|{runArg3}
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
	ifnot minetimer|>|0 jump #if_ZmeokVgiEFqxTNcj
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
	#if_ZmeokVgiEFqxTNcj
	set minepos
	if toomuch jump #ifnot_GFYHJgciqRYMcjds
		if label #loot[{id}] call #loot[{id}]
		else call #give|{id}|1
	#ifnot_GFYHJgciqRYMcjds
	if blocks[{id}].remainder|=|"" set empty 0
	else set empty {blocks[{id}].remainder}
	jump #setblock|{empty}|{x}|{y}|{z}
quit

#give
	ifnot isTool({runArg1}) jump #if_ZTGVwlUluvczhnDe
		set {runArg1} {runArg2}
		quit
	#if_ZTGVwlUluvczhnDe
	if inventory[{runArg1}]|=|0 cmd holdsilent {runArg1}
	setadd inventory[{runArg1}] {runArg2}
quit

#take
	setsub inventory[{runArg1}] {runArg2}
	if inventory[{runArg1}]|<|0 set inventory[{runArg1}] 0
	if inventory[{runArg1}]|=|0 cmd holdsilent 0
quit

#place
	set x {runArg1}
	set y {runArg2}
	set z {runArg3}
	call #getblock|{x}|{y}|{z}
	if label #use[{id}] jump #use[{id}]
	if blocks[{id}].replaceable quit
	if click.face|=|"AwayX" setadd x 1
	if click.face|=|"AwayY" setadd y 1
	if click.face|=|"AwayZ" setadd z 1
	if click.face|=|"TowardsX" setsub x 1
	if click.face|=|"TowardsY" setsub y 1
	if click.face|=|"TowardsZ" setsub z 1
	call #getblock|{x}|{y}|{z}
	ifnot blocks[{id}].replaceable quit
	if blocks[{PlayerHeldBlock}].replaceable jump #ifnot_HjfPANJHsXqfADHv
		ifnot inventory[{PlayerHeldBlock}]|>|0 msg &cYou don't have any &f{blocks[{PlayerHeldBlock}].name}!
	#ifnot_HjfPANJHsXqfADHv
	ifnot inventory[{PlayerHeldBlock}]|>|0 jump #if_QLksxfkbrGkOMGjS
		call #take|{playerHeldBlock}|1
		jump #setblock|{PlayerHeldBlock}|{x}|{y}|{z}
	#if_QLksxfkbrGkOMGjS
quit

#pick
	call #getblock|{runArg1}|{runArg2}|{runArg3}
	cmd holdsilent {id}
quit

#getblock
	set id {world[{runArg1},{runArg2},{runArg3}]}
	if id|=|"" setblockid id {runArg1} {runArg2} {runArg3}
quit

#setblock
	tempblock {runArg1} {runArg2} {runArg3} {runArg4}
	set world[{runArg2},{runArg3},{runArg4}] {runArg1}
quit

#makebar
// package, color, amount, max
	set i 0
	set {runArg1} &{runArg2}
	ifnot i|<|{runArg3} jump #if_UxLZVjDilJSyyyKX
		#while_AlDsUEIAjmVaDfKW
			set {runArg1} {{runArg1}}|
			setadd i 1
		if i|<|{runArg3} jump #while_AlDsUEIAjmVaDfKW
	#if_UxLZVjDilJSyyyKX
	set {runArg1} {{runArg1}}&0
	ifnot i|<|{runArg4} jump #if_vbERzKsNQUHumLYm
		#while_geNdcvbsVeQvFcuu
			set {runArg1} {{runArg1}}|
			setadd i 1
		if i|<|{runArg4} jump #while_geNdcvbsVeQvFcuu
	#if_vbERzKsNQUHumLYm
quit

#input
	ifnot runArg1|=|"craft" jump #if_cyvmTFjlxDSdmOWS
		set craftArgs {runArg2}
		if craftArgs|=|"" jump #ifnot_JpAfrDBHOwrqNazd
			set craftArgs[1] 1
			setsplit craftArgs *
			if isTool({craftArgs[0]}) set craftArgs[1] 1
			call #getBlockByName|blockID|{craftArgs[0]}
			ifnot blockID|=|"" jump #if_fzbsxYlCLgqeBMDg
				msg &cInvalid item name or ID
				quit
			#if_fzbsxYlCLgqeBMDg
			call #getRecipeByOutput|recipeID|{blockID}|{craftArgs[1]}
			ifnot recipeID|=|"" jump #if_qdPwQxohuGpNgUvP
				msg &cYou do not have the materials to craft {blocks[{blockID}].name}!
				quit
			#if_qdPwQxohuGpNgUvP
			call #doCraft|{recipeID}|{craftArgs[1]}
			quit
		#ifnot_JpAfrDBHOwrqNazd
		if usingWorkbench msg &eWorkbench Recipes:
		else msg &eRecipes:
		set i 0
		#while_CFrAsyIJFBXHTgEn
			call #checkRecipeAfford|{i}|canAfford|1
			set ingrediantList
			ifnot canAfford jump #if_OIlnCgSWeHrCNvAU
				ifnot isTool({recipes[{i}].output.id}) msg &f> &6{blocks[{recipes[{i}].output.id}].name}&f (x{recipes[{i}].output.count}):
				else msg &f> {toollevel[{recipes[{i}].output.count}]} {blocks[{recipes[{i}].output.id}].name}&f:
				set j 0
				#while_rKPbuLAZkkgGGsgi
					set text {recipes[{i}].ingredients[{j}].count} {blocks[{recipes[{i}].ingredients[{j}].id}].name}
					if ingrediantList|=|"" set ingrediantList &f    {text}
					else set ingrediantList {ingrediantList}, {text}
					setadd j 1
				if j|<|{recipes[{i}].ingredients.Length} jump #while_rKPbuLAZkkgGGsgi
				msg {ingrediantList}
			#if_OIlnCgSWeHrCNvAU
			setadd i 1
		if i|<|{recipes.Length} jump #while_CFrAsyIJFBXHTgEn
		msg &eType &a/in craft [name]&e to craft something
		quit
	#if_cyvmTFjlxDSdmOWS
	set i 0
	msg &eResources:
	#while_ubgPQsJzikzfGJHa
		ifnot inventory[{i}]|=|0 msg &f> &6{blocks[{i}].name}&f (x{inventory[{i}]})
		setadd i 1
	if i|<|{blocks.Length} jump #while_ubgPQsJzikzfGJHa
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
	#while_NcogkxRghGoiLCLu
		set id {recipes[{recipeID}].ingredients[{j}].id}
		set count {recipes[{recipeID}].ingredients[{j}].count}
		setmul count {recipeCount}
		call #take|{id}|{count}
		setadd j 1
	if j|<|{recipes[{recipeID}].ingredients.Length} jump #while_NcogkxRghGoiLCLu
	set count {recipes[{recipeID}].output.count}
	setmul count {recipeCount}
	call #give|{blockID}|{count}
	ifnot isTool({blockID}) msg &aCrafted {blocks[{blockID}].name} x{count}
	else msg &aCrafted {toollevel[{count}]} {blocks[{blockID}].name}
quit

#checkRecipeAfford
	set j 0
	set {runArg2} false
	if recipes[{runArg1}].condition|=|"" jump #ifnot_LrdSAVnkCeGNnAMZ
		ifnot {recipes[{runArg1}].condition} quit
	#ifnot_LrdSAVnkCeGNnAMZ
	ifnot isTool({recipes[{runArg1}].output.id}) jump #if_EJlMkjhVKGisjEvb
		if {recipes[{runArg1}].output.id}|>=|recipes[{runArg1}].output.count quit
	#if_EJlMkjhVKGisjEvb
	#while_CBtOVmTMxawvjqIy
		set id {recipes[{runArg1}].ingredients[{j}].id}
		set count {recipes[{runArg1}].ingredients[{j}].count}
		setmul count {runArg3}
		if count|>|{inventory[{id}]} quit
		setadd j 1
	if j|<|{recipes[{runArg1}].ingredients.Length} jump #while_CBtOVmTMxawvjqIy
	set {runArg2} true
quit

#getBlockByName
	set {runArg1}
	if blocks[{runArg2}].name|=|"" jump #ifnot_ZAuBrMSIPbTlofIz
		set {runArg1} {runArg2}
		quit
	#ifnot_ZAuBrMSIPbTlofIz
	set i 0
	#while_rDLGruNSLJlurGnS
		ifnot blocks[{i}].name|=|runArg2 jump #if_wuFPwSvNVYHwKfEv
			set {runArg1} {i}
			quit
		#if_wuFPwSvNVYHwKfEv
		setadd i 1
	if i|<|{blocks.Length} jump #while_rDLGruNSLJlurGnS
quit

#getRecipeByOutput
	set pname {runArg1}
	set bid {runArg2}
	set c {runArg3}
	set {pname}
	set i 0
	#while_QQRecDbxcjFqYWUW
		ifnot recipes[{i}].output.id|=|bid jump #if_lnmUsJpQwoJJUjiX
			call #checkRecipeAfford|{i}|canAfford|{c}
			ifnot canAfford jump #if_aRIOFyUhIOjtiZpW
				set {pname} {i}
				quit
			#if_aRIOFyUhIOjtiZpW
		#if_lnmUsJpQwoJJUjiX
		setadd i 1
	if i|<|{recipes.Length} jump #while_QQRecDbxcjFqYWUW
quit

#use[61]
	set usingWorkbench true
	call #input|craft
quit

#use[62]
	msg stonecutter used
quit

#use[67]
	msg campfire used
quit

#use[68]
	msg lit campfire used
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
setrandrange count 3 6
jump #give|39|{count}

#loot[64]
setrandrange count 3 6
jump #give|40|{count}

#loot[20]
#loot[50]
#loot[54]
#loot[60]
#loot[68]
#loot[69]
quit