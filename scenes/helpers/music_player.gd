extends AudioStreamPlayer

var levels = preload("res://scenes/levels/levels.gd").levels
var levelInfo = preload("res://scenes/levels/levels.gd").levelInfo
var currentLevel: String
var currState: int
var isTrue: bool

func _ready():
	randomize()
	currentLevel = levels[randi() % levels.size()]
	currState = 0
	play_music()

func _on_finished():
	play_music()

func set_music(level):
	currentLevel = level
	currState = 0
	play_music()
	$musicLayer.stream = null

func stop_all():
	stop()
	$musicLayer.stop()
	$musicLayer2.stop()

func play_music():
	if currState == 0:
		if ResourceLoader.exists("res://assets/music/"+ currentLevel + "/" + currentLevel + "Intro.mp3"):
			stream = load("res://assets/music/"+ currentLevel + "/" + currentLevel + "Intro.mp3")
		else:
			stream = load("res://assets/music/"+ currentLevel + "/" + currentLevel + "Main.mp3")
		currState = 1
		isTrue = true
	else:
		stream = load("res://assets/music/"+ currentLevel + "/" + currentLevel + "Main.mp3")
		var lead = randi() % levelInfo[currentLevel]["characters"].size()
		if ResourceLoader.exists("res://assets/music/"+ currentLevel + "/" + currentLevel + "Sub.mp3") and randi() % 2 == 0:
			$musicLayer2.stream = load("res://assets/music/"+ currentLevel + "/" + currentLevel + "Sub.mp3")
			$musicLayer2.play()
		if isTrue and ResourceLoader.exists("res://assets/music/"+ currentLevel + "/" + currentLevel + "Crash.mp3"):
			$musicLayer.stream = load("res://assets/music/"+ currentLevel + "/" + currentLevel + "Crash.mp3")
			isTrue = false
		elif ResourceLoader.exists("res://assets/music/"+ currentLevel + "/" + currentLevel + "Lead0.mp3") and randi() % 2 == 0:
			$musicLayer.stream = load("res://assets/music/"+ currentLevel + "/" + currentLevel + "Lead" + str(lead) + ".mp3")
	$musicLayer.play()
	play()

