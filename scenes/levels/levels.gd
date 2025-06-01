class_name Levels

static var level_data_file = "res://assets/data/levels.json"
static var level_data_json = FileAccess.get_file_as_string(level_data_file)
static var level_data = JSON.parse_string(level_data_json)

static var level_order_file = "user://level_order.json"
static var level_order_json = FileAccess.get_file_as_string(level_order_file)
static var level_order = JSON.parse_string(level_order_json)

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

static func get_level():
	if level_order.size() > 0:
		var current_level = JSON.parse_string(level_order[0])
		for level in level_data.keys():
			var characters = level_data[level].get("characters", [])
			for character in characters:
				if character == current_level:
					return level
	return level_data.keys()[randi() % level_data.size()]

static func get_character(level):
	if level_order.size() > 0:
		var next_level = JSON.parse_string(level_order[0])
		level_order.pop_front()
		return next_level
	else:
		var characters = level_data[level].characters
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
