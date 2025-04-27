extends Node
class_name Functions

static func handle_function(ogNode, object):
	match object.function:
		"+":
			ogNode.money += object.value
		"randomize_pegs":
			for peg in ogNode.objArr:
				var callableFunc = Callable(peg, "add_money")
				if randi() % 10 == 0:
					peg.functions.append({"func": callableFunc,"text":"Add Money"})
					peg.value = 1
					peg.set_color(Color.GREEN)
