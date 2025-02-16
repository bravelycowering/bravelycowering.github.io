const canvas = document.getElementById("screen")
const ctx = canvas.getContext("2d")
const input = document.getElementById("input")

ctx.fillStyle = "#0000ff"
ctx.fillRect(0, 0, 56, 48)
ctx.fillStyle = "#ffffff"
ctx.fillText(":( oh no", 10, 20)
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
	if (e.clientX >= 4 && e.clientX < canvas.width + 4) {
		if (e.clientY >= 4 && e.clientY < canvas.height + 4) {
			click(e.clientX - 4, e.clientY - 4)
		}
	}
	if (e.clientY >= 56 && e.clientY < 60 && e.clientX >= 4 && e.clientX < 8) {
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

function key(k) {

}

function click(x, y) {
	ctx.fillStyle = "#ff0000"
	ctx.fillRect(x, y, 1, 1)
}

function customEvent(number) {
	alert(number)
	switch (number) {
		case 0:

		break;
	}
}