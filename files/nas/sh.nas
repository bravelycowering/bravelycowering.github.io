using allow_include

// section start Time

	// units to convert:
	// milliseconds
	// seconds
	// minutes
	// hours
	// days
	// weeks
	// years

	#Time:ms->seconds
		setdiv {runArg1} 1000
		setrounddown {runArg1}
	quit

	#Time:ms->minutes
		setdiv {runArg1} 60000
		setrounddown {runArg1}
	quit

	#Time:ms->hours
		setdiv {runArg1} 3600000
		setrounddown {runArg1}
	quit

	#Time:ms->days
		setdiv {runArg1} 86400000
		setrounddown {runArg1}
	quit

	#Time:ms->weeks
		setdiv {runArg1} 604800000
		setrounddown {runArg1}
	quit

	#Time:ms->years
		setdiv {runArg1} 31536000000
		setrounddown {runArg1}
	quit

// section end

// section start Date

	#Date:settotalminutes
	// pkgname, ms (epochMS)
		if runArg2|=|"" set {runArg1} {epochMS}
		else set {runArg1} {runArg2}
		setdiv {runArg1} 86400000
		setrounddown {runArg1}
	quit

	#Date:settotalhours
	// pkgname, ms (epochMS)
		if runArg2|=|"" set {runArg1} {epochMS}
		else set {runArg1} {runArg2}
		setdiv {runArg1} 86400000
		setrounddown {runArg1}
	quit

	#Date:settotaldays
	// pkgname, ms (epochMS)
		if runArg2|=|"" set {runArg1} {epochMS}
		else set {runArg1} {runArg2}
		setdiv {runArg1} 86400000
		setrounddown {runArg1}
	quit

	#Date:setyear
	// pkgname, ms (epochMS)
		if runArg2|=|"" set {runArg1} {epochMS}
		else set {runArg1} {runArg2}
		setdiv {runArg1} 31536000000
		setrounddown {runArg1}
	quit

// section end

#onJoin
	call #Date:setday|currentday
	msg {currentday}
quit