extends CollisionPolygon2D

var color: Color

func _process(_delta):
	$Filling.modulate = color
