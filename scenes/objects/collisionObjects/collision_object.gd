extends StaticBody2D
class_name CollisionObject

const circlePegScene = preload("res://scenes/objects/collisionObjects/circlePeg.tscn")
const flipperScene = preload("res://scenes/objects/collisionObjects/flipper.tscn")
const pop_up = preload("res://scenes/objects/number_pop_up.tscn")
var mainScene: Node2D
var anim: AnimationPlayer
var sound: AudioStreamPlayer
var functions := []
var triggeredFunctions := []
var object: Node2D
var time_touched = 0
var pop_up_arr = []

func _ready():
	sound = $boingSound

func _process(_delta):
	for obj in pop_up_arr:
		if obj.donePlaying:
			pop_up_arr.erase(obj)
			obj.free()

func do_pop_up():
	if functions.size() > 0:
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
	elif obj == "Flipper":
		object = flipperScene.instantiate()
		object.color = Color.RED
		add_child(object)

func set_color(color):
	object.color = color


# FUNCTIONS

func add_money(params: Dictionary):
	mainScene.ball.money_gathered += params.value

func bump_ball(_params: Dictionary = {}):
	mainScene.ball.linear_velocity = mainScene.ball.linear_velocity.normalized() * 500
	var tween = self.create_tween()
	tween.tween_property(self, "scale", Vector2(2, 2), 0.1)
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.2)

# TRIGGERED FUNCTIONS

func flip(params: Dictionary):
	var tween = create_tween()
	var rotationVal = 1
	if params.direction == "left":
		rotationVal = -1
	tween.tween_property(self, "rotation", rotationVal, 0.1)
	tween.tween_property(self, "rotation", 0, 0.5)
