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
			var textWidth = 0
			var textHeight = (lines.length - 1) * 70
			for (const line of lines) {
				var measurement = ctx.measureText(line)
				textWidth = Math.max(textWidth, measurement.width)
			}
			ctx.translate(900, 200)
			for (var i = 0; i < lines.length; i++) {
				ctx.fillText(lines[i], -textWidth / 2, -textHeight / 2 + i * 70)
			}
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
	var index = 1
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