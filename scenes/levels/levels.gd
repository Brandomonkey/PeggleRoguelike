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
	#"crazyCraps",
	"hauntedHoldout",
	#"boombapBaccarat",
	#"buoyBucks",
	#"payoutPyramids"
]

static var levelInfo = {
	#"crazyCraps": {
		#"characters": [
			#{"name": "Lead1", "func": "not_implemented"},
			#{"name": "Lead2", "func": "not_implemented"},
			#{"name": "Lead3", "func": "not_implemented"},
		#]
	#},
	"hauntedHoldout": {
		"characters": [
			{"name": "Dracula", "after_landing": "dracula"},
			{"name": "Frankenstein", "during_drop": "frankenstein"},
			#{"name": "Ghost", "func": "not_implemented"},
			#{"name": "Werewolf", "func": "not_implemented"}
		]
	},
	#"boombapBaccarat": {
		#"characters": [
			#{"name": "Giraffe", "func": "not_implemented"},
			#{"name": "Elephant", "func": "not_implemented"},
			#{"name": "Monkey1", "func": "not_implemented"},
			#{"name": "Monkey2", "func": "not_implemented"},
		#]
	#},
	#"buoyBucks": {
		#"characters": [
			#{"name": "Lead1", "func": "not_implemented"},
			#{"name": "Lead2", "func": "not_implemented"},
			#{"name": "Lead3", "func": "not_implemented"},
		#]
	#},
	#"payoutPyramids": {
		#"characters": [
			#{"name": "Lead1", "func": "not_implemented"},
			#{"name": "Lead2", "func": "not_implemented"},
		#]
	#}
}

static func get_level():
	return levels[randi() % levels.size()]

static func get_character(level):
	var characters = levelInfo[level].characters
	return characters[randi() % characters.size()]

static func check_level(money):
	if levelOrder[0] <= money:
		levelOrder.pop_front()
		return 0
	else:
		return levelOrder[0]

static func load_level(menu):
	var options = []
	for i in 3:
		options.append({"text": "Next Level", "func": Callable(Levels, "progress_level")})
	menu.set_options(options)
	return options

static func progress_level(ogNode):
	ogNode.music.set_music(ogNode.levelStatus)
	ogNode.music.play()
	LevelHelper.level_handler(ogNode, "before_dropping")
