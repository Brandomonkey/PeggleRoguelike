extends Node

static var rarities = ["common", "uncommon", "rare", "epic", "legendary"]

static func weighted_random(weights):
	var total_weight = 0
	for i in weights:
		total_weight += i
	var dist = randi() % total_weight
	for i in weights.size():
		dist -= weights[i]
		if dist < 0:
			return rarities[i]
	return 0
