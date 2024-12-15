const progress = document.getElementById("progress")
const title = document.getElementById("title")
const author = document.getElementById("author")
const play = document.getElementById("play")
const loop = document.getElementById("loop")
const looplist = document.getElementById("looplist")
const time = document.getElementById("time")
const pl = document.getElementById("pl")
const shuffle = document.getElementById("shuffle")

let song = null
let songid = null
let playlists = {
    "My Own Music": [
        {
            name: "Undertale - Predictable (Fan Song)",
            by: "bravelycowering",
            url: "https://bravelycowering.net/files/flowey jumpscare.ogg"
        },
        {
            name: "Castle Battle",
            by: "bravelycowering",
            url: "https://bravelycowering.net/files/goblin fight again mixed properly.ogg"
        },
        {
            name: "Neurospastai",
            by: "bravelycowering",
            url: "https://bravelycowering.net/files/avventura.wav"
        },
        {
            name: "Where Credit is Due",
            by: "bravelycowering",
            url: "https://bravelycowering.net/files/where_credit_is_due.ogg",
        },
        {
            name: "Optometrist",
            by: "bravelycowering",
            url: "https://bravelycowering.net/files/optometrist.ogg",
        },
        {
            name: "Ocean battle",
            by: "bravelycowering",
            url: "https://bravelycowering.net/files/goblinbattle.mp3",
        },
        {
            name: "Funkle",
            by: "bravelycowering",
            url: "https://bravelycowering.net/files/funkle.mp3",
        },
        {
            name: "And Now For Something Completely Different",
            by: "bravelycowering",
            url: "https://bravelycowering.net/files/and_now_for_something_completely_different.mp3",
        },
        {
            name: "Undertale - Another Medium (Remix)",
            by: "bravelycowering",
            url: "https://bravelycowering.net/files/another_medium.ogg",
        },
        {
            name: "Miscellaneous Battle Theme",
            by: "bravelycowering",
            url: "https://bravelycowering.net/files/misc_battle.wav",
        },
    ],
    "Undertale Stuff": [
        {
            name: "Undertale - Predictable (Fan Song)",
            by: "bravelycowering",
            url: "https://bravelycowering.net/files/flowey jumpscare.ogg"
        },
        {
            name: "Undertale - Another Medium (Remix)",
            by: "bravelycowering",
            url: "https://bravelycowering.net/files/another_medium.ogg",
        },
    ]
}
let songs = []

for (const [k, v] of Object.entries(playlists)) {
    const option = document.createElement("option")
    option.innerText = k
    option.value = k
    pl.appendChild(option)
}

pl.onchange = function() {
    loadPlaylist(playlists[pl.value])
}

progress.max = 0
progress.disabled = true
play.disabled = true

progress.oninput = function() {
    if (!song.paused) song.pause()
    time.innerText = formatTime(progress.value)+"/"+formatTime(song.duration)
}

progress.onchange = function() {
    song.currentTime = progress.value
    if (song.paused && play.innerText == "Pause") song.play()
}

play.onclick = function() {
    if (!song.paused) {
        play.innerText = "Play"
        song.pause()
    } else {
        play.innerText = "Pause"
        song.play()
    }
}

loop.onchange = function(e) {
    if (song) song.loop = loop.checked
}

const playlist = document.getElementById("playlist")

function loadPlaylist(list) {
    playlist.innerHTML = ""
    songs = list
    title.innerText = "-"
    author.innerText = "-"
    progress.max = 0
    progress.disabled = true
    play.disabled = true
    if (song) {
        song.pause()
    }
    for (let i = 0; i < list.length; i++) {
        const item = list[i]
        const s = document.createElement("p")
        s.style.cursor = "pointer"
        const index = i
        s.onclick = e => {
            e.preventDefault()
            loadSong(index)
        }
        s.innerHTML = `<div><a href="${item.url}">${item.name}</a></div><div><small>${item.by}</small></div>`
        playlist.appendChild(s)
    }
}

function songEnd() {
    if (shuffle.checked) {
        let i = songid
        while (i == songid) {
            i = Math.floor(Math.random() * songs.length)
        }
        loadSong(i)
    } else if (looplist.checked) {
        loadSong((songid + 1) % songs.length)
    }
    play.innerText = "Play"
}

function loadSong(i) {
    if (songid === i) return
    title.innerText = songs[i].name
    author.innerText = songs[i].by
    progress.max = 0
    progress.disabled = true
    play.disabled = true
    if (song) {
        song.pause()
        playlist.children[songid].style.fontWeight = null
    }
    playlist.children[i].style.fontWeight = "bold"
    song = new Audio(songs[i].url)
    songid = i
    song.onloadeddata = function() {
        progress.max = song.duration
        progress.disabled = false
        play.innerText = "Pause"
        play.disabled = false
        song.loop = loop.checked
        song.play()
    }
    song.ontimeupdate = updateTime
    song.onerror = function(e) {
        console.error(e)
        songEnd(e)
    }
    song.onended = songEnd
}

function formatTime(seconds) {
    const s = Math.floor(seconds) % 60
    const m = Math.floor(seconds/60)
    return m+":"+(s+"").padStart(2, 0)
}

function updateTime() {
    if (song && !song.paused) {
        progress.value = song.currentTime
        time.innerText = formatTime(song.currentTime)+"/"+formatTime(song.duration)
    }
}