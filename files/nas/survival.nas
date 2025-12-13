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
	if unbreakable_{id} quit
	ifnot minepos|=|coords set minetimer {hardness_{id}}
	ifnot minepos|=|coords set minepos {coords}
	set minespeed 1
	ifnot tooltype_{id}|=|"" setadd minespeed {tooltype_{id}}
	if toughness_{id}|>|{tooltype_{id}} set toomuch true
	else set toomuch false
	if tooltype_{id}|=|"" set toomuch false
	if toughness_{id}|=|"" set toomuch false
	if toomuch set barcol C
	else set barcol a
	setsub minetimer {minespeed}
	call #makebar|bar|{barcol}|{minetimer}|{hardness_{id}}
	if minetimer|>|0 cmd tempbot add minemeter -20 -20 -20 0 0 skin {bar}
	if minetimer|>|0 cmd tempbot tp minemeter {coords} 0 0
	if minetimer|>|0 cmd tempbot model minemeter bravelycowering+hitbox
	if minetimer|>|0 quit
	set minepos
	if toomuch jump #skipLoot
	if label #loot[{id}] call #loot[{id}]
	else call #give|{id}|1
	#skipLoot
	if remainder_{id}|=|"" set empty 0
	else set empty {remainder_{id}}
	jump #setblock|{empty}|{x}|{y}|{z}
quit

#give
	if inv_{runArg1}|=|0 cmd holdsilent {runArg1}
	setadd inv_{runArg1} {runArg2}
quit

#place
	set x {runArg1}
	set y {runArg2}
	set z {runArg3}
	call #getblock|{x}|{y}|{z}
	if replaceable_{id} quit
	if click.face|=|"AwayX" setadd x 1
	if click.face|=|"AwayY" setadd y 1
	if click.face|=|"AwayZ" setadd z 1
	if click.face|=|"TowardsX" setsub x 1
	if click.face|=|"TowardsY" setsub y 1
	if click.face|=|"TowardsZ" setsub z 1
	call #getblock|{x}|{y}|{z}
	ifnot replaceable_{id} quit
	if replaceable_{PlayerHeldBlock} jump #skipMsg
	ifnot inv_{PlayerHeldBlock}|>|0 msg &cYou don't have any &f{name_{PlayerHeldBlock}}!
	#skipMsg
	ifnot inv_{PlayerHeldBlock}|>|0 quit
	setsub inv_{PlayerHeldBlock} 1
	if inv_{PlayerHeldBlock}|=|0 cmd holdsilent 0
	jump #setblock|{PlayerHeldBlock}|{x}|{y}|{z}
quit

#pick
	call #getblock|{runArg1}|{runArg2}|{runArg3}
	cmd holdsilent {id}
quit

#getblock
	set id {block_{runArg1}_{runArg2}_{runArg3}}
	if id|=|"" setblockid id {runArg1} {runArg2} {runArg3}
quit

#setblock
	tempblock {runArg1} {runArg2} {runArg3} {runArg4}
	set block_{runArg2}_{runArg3}_{runArg4} {runArg1}
quit

#makebar
// package, color, amount, max
	set i 0
	set {runArg1} &{runArg2}
	#makebarLoop
		set {runArg1} {{runArg1}}|
		setadd i 1
	if i|<|{runArg3} jump #makebarLoop
	set {runArg1} {{runArg1}}&0
	#makebarLoop2
		set {runArg1} {{runArg1}}|
		setadd i 1
	if i|<|{runArg4} jump #makebarLoop2
quit

#input
	if runArg1|=|"craft" jump #input_craft|{runArg2}
	set i 0
	msg &eResources:
	#invLoop
		ifnot inv_{i}|=|0 msg &f> &6{name_{i}}&f (x{inv_{i}})
		setadd i 1
	if i|<|{maxBlockId} jump #invLoop
	msg &eTools:
	if pickaxe|=|0 msg &f> &cNo Pickaxe
	if pickaxe|=|1 msg &f> &sWooden Pickaxe
	if pickaxe|=|2 msg &f> &7Stone Pickaxe
	if pickaxe|=|3 msg &f> &fIron Pickaxe
	if pickaxe|=|6 msg &f> &6Golden Pickaxe
	if pickaxe|=|8 msg &f> &bDiamond Pickaxe
	if axe|=|0 msg &f> &cNo Axe
	if axe|=|1 msg &f> &sWooden Axe
	if axe|=|2 msg &f> &7Stone Axe
	if axe|=|3 msg &f> &fIron Axe
	if axe|=|6 msg &f> &6Golden Axe
	if axe|=|8 msg &f> &bDiamond Axe
	if shovel|=|0 msg &f> &cNo Spade
	if shovel|=|1 msg &f> &sWooden Spade
	if shovel|=|2 msg &f> &7Stone Spade
	if shovel|=|3 msg &f> &fIron Spade
	if shovel|=|6 msg &f> &6Golden Spade
	if shovel|=|8 msg &f> &bDiamond Spade
	msg &eType &a/in craft&e to show the crafting menu.
