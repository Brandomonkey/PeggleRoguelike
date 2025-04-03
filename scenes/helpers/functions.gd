extends Node

static func handle_function(ogNode, object):
	match object.function:
		"+":
			ogNode.money += object.value
		"randomize_pegs":
			for peg in ogNode.objArr:
				if randi() % 10 == 0:
					peg.function = "Add Money"
					peg.value = 1
					peg.set_color(Color.GREEN)
