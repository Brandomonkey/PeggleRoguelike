extends Node2D

var donePlaying = false

func set_text(text):
	$LabelContainer/Label.text = text

func play_anim():
	$AnimationPlayer.play("Pop Up")

func _on_animation_finished(_anim_name):
	donePlaying = true
