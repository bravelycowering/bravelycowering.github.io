using allow_include
using local_packages

// section start Date

	#Date:setday
	// pkgname, ms (epochMS)
		if runArg2|=|"" set {runArg1} {epochMS}
		else set {runArg1} {runArg2}
		setdiv {runArg1} 86400000
		setrounddown {runArg1}
	quit

// section end/afk

#onJoin
	call #Date:setday|currentday
	msg {currentday}
quit