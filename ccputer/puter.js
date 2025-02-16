const canvas = document.getElementById("screen")
const ctx = canvas.getContext("2d")
const input = document.getElementById("input")
const font = document.getElementById("font")

// ctx.fillStyle = "#0000ff"
// ctx.fillRect(0, 0, 56, 48)
// ctx.fillStyle = "#ffffff"
// ctx.fillText(":( oh no", 10, 20)

input.oninput = function() {
	key(input.value)
	input.value = ""
}
input.focus()

addEventListener("click", function(e) {
	e.preventDefault()
	e.stopPropagation()
	e.stopImmediatePropagation()
	input.focus()
	if (e.clientX >= 8 && e.clientX < canvas.width + 8) {
		if (e.clientY >= 8 && e.clientY < canvas.height + 8) {
			click(e.clientX - 8, e.clientY - 8)
		}
	}
	if (e.clientY >= 112 && e.clientY < 120 && e.clientX >= 8 && e.clientX < 16) {
		document.getElementById("restart").remove()
		canvas.remove()
		setTimeout(() => {
			location.reload()
		}, 500)
	}
	if (e.clientY == 100) {
		customEvent(e.clientX)
	}
})

addEventListener("keydown", function(e) {
	if (e.key == "Enter") {
		customEvent(0)
	}
	if (e.key == "Backspace") {
		customEvent(1)
	}
})

const chars = {
	// ROW 0
	"A": [0., 0],
	"B": [1., 0],
	"C": [2., 0],
	"D": [3., 0],
	"E": [4., 0],
	"F": [5., 0],
	"G": [6., 0],
	"H": [7., 0],
	"I": [8., 0],
	"J": [9., 0],
	"K": [10, 0],
	"L": [11, 0],
	"M": [12, 0],
	"N": [13, 0],
	"O": [14, 0],
	"P": [15, 0],
	// ROW 1
	"Q": [0., 1],
	"R": [1., 1],
	"S": [2., 1],
	"T": [3., 1],
	"U": [4., 1],
	"V": [5., 1],
	"W": [6., 1],
	"X": [7., 1],
	"Y": [8., 1],
	"Z": [9., 1],
	"<": [10, 1],
	">": [11, 1],
	"[": [12, 1],
	"]": [13, 1],
	"{": [14, 1],
	"}": [15, 1],
	// ROW 2
	"a": [0., 2],
	"b": [1., 2],
	"c": [2., 2],
	"d": [3., 2],
	"e": [4., 2],
	"f": [5., 2],
	"g": [6., 2],
	"h": [7., 2],
	"i": [8., 2],
	"j": [9., 2],
	"k": [10, 2],
	"l": [11, 2],
	"m": [12, 2],
	"n": [13, 2],
	"o": [14, 2],
	"p": [15, 2],
	// ROW 3
	"q": [0., 3],
	"r": [1., 3],
	"s": [2., 3],
	"t": [3., 3],
	"u": [4., 3],
	"v": [5., 3],
	"w": [6., 3],
	"x": [7., 3],
	"y": [8., 3],
	"z": [9., 3],
	"/": [10, 3],
	"|": [11, 3],
	"\\":[12, 3],
	"?": [13, 3],
	",": [14, 3],
	".": [15, 3],
	// ROW 4
	"1": [0., 4],
	"2": [1., 4],
	"3": [2., 4],
	"4": [3., 4],
	"5": [4., 4],
	"6": [5., 4],
	"7": [6., 4],
	"8": [7., 4],
	"9": [8., 4],
	"0": [9., 4],
	":": [10, 4],
	";": [11, 4],
	'"': [12, 4],
	"'": [13, 4],
	"~": [14, 4],
	"`": [15, 4],
	// ROW 5
	"!": [0., 5],
	"@": [1., 5],
	"#": [2., 5],
	"$": [3., 5],
	"%": [4., 5],
	"^": [5., 5],
	"&": [6., 5],
	"*": [7., 5],
	"(": [8., 5],
	")": [9., 5],
	"_": [10, 5],
	"-": [11, 5],
	'+': [12, 5],
	"=": [13, 5],
	"":  [14, 5],
	" ": [15, 5],
}

const state = {
	background: "#000000",
	foreground: "#ffffff",
	input: "",
	events: {},
	comline: "",
	blink: 0,
	line: 0,
}

ctx.fillStyle = state.background
ctx.fillRect(0, 0, canvas.width, canvas.height)

function drawChar(char, x, y) {
	let c = chars[char]
	if (c == undefined) {
		c = chars[""]
	}
	ctx.fillStyle = state.background
	ctx.fillRect(x*4, y*8, 4, 8)
	ctx.fillStyle = state.foreground
	ctx.drawImage(font, c[0]*4, c[1]*8, 4, 8, x*4, y*8, 4, 8)
}

function drawString(str, x, y) {
	for (let i = 0; i < str.length; i++) {
		drawChar(str[i], x, y)
		x++
	}
	return [x, y]
}

function update() {
	let input = state.input
	let events = state.events
	state.input = ""
	state.events = {}
	if (input.length > 0) {
		state.comline = (state.comline + input).substring(0, 28)
	}
	state.blink += 1
	if (state.blink > 10) {
		state.blink = 0
	}
	if (events[1]) {
		state.blink = 6
		state.comline = state.comline.substring(0, state.comline.length - 1)
	}
	drawString(state.comline+" ", 0, state.line)
	if (events[0]) {
		state.blink = 6
		state.line++
		state.comline = ""
		while (state.line > 11) {
			state.line--
			ctx.drawImage(canvas, 0, -8)
			ctx.fillStyle = state.background
			ctx.fillRect(0, canvas.height - 8, canvas.width, 8)
		}
	}
}

function draw() {
	const [x, y] = drawString(state.comline, 0, state.line)
	if (state.blink > 5) {
		drawChar("_", x, y)
	} else {
		drawChar(" ", x, y)
	}
	drawChar(" ", x + 1, y)
}

function loop() {
	update()
	draw()
}

function key(k) {
	state.input += k
}

function click(x, y) {
	
}

function customEvent(number) {
	state.events[number] = true
}

setInterval(loop, 100)