quit

#input_craft
	msg wip
quit

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

	set name_0 Air
	set unbreakable_0 true
	set replaceable_0 true
	set name_1 Stone
	set hardness_1 8
	set toughness_1 1
	set tooltype_1 pickaxe
	set name_2 Grass
	set hardness_2 3
	set tooltype_2 shovel
	set name_3 Dirt
	set hardness_3 3
	set tooltype_3 shovel
	set name_4 Cobblestone
	set hardness_4 6
	set toughness_4 1
	set tooltype_4 pickaxe
	set name_5 Wood
	set hardness_5 6
	set tooltype_5 axe
	set name_6 Sapling
	set name_7 Bedrock
	set unbreakable_7 true
	set name_8 Water
	set unbreakable_8 true
	set replaceable_8 true
	set name_9 Still water
	set unbreakable_9 true
	set replaceable_9 true
	set name_10 Lava
	set unbreakable_10 true
	set replaceable_10 true
	set name_11 Still lava
	set unbreakable_11 true
	set replaceable_11 true
	set name_12 Sand
	set hardness_12 3
	set tooltype_12 shovel
	set name_13 Gravel
	set hardness_13 3
	set tooltype_13 shovel
	set name_14 Gold ore
	set hardness_14 24
	set toughness_14 3
	set tooltype_14 pickaxe
	set name_15 Iron ore
	set hardness_15 16
	set toughness_15 2
	set tooltype_15 pickaxe
	set name_16 Coal ore
	set hardness_16 12
	set toughness_16 1
	set tooltype_16 pickaxe
	set name_17 Log
	set hardness_17 8
	set tooltype_17 axe
	set name_18 Leaves
	set hardness_18 2
	set tooltype_18 axe
	set name_19 Sponge
	set hardness_19 3
	set tooltype_19 shovel
	set name_20 Glass
	set hardness_20 2
	set tooltype_20 pickaxe
	set name_21 Red
	set name_22 Orange
	set name_23 Yellow
	set name_24 Lime
	set name_25 Green
	set name_26 Teal
	set name_27 Aqua
	set name_28 Cyan
	set name_29 Blue
	set name_30 Indigo
	set name_31 Violet
	set name_32 Magenta
	set name_33 Pink
	set name_34 Black
	set name_35 Gray
	set name_36 White
	set name_37 Dandelion
	set name_38 Rose
	set name_39 Brown mushroom
	set name_40 Red mushroom
	set name_41 Gold
	set hardness_41 24
	set toughness_41 3
	set tooltype_41 pickaxe
	set name_42 Iron
	set hardness_42 16
	set toughness_42 2
	set tooltype_42 pickaxe
	set name_43 Double slab
	set hardness_43 8
	set toughness_43 1
	set tooltype_43 pickaxe
	set name_44 Slab
	set hardness_44 4
	set toughness_44 1
	set tooltype_44 pickaxe
	set name_45 Brick
	set hardness_45 6
	set toughness_45 1
	set tooltype_45 pickaxe
	set name_46 TNT
	set name_47 Bookshelf
	set hardness_47 6
	set tooltype_47 axe
	set name_48 Mossy rocks
	set hardness_48 9
	set toughness_48 1
	set tooltype_48 pickaxe
	set name_49 Obsidian
	set hardness_49 60
	set toughness_49 8
	set tooltype_49 pickaxe
	set name_50 Magma
	set remainder_50 10
	set hardness_50 5
	set tooltype_50 pickaxe
	set name_51 Coal
	set hardness_51 12
	set toughness_51 1
	set tooltype_51 pickaxe
	set name_52 Diamond ore
	set hardness_52 32
	set toughness_52 3
	set tooltype_52 pickaxe
	set name_53 Diamond
	set hardness_53 32
	set toughness_53 3
	set tooltype_53 pickaxe
	set name_54 Fire
	set name_55 Gold bar
	set name_56 Iron bar
	set name_57 Coal lump
	set name_58 Diamond gem
	set name_59 Stone brick
	set hardness_59 8
	set tooltype_59 pickaxe
	set toughness_59 1
	set name_60 Ice
	set remainder_60 8
	set hardness_60 3
	set tooltype_60 pickaxe
	set name_61 Workbench
	set hardness_61 8
	set tooltype_61 axe
	set name_62 Stonecutter
	set hardness_62 8
	set tooltype_62 pickaxe
	set name_63 Brown mushroom top
	set hardness_63 4
	set tooltype_63 shovel
	set name_64 Red mushroom top
	set hardness_64 4
	set tooltype_64 shovel
	set name_65 Mushroom stem
	set hardness_65 8
	set tooltype_65 shovel
	set name_66 Stick
	set name_67 Campfire
	set hardness_67 3
	set tooltype_67 axe
	set name_68 Lit campfire
	set remainder_68 67
	set name_69 Cobweb
	set hardness_69 5
	set tooltype_69 shovel
	set name_70 Torch

	set maxBlockId 70
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