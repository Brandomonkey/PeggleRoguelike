extends Node2D

const pegUpgrades = preload("res://scenes/helpers/upgrades/pegUpgrades.gd")
const setPegs = preload("res://scenes/helpers/upgrades/setPegs.gd")
const functions = preload("res://scenes/helpers/functions.gd")

static var normal_selector_scale = 64

static func handle_options(ogNode, option):
	match option:
	# Progress Level
		"Next Level":
			ogNode.music.set_music(ogNode.currLevel)
			ogNode.music.play()
	# setPegs 
		"Circles":
			setPegs.set_circles(ogNode)
		"Grid":
			setPegs.set_grid(ogNode)
		"Offset Grid":
			setPegs.set_grid_offset(ogNode)
		"Triangles":
			setPegs.set_triangles(ogNode)
		"Tapered":
			setPegs.set_tapered(ogNode)
	# pegUpgrades
		"+1 Value Circle":
			var circle = CircleShape2D.new()
			circle.radius = normal_selector_scale * 1.25
			pegUpgrades.select_pegs(ogNode, "add", 1, circle)
		"+1 Value Square":
			var rect = RectangleShape2D.new()
			rect.size = Vector2(normal_selector_scale * 2, normal_selector_scale * 2)
			pegUpgrades.select_pegs(ogNode, "add", 1, rect)
		"Remove Circle":
			var circle = CircleShape2D.new()
			circle.radius = normal_selector_scale * 0.75
			pegUpgrades.select_pegs(ogNode, "remove", 0, circle)
		"Remove Square":
			var rect = RectangleShape2D.new()
			rect.size = Vector2(normal_selector_scale, normal_selector_scale)
			pegUpgrades.select_pegs(ogNode, "remove", 0, rect)
		"Create Bumper Peg":
			var circle = CircleShape2D.new()
			circle.radius = normal_selector_scale * 0.25
			pegUpgrades.select_pegs(ogNode, "bump", 0, circle)
