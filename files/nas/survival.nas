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
	setblockid id {runArg1} {runArg2} {runArg3}
	setadd inv_{id} 1
	if inv_{id}|=|1 cmd holdsilent {id}
	jump #setblock|0|{runArg1}|{runArg2}|{runArg3}
quit

#place
	ifnot inv_{PlayerHeldBlock}|>|0 msg &cYou don't have any &f{name_{PlayerHeldBlock}}!
	ifnot inv_{PlayerHeldBlock}|>|0 quit
	setsub inv_{PlayerHeldBlock} 1
	set x {runArg1}
	set y {runArg2}
	set z {runArg3}
	if click.face|=|"AwayX" setadd x 1
	if click.face|=|"AwayY" setadd y 1
	if click.face|=|"AwayZ" setadd z 1
	if click.face|=|"TowardsX" setsub x 1
	if click.face|=|"TowardsY" setsub y 1
	if click.face|=|"TowardsZ" setsub z 1
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

#input
	set i 0
	msg &eYour inventory:
	#invLoop
		if inv_{i}|>|0 msg &f> &6{name_{i}}&f (x{inv_{i}})
		setadd i 1
	if i|<|{maxBlockId} jump #invLoop
quit

#onJoin
	clickevent sync register #click
	msg &fType &a/in&f to view your &ainventory&f.
	set unbreakable_0 true
	set unbreakable_7 true
	set unbreakable_8 true
	set unbreakable_9 true
	set unbreakable_10 true
	set unbreakable_11 true
	set replaceable_0 true
	set replaceable_8 true
	set replaceable_9 true
	set replaceable_10 true
	set replaceable_11 true
	set remainder_50 10
	set remainder_60 8
	set maxBlockId 60
	set name_0 Air
	set name_1 Stone
	set name_2 Grass
	set name_3 Dirt
	set name_4 Cobblestone
	set name_5 Wood
	set name_6 Sapling
	set name_7 Bedrock
	set name_8 Water
	set name_9 Still water
	set name_10 Lava
	set name_11 Still lava
	set name_12 Sand
	set name_13 Gravel
	set name_14 Gold ore
	set name_15 Iron ore
	set name_16 Coal ore
	set name_17 Log
	set name_18 Leaves
	set name_19 Sponge
	set name_20 Glass
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
	set name_42 Iron
	set name_43 Double slab
	set name_44 Slab
	set name_45 Brick
	set name_46 TNT
	set name_47 Bookshelf
	set name_48 Mossy rocks
	set name_49 Obsidian
	set name_50 Magma
	set name_51 Coal
	set name_52 Diamond ore
	set name_53 Diamond
	set name_54 Fire
	set name_55 Gold bar
	set name_56 Iron bar
	set name_57 Coal lump
	set name_58 Diamond gem
	set name_59 Stone brick
	set name_60 Ice
quit