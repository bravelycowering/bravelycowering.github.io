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

	include struct blocks survival/blocks
	include struct recipes survival/recipes
	include struct toollevel survival/toollevel

	call #updateToolDisplay
quit

#updateToolDisplay
	cpemsg bot1 {toollevel[{pickaxe}]} Pickaxe
	cpemsg bot2 {toollevel[{axe}]} Axe
	cpemsg bot3 {toollevel[{shovel}]} Spade
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
		cmd tempbot tp minemeter {x} {boty} {z} 0 0
		quit
	end
	set minepos
	ifnot toomuch then
		if label #loot[{id}] call #loot[{id}]
		else call #give|{id}|1
	end
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
	ifnot blocks[{PlayerHeldBlock}].replaceable then
		ifnot inventory[{PlayerHeldBlock}]|>|0 msg &cYou don't have any &f{blocks[{PlayerHeldBlock}].name}!
	end
	if inventory[{PlayerHeldBlock}]|>|0 then
		setsub inventory[{PlayerHeldBlock}] 1
		if inventory[{PlayerHeldBlock}]|=|0 cmd holdsilent 0
		jump #setblock|{PlayerHeldBlock}|{x}|{y}|{z}
	end
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
	while if i|<|{runArg3}
		set {runArg1} {{runArg1}}|
		setadd i 1
	end
	set {runArg1} {{runArg1}}&0
	while if i|<|{runArg4}
		set {runArg1} {{runArg1}}|
		setadd i 1
	end
quit

#input
	if runArg1|=|"craft" then
		set craftArgs {runArg2}
		ifnot craftArgs|=|"" then
			set craftArgs[1] 1
			setsplit craftArgs *
			call #getBlockByName|blockID|{craftArgs[0]}
			if blockID|=|"" then
				msg &cInvalid item name or ID
				quit
			end
			call #getRecipeByOutput|recipeID|{blockID}
			if recipeID|=|"" then
				msg &cYou cannot craft {blocks[{blockID}].name}!
				quit
			end
			call #doCraft|{recipeID}|{craftArgs[1]}
			quit
		end
		msg &eRecipes:
		set i 0
		while if i|<|{recipes.Length}
			call #checkRecipeAfford|{i}|canAfford|1
			set ingrediantList
			if canAfford then
				msg &f> &6{blocks[{recipes[{i}].output.id}].name}&f (x{recipes[{i}].output.count}):
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
	msg &f> {toollevel[{shovel}]} Spade
	msg &eType &a/in craft&e to show the crafting menu.
quit

#doCraft
	set recipeID {runArg1}
	set blockID {recipes[{recipeID}].output.id}
	set recipeCount {runArg2}
	call #checkRecipeAfford|{recipeID}|canAfford|recipeCount
	if canAfford then
		set j 0
		while if j|<|{recipes[{recipeID}].ingredients.Length}
			set id {recipes[{recipeID}].ingredients[{j}].id}
			set count {recipes[{recipeID}].ingredients[{j}].count}
			setmul count {recipeCount}
			setsub inventory[{id}] {count}
			setadd j 1
		end
		set count {recipes[{recipeID}].output.count}
		setmul count {recipeCount}
		setadd inventory[{blockID}] {count}
		msg &aCrafted {blocks[{blockID}].name} x{count}
		quit
	end
	msg &cYou do not have the materials for that!
quit

#checkRecipeAfford
	set j 0
	while if j|<|{recipes[{runArg1}].ingredients.Length}
		set id {recipes[{runArg1}].ingredients[{j}].id}
		set count {recipes[{runArg1}].ingredients[{j}].count}
		setmul count {runArg3}
		if count|>|{inventory[{id}]} then
			set {runArg2} false
			quit
		end
		setadd j 1
	end
	set {runArg2} true
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
	set {runArg1}
	set i 0
	while if i|<|{recipes.Length}
		if recipes[{i}].output.id|=|runArg2 then
			set {runArg1} {i}
			quit
		end
		setadd i 1
	end
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