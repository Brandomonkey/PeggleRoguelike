extends Area2D

var entered = false
var label: String
var function: String
var value: int

func _ready():
	$Label.text = label

func _on_body_entered(body):
	if body.is_in_group("ball"):
		entered = true
