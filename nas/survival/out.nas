#onJoin
	clickevent sync register #click
	reach 5
	set minetimer 0
	set minepos
	set pickaxe 0
	set axe 0
	set shovel 0
	cmd holdsilent 0
	msg &fYou can place and break blocks freely in this map.
	msg &fType &a/in&f to view your &ainventory&f.

	call #updateToolDisplay

set blocks[0].name Air
set blocks[0].unbreakable true
set blocks[0].replaceable true
set blocks[1].tooltype pickaxe
set blocks[1].name Stone
set blocks[1].hardness 8
set blocks[1].toughness 1
set blocks[2].tooltype shovel
set blocks[2].name Grass
set blocks[2].hardness 3
set blocks[3].tooltype shovel
set blocks[3].name Dirt
set blocks[3].hardness 3
set blocks[4].tooltype pickaxe
set blocks[4].name Cobblestone
set blocks[4].hardness 6
set blocks[4].toughness 1
set blocks[5].tooltype axe
set blocks[5].name Wood
set blocks[5].hardness 6
set blocks[6].name Sapling
set blocks[7].unbreakable true
set blocks[7].name Bedrock
set blocks[8].name Water
set blocks[8].unbreakable true
set blocks[8].replaceable true
set blocks[9].name Still water
set blocks[9].unbreakable true
set blocks[9].replaceable true
set blocks[10].name Lava
set blocks[10].unbreakable true
set blocks[10].replaceable true
set blocks[11].name Still lava
set blocks[11].unbreakable true
set blocks[11].replaceable true
set blocks[12].tooltype shovel
set blocks[12].name Sand
set blocks[12].hardness 3
set blocks[13].tooltype shovel
set blocks[13].name Gravel
set blocks[13].hardness 3
set blocks[14].tooltype pickaxe
set blocks[14].name Gold ore
set blocks[14].hardness 24
set blocks[14].toughness 3
set blocks[15].tooltype pickaxe
set blocks[15].name Iron ore
set blocks[15].hardness 16
set blocks[15].toughness 2
set blocks[16].tooltype pickaxe
set blocks[16].name Coal ore
set blocks[16].hardness 12
set blocks[16].toughness 1
set blocks[17].tooltype axe
set blocks[17].name Log
set blocks[17].hardness 8
set blocks[18].tooltype axe
set blocks[18].name Leaves
set blocks[18].hardness 2
set blocks[19].tooltype shovel
set blocks[19].name Sponge
set blocks[19].hardness 3
set blocks[20].tooltype pickaxe
set blocks[20].name Glass
set blocks[20].hardness 2
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
set blocks[41].tooltype pickaxe
set blocks[41].name Gold
set blocks[41].hardness 24
set blocks[41].toughness 3
set blocks[42].tooltype pickaxe
set blocks[42].name Iron
set blocks[42].hardness 16
set blocks[42].toughness 2
set blocks[43].tooltype pickaxe
set blocks[43].name Double slab
set blocks[43].hardness 8
set blocks[43].toughness 1
set blocks[44].tooltype pickaxe
set blocks[44].name Slab
set blocks[44].hardness 4
set blocks[44].toughness 1
set blocks[45].tooltype pickaxe
set blocks[45].name Brick
set blocks[45].hardness 6
set blocks[45].toughness 1
set blocks[46].name TNT
set blocks[47].tooltype axe
set blocks[47].name Bookshelf
set blocks[47].hardness 6
set blocks[48].tooltype pickaxe
set blocks[48].name Mossy rocks
set blocks[48].hardness 9
set blocks[48].toughness 1
set blocks[49].tooltype pickaxe
set blocks[49].name Obsidian
set blocks[49].hardness 60
set blocks[49].toughness 8
set blocks[50].tooltype pickaxe
set blocks[50].name Magma
set blocks[50].hardness 5
set blocks[50].remainder 10
set blocks[51].tooltype pickaxe
set blocks[51].name Coal
set blocks[51].hardness 12
set blocks[51].toughness 1
set blocks[52].tooltype pickaxe
set blocks[52].name Diamond ore
set blocks[52].hardness 32
set blocks[52].toughness 3
set blocks[53].tooltype pickaxe
set blocks[53].name Diamond
set blocks[53].hardness 32
set blocks[53].toughness 3
set blocks[54].name Fire
set blocks[55].name Gold bar
set blocks[56].name Iron bar
set blocks[57].name Coal lump
set blocks[58].name Diamond gem
set blocks[59].tooltype pickaxe
set blocks[59].name Stone brick
set blocks[59].hardness 8
set blocks[59].toughness 1
set blocks[60].tooltype pickaxe
set blocks[60].name Ice
set blocks[60].hardness 3
set blocks[60].remainder 8
set blocks[61].tooltype axe
set blocks[61].name Workbench
set blocks[61].hardness 8
set blocks[62].tooltype pickaxe
set blocks[62].name Stonecutter
set blocks[62].hardness 8
set blocks[63].tooltype shovel
set blocks[63].name Brown mushroom top
set blocks[63].hardness 4
set blocks[64].tooltype shovel
set blocks[64].name Red mushroom top
set blocks[64].hardness 4
set blocks[65].tooltype shovel
set blocks[65].name Mushroom stem
set blocks[65].hardness 8
set blocks[66].name Stick
set blocks[67].tooltype axe
set blocks[67].name Campfire
set blocks[67].hardness 3
set blocks[68].remainder 67
set blocks[68].name Lit campfire
set blocks[69].tooltype shovel
set blocks[69].name Cobweb
set blocks[69].hardness 5
set blocks[70].name Torch
set blocks.Length 71
set recipes[0].ingredients[0].id 5
set recipes[0].ingredients[0].count 2
set recipes[0].ingredients.Length 1
set recipes[0].output.id 66
set recipes[0].output.count 4
set recipes[1].ingredients[0].id 17
set recipes[1].ingredients[0].count 1
set recipes[1].ingredients.Length 1
set recipes[1].output.id 5
set recipes[1].output.count 4
set recipes.Length 2
set toollevel.6 &6Golden
set toollevel.0 &cNo
set toollevel.1 &sWooden
set toollevel.2 &7Stone
set toollevel.3 &fIron
set toollevel.8 &bDiamond
quit

