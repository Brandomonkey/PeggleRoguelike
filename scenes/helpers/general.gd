extends Node

static func weighted_random(weights):
	var total_weight = 0
	for i in weights:
		total_weight += i
	var dist = randi() % total_weight
	for i in weights.size():
		dist -= weights[i]
		if dist < 0:
			return i
	return 0
