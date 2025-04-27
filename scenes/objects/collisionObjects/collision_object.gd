extends StaticBody2D
class_name CollisionObject

const circlePegScene = preload("res://scenes/objects/collisionObjects/circlePeg.tscn")
const pop_up = preload("res://scenes/objects/number_pop_up.tscn")
var mainScene: Node2D
var anim: AnimationPlayer
var functions := []
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
	new_pop_up.set_text(functions[0].text)
	new_pop_up.play_anim()

func _on_mouse_entered():
	if !functions.is_empty():
		$HoverBox/HoverText.text = functions[0].text
		$Animate.play("onHover")

func _on_mouse_exited():
	if !functions.is_empty():
		$Animate.play("offHover")

func set_object(obj):
	if obj == "Circle Peg":
		object = circlePegScene.instantiate()
		object.color = Color.RED
		add_child(object)

func set_color(color):
	object.color = color


# FUNCTIONS

func add_money():
	mainScene.ball.money_gathered += value

func bump_ball():
	mainScene.ball.linear_velocity = mainScene.ball.linear_velocity.normalized() * 500
	var tween = self.create_tween()
	tween.tween_property(self, "scale", Vector2(2, 2), 0.1)
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.2)
