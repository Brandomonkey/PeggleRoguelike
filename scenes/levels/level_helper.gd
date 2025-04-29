extends Node
class_name LevelHelper

static func level_handler(ogNode, handleType):
	for character in ogNode.levelCharacters:
		if character.has(handleType):
			var newFunction = Callable(LevelHelper,character[handleType])
			newFunction.call(ogNode)

static func dracula(ogNode):
	var objsHit = ogNode.ball.all_touched
	for obj in objsHit:
		obj.functions = []
		obj.set_color(Color.RED)
		obj.sound = obj.get_node("boingSound")

static func frankenstein(ogNode):
	var ticks = Time.get_ticks_msec()
	if ticks % 3000 == 0:
		ogNode.money -= 5 
		ogNode.play_sound("res://assets/audio/nickBoing.mp3")
