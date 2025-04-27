extends Area2D
class_name Selector

const collScene = preload("res://scenes/objects/collisionObjects/collision_object.tscn")
@onready var shape = $Shape.shape
const normal_scale = 64

var ogNode: Node2D
var function: Callable
var params: Dictionary
var value: int
var area_selected = false
var pegs_to_remove = null

func _ready():
	pass

func _process(_delta):
	global_position = get_global_mouse_position()

func _draw():
	if shape is CircleShape2D:
		var radius := (shape as CircleShape2D).radius
		draw_circle(Vector2(0,0), radius, Color(Color.YELLOW,0.5))
	elif shape is RectangleShape2D:
		var size := (shape as RectangleShape2D).size
		draw_rect(Rect2(-size.x/2,-size.y/2,size.x,size.y),Color(Color.YELLOW,0.5),true)

func _input(event):
	if event.is_action_pressed("left_click"):
		var pegs = get_overlapping_bodies()
		for body in pegs:
			if not body.is_in_group("coll_objects"):
				pegs.erase(body)
		area_selected = function.call(pegs)


func add_money(pegs: Array) -> bool:
	if pegs.size() > 0:
		for peg in pegs:
			peg.functions.append({"func": Callable(peg,"add_money"),"text": "Add Money"})
			peg.value = peg.value + params.value
			peg.set_color(Color.GREEN)
		return true
	else:
		return false

func remove_pegs(pegs: Array) -> bool:
	if pegs.size() > 0:
		pegs_to_remove = pegs
		return true
	else:
		return false

func add_bumper(pegs: Array) -> bool:
	if pegs.size() == 0:
		ogNode.add_coll_object(global_position, collScene, "Circle Peg", {"func": "bump_ball", "text": "Bump Ball"})
		ogNode.objArr.back().scale = Vector2(1.5, 1.5)
		return true
	else:
		return false
