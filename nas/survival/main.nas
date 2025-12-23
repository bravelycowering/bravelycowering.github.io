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

	set worldSpawn {PlayerCoords}

	cmd holdsilent 0
	gui barColor #ff0000 0.25

	msg &fYou can place and break blocks freely in this map.
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

start
	local PrevPlayerCoords
	local prevhp
	local hpbar
	local myblock
	#tick
		call #getblock|*myblock|{PlayerX}|{PlayerY}|{PlayerZ}
		if blocks[{myblock}].catchFire set fireticks 100
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
		// cpemsg top1 &c{actionCount}/60000
		ifnot hp|=|*prevhp then
			set *prevhp {hp}
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
			if iframes|<|2 then
				gui barColor #ffcc00 0.15
				gui barSize 1
			end
			set firetickmod {fireticks}
			setmod firetickmod 10
			if firetickmod|=|0 call #damage|2|burn
		end
		if actionCount|>=|60000 cmd oss #tick repeatable
		if actionCount|>|60000 terminate
	jump #tick
end

#damage
	if iframes|>|0 quit
	setsub hp {runArg1}
	set iframes 4
	cs me ow:select(7)
	if hp|<=|0 then
		kill {deathmessages.{runArg2}}
		set fireticks 0
		set hp {maxhp}
	end
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
	if spawnblock|=|coords then
		set spawnblock
		setdeathspawn {worldSpawn} 0 0
	end
	jump #setblock|{empty}|{x}|{y}|{z}
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

#place
	set x {runArg1}
	set y {runArg2}
	set z {runArg3}
	call #getblock|id|{x}|{y}|{z}
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
	ifnot blocks[{PlayerHeldBlock}].replaceable then
		ifnot inventory[{PlayerHeldBlock}]|>|0 msg &cYou don't have any &f{blocks[{PlayerHeldBlock}].name}!
	end
	if inventory[{PlayerHeldBlock}]|>|0 then
		call #take|{playerHeldBlock}|1
		jump #setblock|{PlayerHeldBlock}|{x}|{y}|{z}
	end
quit

#pick
	call #getblock|id|{runArg1}|{runArg2}|{runArg3}
	cmd holdsilent {id}
quit

#getblock
	set {runArg1} {world[{runArg2},{runArg3},{runArg4}]}
	if {runArg1}|=|"" setblockid id {runArg2} {runArg3} {runArg4}
quit

#setblock
	tempblock {runArg1} {runArg2} {runArg3} {runArg4}
	set world[{runArg2},{runArg3},{runArg4}] {runArg1}
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

#input
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
			call #checkRecipeAfford|{i}|canAfford|1
			set ingrediantList
			if canAfford then
				ifnot isTool({recipes[{i}].output.id}) msg &f> &6{blocks[{recipes[{i}].output.id}].name}&f (x{recipes[{i}].output.count}):
				else msg &f> &6{blocks[{recipes[{i}].output.id}].name}&f ({toollevel[{recipes[{i}].output.count}]}&f):
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
	set {runArg2} false
	ifnot recipes[{runArg1}].condition|=|"" then
		ifnot {recipes[{runArg1}].condition} quit
	end
	if isTool({recipes[{runArg1}].output.id}) then
		if {recipes[{runArg1}].output.id}|>=|recipes[{runArg1}].output.count quit
	end
	while if j|<|{recipes[{runArg1}].ingredients.Length}
		set id {recipes[{runArg1}].ingredients[{j}].id}
		set count {recipes[{runArg1}].ingredients[{j}].count}
		setmul count {runArg3}
		if count|>|{inventory[{id}]} quit
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
	set pname {runArg1}
	set bid {runArg2}
	set c {runArg3}
	set {pname}
	set i 0
	while if i|<|{recipes.Length}
		if recipes[{i}].output.id|=|bid then
			call #checkRecipeAfford|{i}|canAfford|{c}
			if canAfford then
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
			call #setblock|68|{runArg1}|{runArg2}|{runArg3}
			call #take|{PlayerHeldBlock}|1
			call #give|{blocks[{PlayerHeldBlock}].campfireLighter}|1
		end
	end
	setdeathspawn {PlayerCoords} {PlayerYaw} {PlayerPitch}
	set spawnblock {runArg1} {runArg2} {runArg3}
	msg &fRespawn point set
quit

#use[68]
	ifnot blocks[{PlayerHeldBlock}].campfireLighter|=|"" then
		if inventory[{PlayerHeldBlock}]|>|0 then
			call #setblock|68|{runArg1}|{runArg2}|{runArg3}
			call #take|{PlayerHeldBlock}|1
			call #give|{blocks[{PlayerHeldBlock}].campfireLighter}|1
			quit
		end
	end
	setdeathspawn {PlayerCoords} {PlayerYaw} {PlayerPitch}
	set spawnblock {runArg1} {runArg2} {runArg3}
	msg &fRespawn point set
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
	include struct blocks survival/blocks
	include struct recipes survival/recipes
	include struct toollevel survival/toollevel
	include struct deathmessages survival/deathmessages
quit