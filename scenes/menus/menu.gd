extends Node2D

var selected = -1
var function: String

func _on_input_event_1(_viewport, event, _shape_idx):
	if event.is_action_pressed("left_click"):
		selected = 0

func _on_input_event_2(_viewport, event, _shape_idx):
	if event.is_action_pressed("left_click"):
		selected = 1

func _on_input_event_3(_viewport, event, _shape_idx):
	if event.is_action_pressed("left_click"):
		selected = 2

func set_options(options):
	$Sprite1/Label.text = options[0]
	$Sprite2/Label.text = options[1]
	$Sprite3/Label.text = options[2]
