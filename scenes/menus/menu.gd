extends Node2D

var selected = -1
var function: Callable
var params: Dictionary

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
	$Sprite1/Label.text = options[0]["text"]
	$Sprite2/Label.text = options[1]["text"]
	$Sprite3/Label.text = options[2]["text"]


# Post Selection Functions
func randomize_pegs():
	for peg in params.objArr:
		var new_function = {
			"func": Callable(peg,"add_money"),
			"text": "Add Money",
			"params": {"value": 1}
		}
		if randi() % 10 == 0:
			peg.functions.append(new_function)
			peg.set_color(Color.GREEN)
			peg.sound = peg.get_node("moneySound") # Update peg sound
