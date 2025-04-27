class_name Levels

static var levelOrder = [
	10,
	25,
	50,
	250,
	500,
	1000,
	5000,
	10000,
	25000,
	50000,
	100000,
	500000,
	1000000
]

static var levels = [
	"crazyCraps",
	"hauntedHoldout",
	"boombapBaccarat",
	"buoyBucks",
	"payoutPyramids"
]

static var levelInfo = {
	"crazyCraps": {
		"characters": ["Lead1","Lead2","Lead3"]
	},
	"hauntedHoldout": {
		"characters": ["Dracula","Frankenstein","Ghost","Werewolf"]
	},
	"boombapBaccarat": {
		"characters": ["Giraffe", "Elephant", "Monkey1", "Monkey2"]
	},
	"buoyBucks": {
		"characters": ["Lead1","Lead2","Lead3"]
	},
	"payoutPyramids": {
		"characters": ["Lead1","Lead2"]
	}
}


static func check_level(money):
	if levelOrder[0] <= money:
		levelOrder.pop_front()
		return levels[randi() % levels.size()]
	else:
		return levelOrder[0]


static func load_level(menu):
	var options = []
	for i in 3:
		options.append({"text": "Next Level", "func": Callable(Levels, "progress_level")})
	menu.set_options(options)
	return options


static func progress_level(ogNode):
	ogNode.music.set_music(ogNode.currLevel)
	ogNode.music.play()