#updateToolDisplay
	cpemsg bot1 {toollevel.{pickaxe}} Pickaxe
	cpemsg bot2 {toollevel.{axe}} Axe
	cpemsg bot3 {toollevel.{shovel}} Spade
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
	if toomuch set barcol C
	else set barcol a
	setsub minetimer {minespeed}
	ifnot minetimer|>|0 jump #if_FIAAjXFzqUROXNNk
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
	#if_FIAAjXFzqUROXNNk
	set minepos
	if toomuch jump #ifnot_ZQFBRMgVkXSqkJlq
		if label #loot[{id}] call #loot[{id}]
		else call #give|{id}|1
	#ifnot_ZQFBRMgVkXSqkJlq
	if blocks[{id}].remainder|=|"" set empty 0
	else set empty {blocks[{id}].remainder}
	jump #setblock|{empty}|{x}|{y}|{z}
quit

#give
	if inventory[{runArg1}]|=|0 cmd holdsilent {runArg1}
	setadd inventory[{runArg1}] {runArg2}
quit

#place
	set x {runArg1}
	set y {runArg2}
	set z {runArg3}
	call #getblock|{x}|{y}|{z}
	if blocks[{id}].replaceable quit
	if click.face|=|"AwayX" setadd x 1
	if click.face|=|"AwayY" setadd y 1
	if click.face|=|"AwayZ" setadd z 1
	if click.face|=|"TowardsX" setsub x 1
	if click.face|=|"TowardsY" setsub y 1
	if click.face|=|"TowardsZ" setsub z 1
	call #getblock|{x}|{y}|{z}
	ifnot blocks[{id}].replaceable quit
	if blocks[{PlayerHeldBlock}].replaceable jump #ifnot_lJMmpJlCJSnnAHGV
		ifnot inventory[{PlayerHeldBlock}]|>|0 msg &cYou don't have any &f{blocks[{PlayerHeldBlock}].name}!
	#ifnot_lJMmpJlCJSnnAHGV
	ifnot inventory[{PlayerHeldBlock}]|>|0 jump #if_ZzbTusYabKXoQYYl
		setsub inventory[{PlayerHeldBlock}] 1
		if inventory[{PlayerHeldBlock}]|=|0 cmd holdsilent 0
		jump #setblock|{PlayerHeldBlock}|{x}|{y}|{z}
	#if_ZzbTusYabKXoQYYl
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
	#while_SGUMsPjwuJkrPrmS
		set {runArg1} {{runArg1}}|
		setadd i 1
	if i|<|{runArg3} jump #while_SGUMsPjwuJkrPrmS
	set {runArg1} {{runArg1}}&0
	#while_bcSxkDxZmPhbaLaF
		set {runArg1} {{runArg1}}|
		setadd i 1
	if i|<|{runArg4} jump #while_bcSxkDxZmPhbaLaF
quit

