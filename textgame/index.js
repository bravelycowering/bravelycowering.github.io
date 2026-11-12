let gamepre = document.getElementById("gamepre")
let gamelog = document.getElementById("game")

function splitOnce(str, delim) {
	const betterSplit = false
	if (betterSplit) {
		const left = str.indexOf(delim)
		if (left == -1) return str
		const [raw, ...args] = str.match(delim)
		const right = left + raw.length
	}
	// TODO: FIX ME
	return str.split(delim)
}

function style(st) {
	let gamespan
	if (gamelog.lastChild != null) {
		if (gamelog.lastChild.innerText == "") {
			gamelog.lastChild.remove()
		}
	}
	if (gamelog.lastChild == null) {
		gamespan = document.createElement("span")
	} else {
		gamespan = gamelog.lastChild.cloneNode()
	}
	gamespan.style.color = "white"
	gamespan.style.background = "black"
	if (st) Object.assign(gamespan.style, st)
	if (gamelog.lastChild != null) console.log(gamespan.style, gamelog.lastChild.style.cssText, gamespan.style.cssText)
	if (gamelog.lastChild == null || gamelog.lastChild.style.cssText != gamespan.style.cssText) {
		gamelog.appendChild(gamespan)
	}
}

function write(text) {
	gamelog.lastChild.innerText += text
	gamepre.scrollTop = gamepre.scrollHeight
}

function backspace() {
	if (gamelog.lastChild.innerText.length == 0 && gamelog.lastChild != gamelog.firstChild) {
		gamelog.lastChild.remove()
	}
	gamelog.lastChild.innerText = gamelog.lastChild.innerText.slice(0, -1)
}

function error(match, msg="Unknown error involving %s") {
	return {
		error: msg.replaceAll("%s", JSON.stringify(match[0])),
		index: match.index,
		match,
	}
}

let game
let settings = {
	textSpeed: 10
}

function setMode(mode) {
	// null, "input"
	game.mode = mode
	if (mode == "input") game.modeValue = ""
}

window.addEventListener("keydown", e => {
	if (e.target != document.body || e.ctrlKey) {
		return
	}
	if (e.key == "Backspace") {
		e.preventDefault()
	}
	if (game.mode == "input") {
		if (e.key.length == 1) {
			write(e.key)
			e.preventDefault()
			game.modeValue += e.key
		} else if (e.key == "Backspace") {
			if (game.modeValue.length > 0) {
				backspace()
				game.modeValue = game.modeValue.slice(0, -1)
			}
		} else if (e.key == "Enter") {
			write("\n")
			setMode(null)
			run()
		}
	}
})

function queue(cb) {
	game.queue.push(cb)
}

function pause(timeout) {
	clearTimeout(game.timeout)
	game.paused = true
	game.timeout = timeout
}

function unwrap(argstr) {
	return argstr.replaceAll(/\$([A-Za-z0-9_]+|\$)/gm, function(match, capture) {
		if (capture == "$") return "$"
		if (game.vars[capture] == null) return ""
		return game.vars[capture]
	})
}

function doAction(line, func, argstr) {
	if (func.unwrap) {
		argstr = func.unwrap(argstr)
	} else {
		argstr = unwrap(argstr)
	}
	func(line, argstr)
}

function run(pc) {
	const {script} = game
	if (pc != null) {
		if (typeof pc == "string") {
			pc = script.labels[pc]
		}
		game.pc = pc
	}
	game.paused = false
	clearTimeout(game.timeout)
	try {
		if (game.queue.length > 0) {
			const cb = game.queue.shift()
			return pause(setTimeout(run, cb()))
		}
		while (game.pc < script.lines.length && !game.paused) {
			const line = script.lines[game.pc]
			game.pc++
			doAction(line, line.func, line.argstr)
		}
	} catch (e) {
		if (e instanceof Error) throw e
		alert("oopsie dasies\n\n"+e.error+" at "+e.index)
	}
}

const actions = {}

function parseAction(str, index, checklabel=false) {
	const match = str.match(/(\S+)(?:[^\S\n]*(.+))?/)
	match.index = index
	let [ raw, cmd, argstr ] = match
	if (cmd[0] == '"') {
		argstr = raw
		cmd = '"'
	}
	if (argstr == null) argstr = ""
	if (checklabel && cmd[cmd.length-1] == ":" && cmd.length > 1) {
		return cmd.substring(0, cmd.length - 1)
	} else {
		const func = actions[cmd]
		if (func == null) {
			throw error(match, "Action "+JSON.stringify(cmd)+" doesn't exist!")
		}
		if (func.process) {
			argstr = func.process(match, argstr)
		}
		return {
			cmd,
			func,
			argstr,
		}
	}
}

function parseMsg(argstr) {
	let text = argstr.trim()
	if (text[text.length - 1] == '"' && text[0] == '"') {
		text = text.substring(1, text.length - 1)
	}
	return text
}

