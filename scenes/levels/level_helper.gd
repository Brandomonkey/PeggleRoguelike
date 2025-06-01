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

static func place_silver_bullet(ogNode):
	var allObjs = ogNode.objArr
	var selection = allObjs[randi() % allObjs.size()]
	var new_function = {
		"func": Callable(selection,"silver_bullet"),
		"text": "Receive Silver Bullet",
		"params": {}
	}
	selection.functions.append(new_function)
	selection.set_color(Color.SILVER)

static func werewolf(ogNode):
	if "Silver Bullet" not in ogNode.inventory:
		ogNode.do_game_over()
	else:
		ogNode.inventory.erase("Silver Bullet")

static func ghost(ogNode):
	var color_rect := ColorRect.new()
	color_rect.color = Color.BLACK
	color_rect.name = "DarknessOverlay"
	color_rect.size = Vector2(1080, 1080)
	color_rect.position = Vector2(420, 0)
	color_rect.z_index = 100
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Create the shader
	var shader := Shader.new()
	shader.code = """
		shader_type canvas_item;
		uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
		uniform vec2 light_center;
		uniform float radius = 100.0;
		uniform float softness = 100.0;
		void fragment() {
			vec2 screen_pos = SCREEN_UV * vec2(textureSize(SCREEN_TEXTURE, 0));
			float dist = distance(screen_pos, light_center);
			float alpha = smoothstep(radius, radius + softness, dist);
			COLOR = vec4(0.0, 0.0, 0.0, alpha);
		}
	"""

	# Assign the shader to a material and set on the ColorRect
	var shader_material := ShaderMaterial.new()
	shader_material.shader = shader
	color_rect.material = shader_material
	ogNode.add_child(color_rect)

static func ghost_light(ogNode):
	var overlay = ogNode.get_node("DarknessOverlay")
	if overlay:
		var shader_material = overlay.material as ShaderMaterial
		var screen_pos = ogNode.ball.global_position
		shader_material.set_shader_parameter("light_center", screen_pos)

static func reset_ghost(ogNode):
	var overlay = ogNode.get_node("DarknessOverlay")
	overlay.free()
