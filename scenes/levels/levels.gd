extends Node

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
	menu.set_options(["Next Level","Next Level","Next Level"])
	return ["Next Level","Next Level","Next Level"]
