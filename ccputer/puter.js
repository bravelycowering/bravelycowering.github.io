const canvas = document.getElementById("screen")
const ctx = canvas.getContext("2d")
const input = document.getElementById("input")

ctx.fillStyle = "#0000ff"
ctx.fillRect(0, 0, 56, 48)
ctx.fillStyle = "#ffffff"
ctx.fillText(":( oh no", 10, 20)
let i = 0
input.oninput = function() {
	ctx.fillStyle = "#0000ff"
	ctx.fillRect(0, 0, 56, 48)
	ctx.fillStyle = "#ffffff"
	ctx.fillText(input.value, 10, 20)
	ctx.fillText(i++, 10, 35)
}
input.focus()