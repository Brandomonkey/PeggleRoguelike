class_name Upgrades

const general = preload("res://scenes/helpers/general.gd")
const functions = preload("res://scenes/helpers/functions.gd")
const selectorScene = preload("res://scenes/objects/selector.tscn")

static var normal_selector_scale = 64

# Upgrade Option Handlers
const upgradeOptions = [
	[ #"common":
		{"text": "+1 Value Circle", "func": Callable(Upgrades, "add_value"), "params": {"value": 1, "shape": "circle", "scale": 1.25}},
		{"text": "+1 Value Square", "func": Callable(Upgrades, "add_value"), "params": {"value": 1, "shape": "square", "scale": 1.5}},
		{"text": "Remove Circle", "func": Callable(Upgrades, "remove"), "params": {"shape": "circle", "scale": 0.75}},
		{"text": "Remove Square", "func": Callable(Upgrades, "remove"), "params": {"shape": "square", "scale": 1}}
	],
	[ #"uncommon": 
		{"text": "Create Bumper Peg", "func": Callable(Upgrades, "add_bumper"), "params": {"shape": "circle", "scale": 0.25}}
	],
	[ #"rare": 
		{"text": "+1 Value Circle", "func": Callable(Upgrades, "add_value"), "params": {"value": 1, "shape": "circle", "scale": 1.25}},
		{"text": "+1 Value Square", "func": Callable(Upgrades, "add_value"), "params": {"value": 1, "shape": "square", "scale": 1.5}},
		{"text": "Remove Circle", "func": Callable(Upgrades, "remove"), "params": {"shape": "circle", "scale": 0.75}},
		{"text": "Remove Square", "func": Callable(Upgrades, "remove"), "params": {"shape": "square", "scale": 1}}
	],
	[ #"epic": 
		{"text": "+1 Value Circle", "func": Callable(Upgrades, "add_value"), "params": {"value": 1, "shape": "circle", "scale": 1.25}},
		{"text": "+1 Value Square", "func": Callable(Upgrades, "add_value"), "params": {"value": 1, "shape": "square", "scale": 1.5}},
		{"text": "Remove Circle", "func": Callable(Upgrades, "remove"), "params": {"shape": "circle", "scale": 0.75}},
		{"text": "Remove Square", "func": Callable(Upgrades, "remove"), "params": {"shape": "square", "scale": 1}}
	],
	[ #"legendary": 
		{"text": "+1 Value Circle", "func": Callable(Upgrades, "add_value"), "params": {"value": 1, "shape": "circle", "scale": 1.25}},
		{"text": "+1 Value Square", "func": Callable(Upgrades, "add_value"), "params": {"value": 1, "shape": "square", "scale": 1.5}},
		{"text": "Remove Circle", "func": Callable(Upgrades, "remove"), "params": {"shape": "circle", "scale": 0.75}},
		{"text": "Remove Square", "func": Callable(Upgrades, "remove"), "params": {"shape": "square", "scale": 1}}
	]
]

static func set_options(menu, weights):
	var currentOptions = []
	while currentOptions.size() < 3:
		var rarity = general.weighted_random(weights)
		var optionSet = upgradeOptions[rarity].pick_random()
		if optionSet not in currentOptions:
			currentOptions.append(optionSet)
	menu.set_options(currentOptions)
	return currentOptions


# Helper Functions
static func make_shape(shape_type: String, scale: float = 1.0) -> Shape2D:
	match shape_type:
		"circle":
			var c = CircleShape2D.new()
			c.radius = normal_selector_scale * scale
			return c
		"square":
			var r = RectangleShape2D.new()
			r.size = Vector2.ONE * (normal_selector_scale * scale * 2)
			return r
	return null

static func select(ogNode: Node2D, function: String, params: Dictionary, shape: Shape2D):
	var selector = selectorScene.instantiate()
	selector.ogNode = ogNode
	selector.function = Callable(selector, function)
	selector.params = params
	selector.get_child(0).shape = shape
	ogNode.add_child(selector)
	ogNode.selector = selector
	ogNode.selecting = true


# Upgrade Functions
static func add_value(ogNode: Node2D, params: Dictionary = {}):
	var shape = make_shape(params.shape, params.scale)
	if shape:
		select(ogNode, "add_money", {"value": params.value}, shape)

static func remove(ogNode: Node2D, params: Dictionary = {}):
	var shape = make_shape(params.shape, params.scale)
	if shape:
		select(ogNode, "remove_pegs", {}, shape)

static func add_bumper(ogNode: Node2D, params: Dictionary = {}):
	var shape = make_shape(params.shape, params.scale)
	if shape:
		select(ogNode, "add_bumper", {}, shape)
