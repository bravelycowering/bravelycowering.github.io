var images = {}

function CelesteImage(src) {
	if (images[src])
		return images[src]
	let img = document.createElement("img")
	images[src] = img
	img.setAttribute("src", "files/" + src + ".png")
	return img
}

var textboxInput = document.getElementById("textbox-input")
var portraitInput = document.getElementById("portrait-input")
var sideInput = document.getElementById("side-input")
var textInput = document.getElementById("text-input")

var textboxes = {
	default: "textbox/default",
	madeline: "textbox/madeline",
	badeline: "textbox/badeline",
	granny: "textbox/granny",
	theo: "textbox/theo",
	oshiro: "textbox/oshiro",
	mom: "textbox/default",
	ex: "textbox/default",
}

var portraits = {
	default: {
		"no portrait": null
	},
	madeline: {
			normal: "madeline/normal00",
			angry: "madeline/angry00",
			serious: "madeline/deadpan00",
			sad: "madeline/sad00",
			sadder: "madeline/sadder00",
			panic: "madeline/panic00",
			determined: "madeline/determined00",
			surprised: "madeline/surprised00",
			distracted: "madeline/distracted00",
			"distracted (alt)": "madeline/distracted08",
			upset: "madeline/upset00",
			peaceful: "madeline/peaceful00",
			together: "madeline/together00",
			"together (zoom)": "madeline/togetherZoom10",
		"separator:on phone": true,
			"normal (phone)": "madelineph/normal00",
			"angry (phone)": "madelineph/angry00",
			"sad (phone)": "madelineph/sad00",
			"surprised (phone)": "madelineph/surprised00",
			"distracted (phone)": "madelineph/distracted00",
			"upset (phone)": "madelineph/upset00",
		"separator:in mirror": true,
			"normal (mirror)": "madelinemirror/normal00",
			"angry (mirror)": "madelinemirror/angry00",
			"serious (mirror)": "madelinemirror/deadpan00",
			"sad (mirror)": "madelinemirror/sad00",
			"panic (mirror)": "madelinemirror/panic00",
			"determined (mirror)": "madelinemirror/determined00",
			"surprised (mirror)": "madelinemirror/surprised00",
			"distracted (mirror)": "madelinemirror/distracted00",
			"upset (mirror)": "madelinemirror/upset00",
	},
	badeline: {
		normal: "ghost/normal00",
		angry: "ghost/angry00",
		"angry (alt)": "ghost/angryAlt00",
		concerned: "ghost/concerned00",
		sad: "ghost/sad00",
		scoff: "ghost/scoff00",
		upset: "ghost/upset00",
		worried: "ghost/worried00",
		"worried (alt)": "ghost/worriedAlt00",
		yell: "ghost/yell04",
		peaceful: "ghost/sigh12",
		aggressive: "ghost/freakA00",
		"aggressive (lean)": "ghost/freakB00",
		"aggressive (reach)": "ghost/freakC00",
		bored: "ghost/serious20",
	},
	granny: {
		normal: "granny/normal00",
		laughing: "granny/laugh00",
		mocking: "granny/mock00",
		zoom: "granny/creepA00",
		"closer zoom": "granny/creepB00",
	},
	theo: {
			normal: "theo/normal00",
			excited: "theo/excited00",
			"nailed it": "theo/nailedit00",
			serious: "theo/serious00",
			thinking: "theo/thinking00",
			worried: "theo/worried00",
			wtf: "theo/wtf00",
			yolo: "theo/yolo02",
		"separator:in mirror": true,
			"normal (mirror)": "theomirror/normal00",
			"excited (mirror)": "theomirror/excited00",
			"nailed it (mirror)": "theomirror/nailedit00",
			"serious (mirror)": "theomirror/serious00",
			"thinking (mirror)": "theomirror/thinking00",
			"worried (mirror)": "theomirror/worried00",
			"wtf (mirror)": "theomirror/wtf00",
			"yolo (mirror)": "theomirror/yolo02",
	},
	oshiro: {
			normal: "oshiro/normal00",
			angry: "oshiro/lostcontrol00",
			serious: "oshiro/serious00",
			dramatic: "oshiro/drama00",
			"dramatic (peeking)": "oshiro/drama05",
			nervous: "oshiro/nervous00",
			worried: "oshiro/worried00",
		"separator:side profile": true,
			"happy (side)": "oshiro/sidehappy00",
			"suspicious (side)": "oshiro/sidesuspicious00",
			"worried (side)": "oshiro/sideworried00",
	},
	mom: {
			normal: "mom/normal00",
			concerned: "mom/concerned00",
		"separator:on phone": true,
			"normal (phone)": "momph/normal00",
			"concerned (phone)": "momph/concerned00",
	},
	ex: {
			normal: "exph/normal00",
	},
}

