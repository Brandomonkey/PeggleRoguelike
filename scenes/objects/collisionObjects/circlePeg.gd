extends CollisionShape2D

var color: Color
var anim: AnimationPlayer

func _process(_delta):
	$Filling.modulate = color
