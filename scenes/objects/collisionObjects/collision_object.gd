extends StaticBody2D

const circlePegScene = preload("res://scenes/objects/collisionObjects/circlePeg.tscn")
const pop_up = preload("res://scenes/objects/number_pop_up.tscn")
var anim: AnimationPlayer
var function: String
var object: Node2D
var time_touched = 0
var value = 0
var pop_up_arr = []

func _process(_delta):
	for obj in pop_up_arr:
		if obj.donePlaying:
			pop_up_arr.erase(obj)
			obj.free()

func do_pop_up():
	var new_pop_up = pop_up.instantiate()
	pop_up_arr.append(new_pop_up)
	add_child(new_pop_up)
	new_pop_up.set_text("+" + str(value))
	new_pop_up.play_anim()

func _on_mouse_entered():
	$HoverBox/HoverText.text = function
	if function != "":
		$Animate.play("onHover")

func _on_mouse_exited():
	if function != "":
		$Animate.play("offHover")

func set_object(obj):
	if obj == "Circle Peg":
		object = circlePegScene.instantiate()
		object.color = Color.RED
		add_child(object)

func set_color(color):
	object.color = color