var canvas = document.createElement("canvas")
canvas.width = 1800
canvas.height = 400
var ctx = canvas.getContext("2d")
var output = document.getElementById("output")

function getPortrait(character, portraitid) {
	var plist = portraits[character]
	if (!plist) return null
	var portrait = plist[portraitid]
	if (portrait != null) {
		if (portrait instanceof Image) {
			return portrait
		} else {
			portrait = CelesteImage(portrait)
			portraits[character][portraitid] = portrait
			return portrait
		}
	}
}

function getTextbox(textboxid) {
	var textbox = textboxes[textboxid]
	if (textbox instanceof Image) {
		return textbox
	} else {
		textbox = CelesteImage(textbox)
		textboxes[textboxid] = textbox
		return textbox
	}
}

var macros = {
	THEO: "{# FF9523}Theo{#}",
	THEO_UNDER_STARS: "{# FFFF4C}TheoUnderStars{#}",
	MIXMASTER_THEO: "{# FF9523}Mix Master Theo{#}",
	MOM: "{# 339CC7}Mom{#}",
	MROSHIRO: "{# 7BD838}Mr\. Oshiro{#}",
	OSHIRO: "{# 7BD838}Oshiro{#}",
	ELCREEPO: "{# 7BD838}El Creepo{#}",
	MADELINE: "{# F94A4A}Madeline{#}",
	MS_MADELINE: "{# F94A4A}Ms\. Madeline{#}",
	RESORT: "{# b864be}Celestial Resort{#}",
	THOUGHT: "{# 696a6a}{~}(",
	ENDTHOUGHT: "){/~}{#}",
	MOUNTAIN: "{# 96EFFF}Mountain{#}",
	CELESTE_MOUNTAIN: "{# 96EFFF}Celeste Mountain{#}",
	PART_OF_ME: "{# d678db}{~}Part of Me{/~}{#}",
	PART_OF_YOU: "{# d678db}{~}Part of You{/~}{#}",
	ST_BAD: "{# d678db}{~}",
	END_BAD: "{/~}{#}",
	GRANNY: "{# 66ea3a}Granny{#}",
	PART_OF_HER: "{# 66ea3a}{~}Part of Her{/~}{#}",
	PART_OF_GRANNY: "{# 66ea3a}{~}Part of Granny{/~}{#}",
	THEO_SISTER_NAME: "Alex",
	THEO_SISTER_ALT_NAME: "Maddy",
	ALEX: "{# F94A4A}Alex{#}",
}

var macroList = document.getElementById("macrolist")

for (const [k, v] of Object.entries(macros)) {
	var code = document.createElement("code")
	code.innerText = k
	macroList.appendChild(document.createElement("li")).appendChild(code)
}

/* unimplemented:
	- text with sideways letters ({%} and {/%})
	- impact text ({!} and {/!})
	- big text ({big} and {/big})
	- delays ({0.5}, currently "half implemented" where the formatter will silently ignore them (how do i show delay in a static image))
	- speed changer ({>> x} and {>>} (again. static image))
*/

function formatTextParts(ft, text) {
	for (const [match, fcmd, farg, newline, str] of text.matchAll(/{([^}\s])\s*([^}]+)?\s*}|(\n)|([^{\n]+|{)/gm)) {
		const ftag = fcmd + (farg || "")
		if (str) {
			var measurement = ctx.measureText(str)
			ft.parts.push({
				type: "string",
				text: str,
				x: ft.lineWidth,
				y: ft.newlines * 70,
			})
			ft.lineWidth += measurement.width
			ft.textWidth = Math.max(ft.textWidth, ft.lineWidth)
		} else if (fcmd == "n" || newline) {
			ft.lineWidth = 0
			ft.newlines++
		} else if (fcmd == "+") {
			if (farg) {
				var insertion = macros[farg.toUpperCase()]
				if (insertion) {
					formatTextParts(ft, insertion)
				} else {
					ft.warnings.push("Failed to parse text command "+match+": "+farg+" is an invalid value")
				}
			} else {
				ft.warnings.push("Failed to parse text command "+match+": no value was provided")
			}
		} else if (fcmd == "#") {
			if (farg) {
				ft.parts.push({
					type: "pushcolor",
					color: farg
				})
			} else {
				ft.parts.push({
					type: "popcolor",
					color: farg
				})
			}
		} else if (ftag == "~" || ftag == "/~") {
			ft.parts.push({
				type: "setwavy",
				wavy: ftag == "~"
			})
		} else if (ftag == "*" || ftag == "/*") {
			ft.parts.push({
				type: "setshaky",
				shaky: ftag == "*"
			})
		} else if (isNaN(parseFloat(ftag))) { // silently ignore pauses
			ft.warnings.push("Unknown text command "+JSON.stringify(ftag))
		}
	}
}

