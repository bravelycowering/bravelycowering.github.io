include os/shinyiris+towerlib

#onJoin
	call #map:{LevelName}
	msg You can enable setting checkpoints by pressing &aP&7 (or by typing &a/in practice&7)
	definehotkey practice|P
	definehotkey reset|R
	jump #resetTime
quit

#map:bravelycowering+minitower
	set ctohlib.is.in.parkour true
	set ctohlib.DEFAULT.MOTD -hax -push -slap model=humanoid|0.5 jumpheight=0.6
	msg &fWelcome to probably the most annoying map you will play today
quit

#map:bravelycowering+minitower2
	set ctohlib.is.in.parkour true
	set ctohlib.DEFAULT.MOTD -hax model=humanoid|0.5 jumpheight=0.65 jumps=2 -push -slap +thirdperson -aura
	msg &7I felt bad for making the last one so hard, so I'll give you an &aextra mid air jump&7 to beat this one
quit

#resetAllData
	placemessageblock air 0 1 0 ShinyIris+:&eShinyIris
quit

#showClearList
	setblockmessage data 0 1 0
	setsplit data ||
	set clears {data[0]}
	setsplit clears |
	if clears.Length|=|0 jump #showEmptyClearList
	set n {runArg1}
	if n|<|1 set n 1
	if n|>|clears.Length set n {clears.Length}
	msg Clears in order of completion:
	setsub n 1
	set start {n}
	setadd start 1
	set max {n}
	setadd max 10
	if max|>|clears.Length set max {clears.Length}
	#showClearListLoop
		set user {clears[{n}]}
		setsplit user :
		setadd n 1
		msg   {n}. {user[1]}
	if n|<|max jump #showClearListLoop
	setadd n 1
	set clearCountMsg Showing clears {start}-{max} (out of {clears.Length})
	if max|<|clears.Length set clearCountMsg {clearCountMsg} Next: &a/in clears {n}
	msg {clearCountMsg}
quit

#showEmptyClearList
	msg No one has beaten this map before, complete it to take the first clear!
quit

#tryAddSelfToClearList
	setblockmessage data 0 1 0
	setsplit data ||
	set clears {data[0]}
	set {runArg1} false
	if clears|has|"@p:" quit
	set clears {clears}|@p:@color@nick
	placemessageblock air 0 1 0 {clears}
	setlength clears |
	set {runArg1} {clears.Length}
quit

#reset
	kill
#resetTime
	set beaten false
	set startMS {epochMS}
quit

#input
	if runArg1|=|"clears" jump #showClearList|{runArg2}
	if runArg1|=|"practice" jump #CTOHLib_TogglePracticeMode
	if ctohlib.is.in.practice.mode quit
	if runArg1|=|"reset" jump #reset
quit

#CTOHLib_Trigger_PracticeModeOn
	msg Practice mode: &aON
quit

#CTOHLib_Trigger_PracticeModeOff
	msg Practice mode: &cOFF
jump #resetTime

#parseTime
	setdiv {runArg1} 1000
quit

#getNSuffixOverride[11]
#getNSuffixOverride[12]
#getNSuffixOverride[13]

#getNSuffix
	set n {{runArg1}}
	if label #getNSuffixOverride[{n}] jump #getNSuffix_3
	setmod n 10
	ifnot n|=|1 jump #getNSuffix_1
		set {runArg1} {{runArg1}}st
		quit
	#getNSuffix_1
	ifnot n|=|2 jump #getNSuffix_2
		set {runArg1} {{runArg1}}nd
		quit
	#getNSuffix_2
	ifnot n|=|3 jump #getNSuffix_3
		set {runArg1} {{runArg1}}rd
		quit
	#getNSuffix_3
	set {runArg1} {{runArg1}}th
quit

#win
	allowmbrepeat
	if beaten quit
	set beaten true
	if ctohlib.is.in.practice.mode jump #winPractice
	set final {epochMS}
	setsub final {startMS}
	call #parseTime|final
	call #tryAddSelfToClearList|clearNumber
	if clearNumber|=|"false" jump #localmsgClearNumber_end
		call #getNSuffix|clearNumber
		localmsg chat @color@p&7 becaome the &6{clearNumber}&7 person to complete &b{LevelName}&7!
	#localmsgClearNumber_end
	cpemsg announce &aCongrats on making it to the top!
	cpemsg smallannounce &fYou had a time of &6{final}s&f.
quit

#winPractice
	cpemsg announce Congrats on making it to the top!
	cpemsg smallannounce &bNow complete it without any checkpoints.
	jump #CTOHLib_TogglePracticeMode
quit