actions['"'] = function({}, argstr) {
	pause()
	let text = parseMsg(argstr)+"\n"
	for (let i = 0; i < text.length; i++) {
		let piece = text[i]
		let delay = settings.textSpeed
		if (i == text.length - 2) {
			delay += 100 + 10 * settings.textSpeed
		}
		queue(_ => {
			write(piece)
			return delay
		})
	}
	run()
}

actions.put = function({}, argstr) {
	write(parseMsg(argstr))
}

actions.print = function({}, argstr) {
	write(parseMsg(argstr)+"\n")
}

const setregex = /\s*([\+\-\*\/\%\^]?=)\s*/
actions.set = function({}, argstr) {
	const [varname, op, value] = splitOnce(argstr, setregex)
	if (op) {
		switch (op) {
			case "=":
				game.vars[varname] = value
			break
			case "+=":
				game.vars[varname] = (parseFloat(game.vars[varname]) + parseFloat(value)).toString()
			break
			case "-=":
				game.vars[varname] = (parseFloat(game.vars[varname]) - parseFloat(value)).toString()
			break
			case "*=":
				game.vars[varname] = (parseFloat(game.vars[varname]) * parseFloat(value)).toString()
			break
			case "/=":
				game.vars[varname] = (parseFloat(game.vars[varname]) / parseFloat(value)).toString()
			break
			case "%=":
				game.vars[varname] = (parseFloat(game.vars[varname]) % parseFloat(value)).toString()
			break
			case "^=":
				game.vars[varname] = (parseFloat(game.vars[varname]) ** parseFloat(value)).toString()
			break
		}
	} else {
		delete game.vars[varname]
	}
}

actions.goto = function({cmd, match}, argstr) {
	if (argstr == null) {
		throw error(match, "Not enough arguments to "+cmd)
	}
	let pc = game.script.labels[argstr.trim()]
	if (pc == null) {
		pc = parseFloat(argstr)
	}
	if (isNaN(pc)) {
		throw error(match, "Unknown label or number "+JSON.stringify(argstr))
	}
	game.pc = pc
	pause(setTimeout(run, 0))
}

actions.call = function(line, argstr) {
	game.stack.push(game.pc)
	return actions.goto(line)
}

actions.return = function({match}, argstr) {
	if (game.stack == 0) {
		throw error(match, "Nothing to return from")
	}
	game.pc = game.stack.pop()
}

actions.stop = function({}, argstr) {
	pause()
}

actions.ask = function({}, argstr) {
	if (argstr) write(parseMsg(argstr)+" ")
	pause()
	setMode("input")
	queue(_=>{
		game.vars.answer = game.modeValue
	})
}

const condregex = /\s*([=><!]=|[><])\s*/
function evalCond(match, condition) {
	const [left, op, right] = splitOnce(condition, condregex)
	console.log(left, op, right)
	const nleft = parseFloat(left)
	const nright = parseFloat(right)
	if (op) {
		switch (op) {
			case "==":
				if (isNaN(nleft) || isNaN(nright)) return left == right
				return nleft == nright
			break
			case "!=":
				if (isNaN(nleft) || isNaN(nright)) return left != right
				return nleft != nright
			break
			case ">=":
				return nleft >= nright
			break
			case "<=":
				return nleft <= nright
			break
			case ">":
				return nleft > nright
			break
			case "<":
				return nleft < nright
			break
		}
	} else {
		throw error(match, "fuck you why didnt you implement this")
	}
}
actions.if = function(line, [condition, action, argstr]) {
	if (evalCond(line.match, condition)) doAction(line, action, argstr)
}
actions.if.process = function(match, argstr) {
	console.log(splitOnce(argstr, /\s*then\s*/))
	const [condition, actstr] = splitOnce(argstr, /\s*then\s*/)

	if (actstr == null) {
		throw error(match, "'if' requires 'then'")
	}
	console.log(argstr, actstr, match.index)
	const action = parseAction(actstr, match.index)
	return [condition, action.func, action.argstr]
}
actions.if.unwrap = function([condition, action, argstr]) {
	return [unwrap(condition), action, unwrap(argstr)]
}

function parse(script) {
	const labels = {}
	const lines = []
	let lineno = 0
	for (const match of script.matchAll(/(\S+)(?:[^\S\n]*(.+))?/gm)) {
		const action = parseAction(match[0], match.index, true)
		if (typeof action == "string") {
			labels[action] = lineno
		} else {
			action.lineno = lineno
			action.match = match
			lines.push(action)
		}
		lineno += 1
	}
	return {
		lines,
		labels,
	}
}

function newgame(entrypoint, sources={}) {
	if (game) clearTimeout(game.timeout)
	game = {
		script: parse(sources[entrypoint]),
		pc: 0,
		vars: {},
		paused: false,
		timeout: 0,
		queue: [],
		stack: [],
		mode: null,
		modeValue: null,
	}
	gamelog.innerText = ""
	style()
	run(0)
}

let gameeditor = document.getElementById("editor")

function recompileGame(event) {
	newgame("main", {
		main: gameeditor.value
	})
}

gameeditor.addEventListener("change", recompileGame)
recompileGame()