function formatText(text) {
	var ft = {
		parts: [],
		textWidth: 0,
		textHeight: 0,
		newlines: 0,
		lineWidth: 0,
		warnings: [],
	}
	formatTextParts(ft, text)
	ft.textHeight = ft.newlines * 70
	return ft
}

var timeout = -1

function makeTextBoxImage() {
	output.src = canvas.toDataURL("image/png")
}

function drawTextBox() {
	clearTimeout(timeout)
	timeout = setTimeout(makeTextBoxImage, 50)
	var textbox = getTextbox(textboxInput.value)
	var portrait = getPortrait(textboxInput.value, portraitInput.value)
	var lines = textInput.value.split("\n")
	textInput.setAttribute("rows", Math.max(4, lines.length + 1))
	ctx.reset()
	ctx.font = "48px renogare"
	ctx.fontSize = 48
	ctx.textBaseline = "middle"
	if (textbox.complete) {
		ctx.drawImage(textbox, 900 - textbox.width/2, 200 - textbox.height/2)
		if (portrait == null || portrait.complete) {
			if (portrait != null) {
				ctx.save()
				if (sideInput.selectedIndex) {
					ctx.scale(-1, 1)
					ctx.translate(-1800, 0)
				}
				var portraitWidth = portrait.width*220/160
				var portraitHeight = portrait.height*220/160
				ctx.drawImage(portrait, 200 - portraitWidth / 2, 200 - portraitHeight / 2, portraitWidth, portraitHeight)
				ctx.restore()
				if (sideInput.selectedIndex) {
					ctx.translate(-138, 0)
				} else {
					ctx.translate(138, 0)
				}
			}
			ctx.fillStyle = "#ffffffdd"
			var formattedText = formatText(textInput.value)
			var colors = []
			var wavy = false
			var shaky = false
			ctx.translate(900-formattedText.textWidth/2, 200-formattedText.textHeight/2)
			for (var i = 0; i < formattedText.parts.length; i++) {
				var part = formattedText.parts[i]
				if (part.type == "string") {
					var x = part.x
					var text = part.text
					var shakyrand = Math.round(Math.random())
					for (j = 0; j < text.length; j++) {
						var charWidth = ctx.measureText(text[j]).width
						var yoff = 0
						var xoff = 0
						if (wavy) {
							yoff += Math.sin(x/66)*5
						}
						if (shaky) {
							xoff += Math.random()*3
							yoff += Math.random()*5 - Math.abs(shakyrand-j%2)*5
						}
						ctx.fillText(text[j], x + xoff, part.y + yoff)
						x += charWidth
					}
				} else if (part.type == "pushcolor") {
					colors.push(ctx.fillStyle)
					ctx.fillStyle = "#"+part.color.trim()
				} else if (part.type == "popcolor") {
					if (colors.length > 0) {
						ctx.fillStyle = colors.pop()
					}
				} else if (part.type == "setwavy") {
					wavy = part.wavy
				} else if (part.type == "setshaky") {
					shaky = part.shaky
				}
			}
			// var textWidth = 0
			// var textHeight = (lines.length - 1) * 70
			// for (const line of lines) {
			// 	var measurement = ctx.measureText(line)
			// 	textWidth = Math.max(textWidth, measurement.width)
			// }
			// var x = -textWidth / 2
			// var y = -textHeight / 2
			// ctx.translate(900, 200)
			// for (var i = 0; i < lines.length; i++) {
			// 	ctx.fillText(lines[i], x, y + i * 70)
			// }
			return
		} else {
			portrait.onload = drawTextBox
		}
	} else {
		textbox.onload = drawTextBox
	}
	ctx.textAlign = "center"
	ctx.fillStyle = "white"
	ctx.lineWidth = 8
	ctx.strokeText("Loading image...", 900, 200)
	ctx.fillText("Loading image...", 900, 200)
}

for (const [k, v] of Object.entries(textboxes)) {
	var option = document.createElement("option")
	option.innerText = k
	textboxInput.appendChild(option)
}

textboxInput.onchange = function() {
	var oldPortraitValue = portraitInput.value
	portraitInput.innerHTML = ''
	var index = 0
	for (const [k, v] of Object.entries(portraits[textboxInput.value])) {
		var option = document.createElement("option")
		if (k.startsWith("separator:")) {
			option.innerHTML = "&#9472;".repeat(15)
			option.disabled = true
		} else {
			option.innerText = k
		}
		portraitInput.appendChild(option)
		if (k == oldPortraitValue) {
			portraitInput.selectedIndex = index
		}
		index ++
	}
	portraitInput.onchange = drawTextBox
	drawTextBox()
}
portraitInput.onchange = drawTextBox
sideInput.onchange = drawTextBox
textInput.oninput = drawTextBox
textInput.onchange = drawTextBox

textboxInput.selectedIndex = 1
textboxInput.onchange()
makeTextBoxImage()