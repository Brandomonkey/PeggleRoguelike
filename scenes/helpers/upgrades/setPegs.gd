extends Node

const collScene = preload("res://scenes/objects/collisionObjects/collision_object.tscn")
const gridOptions = [
	"Circles",
	"Grid",
	"Offset Grid",
	"Tapered",
	"Triangles"
]

static func set_options(menu):
	var currentOptions = []
	var temp_arr = gridOptions.duplicate()
	for i in range(3):
		var optionSet = temp_arr.pop_at(randi_range(0,temp_arr.size()-1))
		currentOptions.append(optionSet)
	menu.set_options(currentOptions)
	return currentOptions

static func get_viewport_size(ogNode):
	return ogNode.gameplay_viewport

static func set_circles(ogNode):
	for i in range(1,21):
		for j in range(1,6):
			var x = cos(2 * PI / 20 * i) * (640 / 11 * j) + 960
			var y = sin(2 * PI / 20 * i) * (640 / 9 * j) + 512
			ogNode.add_coll_object(Vector2(x,y), "", collScene, "Circle Peg")

static func set_grid(ogNode):
	var viewport = get_viewport_size(ogNode)
	var i = -4.5
	while i < 5:
		var x = viewport.x / 11 * i + (viewport.x/2 + viewport.left)
		var j = -4.5
		while j < 5:
			var y = viewport.y / 11 * j + (viewport.y/2 + viewport.top)
			ogNode.add_coll_object(Vector2(x,y), "", collScene, "Circle Peg")
			j += 1
		i += 1

static func set_grid_offset(ogNode):
	var viewport = get_viewport_size(ogNode)
	var i = -4.5
	while i < 5:
		var j = -4.5
		while j < 5:
			var x = viewport.x / 11 * i + (viewport.x/2 + viewport.left)
			var y = viewport.y / 11 * j + (viewport.y/2 + viewport.top)
			if int(j - 0.5) % 2 == 0:
				x += (viewport.x/11/4)
			else:
				x -= (viewport.x/11/4)
			ogNode.add_coll_object(Vector2(x,y), "", collScene, "Circle Peg")
			j += 1
		i += 1

static func set_triangles(ogNode):
	var left = 960
	var width = 0
	for i in range(1,15):
		for j in range(1,i+1):
			var x = left + (width / (i + 1)) * j
			var y = 1000 - (640 / 11 * i)
			ogNode.add_coll_object(Vector2(x,y), "", collScene, "Circle Peg")
		left -= 640 / 12 / 2
		width += 640 / 12

static func set_tapered(ogNode):
	for i in range(1,15):
		for j in range(1,i+1):
			var x = 640 / (i + 1) * j + 640
			var y = 1000 - 640 / 11 * i
			ogNode.add_coll_object(Vector2(x,y), "", collScene, "Circle Peg")
