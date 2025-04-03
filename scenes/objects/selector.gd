extends Area2D

const collScene = preload("res://scenes/objects/collisionObjects/collision_object.tscn")
@onready var shape = $Shape.shape
const normal_scale = 64

var ogNode: Node2D
var function: String
var functionType: String
var value: int
var area_selected = false
var pegs_to_remove = null

func _ready():
	pass

func _process(_delta):
	global_position = get_global_mouse_position()

func _input(event):
	if event.is_action_pressed("left_click"):
		var pegs = get_overlapping_bodies()
		for body in pegs:
			if not body.is_in_group("coll_objects"):
				pegs.erase(body)
		if functionType == "modify" and pegs.size() > 0:
			do_modify_function(pegs)
			area_selected = true
		elif functionType == "add" and pegs.size() == 0:
			do_add_function()
			area_selected = true

func do_modify_function(pegs):
	match function:
		"add":
			for peg in pegs:
				peg.function = "Add Money"
				peg.value = peg.value + value
				peg.set_color(Color.GREEN)
		"remove": 
			pegs_to_remove = pegs

func do_add_function():
	match function:
		"bump":
			ogNode.add_coll_object(global_position, "Bump Ball", collScene, "Circle Peg")
			ogNode.objArr.back().scale = Vector2(1.5, 1.5)


func set_function(newFunction, newValue):
	function = newFunction
	value = newValue
	if newFunction in ["add", "remove"]:
		functionType = "modify"
	elif newFunction in ["bump"]:
		functionType = "add"


func _draw():
	if shape is CircleShape2D:
		var radius := (shape as CircleShape2D).radius
		draw_circle(Vector2(0,0), radius, Color(Color.YELLOW,0.5))
	elif shape is RectangleShape2D:
		var size := (shape as RectangleShape2D).size
		draw_rect(Rect2(-size.x/2,-size.y/2,size.x,size.y),Color(Color.YELLOW,0.5),true)