#input
	ifnot runArg1|=|"craft" jump #if_KFvpAUhKQZLtlvDk
		set craftArgs {runArg2}
		if craftArgs|=|"" jump #ifnot_PttPJJBULsVrmKWm
			set craftArgs[1] 1
			setsplit craftArgs *
			call #getBlockByName|blockID|{craftArgs[0]}
			ifnot blockID|=|"" jump #if_TZLOHNDMDYBzurnt
				msg &cInvalid item name or ID
				quit
			#if_TZLOHNDMDYBzurnt
			call #getRecipeByOutput|recipeID|{blockID}
			ifnot recipeID|=|"" jump #if_SBeGgVfHWsmARUhm
				msg &cYou cannot craft {blocks[{blockID}].name}!
				quit
			#if_SBeGgVfHWsmARUhm
			call #doCraft|{recipeID}|{craftArgs[1]}
			quit
		#ifnot_PttPJJBULsVrmKWm
		msg &eRecipes:
		set i 0
		#while_wlVJqxDTaNsYKIJK
			call #checkRecipeAfford|{i}|canAfford|1
			set ingrediantList
			ifnot canAfford jump #if_KeOSakVxmXdGVnEP
				msg &f> &6{blocks[{recipes[{i}].output.id}].name}&f (x{recipes[{i}].output.count}):
				set j 0
				#while_gynJfPSjPGCXOucw
					set text {recipes[{i}].ingredients[{j}].count} {blocks[{recipes[{i}].ingredients[{j}].id}].name}
					if ingrediantList|=|"" set ingrediantList &f    {text}
					else set ingrediantList {ingrediantList}, {text}
					setadd j 1
				if j|<|{recipes[{i}].ingredients.Length} jump #while_gynJfPSjPGCXOucw
				msg {ingrediantList}
			#if_KeOSakVxmXdGVnEP
			setadd i 1
		if i|<|{recipes.Length} jump #while_wlVJqxDTaNsYKIJK
		msg &eType &a/in craft [name]&e to craft something
		quit
	#if_KFvpAUhKQZLtlvDk
	set i 0
	msg &eResources:
	#while_ptIrfOzcXwNUdlbq
		ifnot inventory[{i}]|=|0 msg &f> &6{blocks[{i}].name}&f (x{inventory[{i}]})
		setadd i 1
	if i|<|{blocks.Length} jump #while_ptIrfOzcXwNUdlbq
	msg &eTools:
	msg &f> {toollevel.{pickaxe}} Pickaxe
	msg &f> {toollevel.{axe}} Axe
	msg &f> {toollevel.{shovel}} Spade
	msg &eType &a/in craft&e to show the crafting menu.
quit

#doCraft
	set recipeID {runArg1}
	set blockID {recipes[{recipeID}].output.id}
	set recipeCount {runArg2}
	call #checkRecipeAfford|{recipeID}|canAfford|recipeCount
	ifnot canAfford jump #if_xGMQqFaPBvqcByDZ
		set j 0
		#while_JCItMmlglftHuCgh
			set id {recipes[{recipeID}].ingredients[{j}].id}
			set count {recipes[{recipeID}].ingredients[{j}].count}
			setmul count {recipeCount}
			setsub inventory[{id}] {count}
			setadd j 1
		if j|<|{recipes[{recipeID}].ingredients.Length} jump #while_JCItMmlglftHuCgh
		set count {recipes[{recipeID}].output.count}
		setmul count {recipeCount}
		setadd inventory[{blockID}] {count}
		msg &aCrafted {blocks[{blockID}].name} x{count}
		quit
	#if_xGMQqFaPBvqcByDZ
	msg &cYou do not have the materials for that!
quit

#checkRecipeAfford
	set j 0
	#while_WyFwAbUjqNMQmprq
		set id {recipes[{runArg1}].ingredients[{j}].id}
		set count {recipes[{runArg1}].ingredients[{j}].count}
		setmul count {runArg3}
		ifnot count|>|{inventory[{id}]} jump #if_rlEzEXUSWuwijMAR
			set {runArg2} false
			quit
		#if_rlEzEXUSWuwijMAR
		setadd j 1
	if j|<|{recipes[{runArg1}].ingredients.Length} jump #while_WyFwAbUjqNMQmprq
	set {runArg2} true
quit

#getBlockByName
	set {runArg1}
	if blocks[{runArg2}].name|=|"" jump #ifnot_HAEhibnBlDTCJBds
		set {runArg1} {runArg2}
		quit
	#ifnot_HAEhibnBlDTCJBds
	set i 0
	#while_IUGqdBzEDBXJrZGi
		ifnot blocks[{i}].name|=|runArg2 jump #if_IFyGdbieemGTmzzg
			set {runArg1} {i}
			quit
		#if_IFyGdbieemGTmzzg
		setadd i 1
	if i|<|{blocks.Length} jump #while_IUGqdBzEDBXJrZGi
quit

#getRecipeByOutput
	set {runArg1}
	set i 0
	#while_TUBMwPvcuvUIRQDL
		ifnot recipes[{i}].output.id|=|runArg2 jump #if_sVAwwfquhQZouMny
			set {runArg1} {i}
			quit
		#if_sVAwwfquhQZouMny
		setadd i 1
	if i|<|{recipes.Length} jump #while_TUBMwPvcuvUIRQDL
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