extends Node2D
class_name Main

const upgrades = preload("res://scenes/helpers/upgrades/upgrades.gd")
const levelHelper = preload("res://scenes/levels/level_helper.gd")

const menuScene = preload("res://scenes/menus/menu.tscn")
const ballScene = preload("res://scenes/objects/fallingBall.tscn")
const baskScene = preload("res://scenes/objects/basket.tscn")
const musicScene = preload("res://scenes/helpers/music_player.tscn")

var menu: Node2D
var menuOpen = true
var selector: Area2D
var selecting = false

var ball: RigidBody2D
var objArr: Array
var leftButtonTriggers: Array
var rightButtonTriggers: Array
var basketArr: Array
var music: AudioStreamPlayer
var gameplay_viewport: Dictionary
var modulator: CanvasModulate

var inventory: Array

var money = 1
var moneyEarned = 0
var dropCost = 1
var upgradeWeights = [5,4,3,2,1]

var moneyToLevel = 0
var levelStatus = false
var levelCharacters = []
var currentOptions: Array
var gameOver = false


# Called when the node enters the scene tree for the first time.
func _ready():
	gameplay_viewport = { # Set gameplay viewport variable
		"top": $LeftBorder/Shape.shape.size.y / 8,
		"left": ($LeftBorder/Shape.position.x + ($LeftBorder/Shape.shape.size.x) / 2),
		"x": ($RightBorder/Shape.position.x - ($RightBorder/Shape.shape.size.x) / 2) - ($LeftBorder/Shape.position.x + ($LeftBorder/Shape.shape.size.x) / 2),
		"y": $LeftBorder/Shape.shape.size.y * 3 / 4
	}
	var newBasket = baskScene.instantiate()
	basketArr.append(newBasket)
	newBasket.label = "Gain $10"
	newBasket.function = Callable(newBasket, "add_money")
	newBasket.params = {"ogNode": self, "value": 10}
	add_child(newBasket)
	newBasket.position = Vector2(gameplay_viewport.left,1080)

	music = musicScene.instantiate() # Instantiate music
	add_child(music)
	
	menu = menuScene.instantiate() # Instantiate menu
	add_child(menu)
	currentOptions = SetPegs.set_options(menu)
	menu.function = Callable(menu, "randomize_pegs")
	menu.params = {"objArr": objArr}
	
	moneyToLevel = Levels.check_level(money)
	$Level.text = "Next level at $" + str(moneyToLevel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Money.text = "Bank Account: $" + str(money)
	$MoneyEarned.text = "Money Earned: $" + str(moneyEarned)
	$DropCost.text = "Cost to Drop: $" + str(dropCost)
	var inventoryText = ""
	for item in inventory:
		inventoryText += "* " + item + "\n"
	$Inventory.text = inventoryText
	if selecting:
		if selector.area_selected:
			if selector.pegs_to_remove != null:
				for peg in selector.pegs_to_remove:
					objArr.erase(peg)
					peg.free()
			selecting = false
			selector.free()
			ball = ballScene.instantiate()
			add_child(ball)
	elif menuOpen:
		if menu.selected != -1:
			ball = ballScene.instantiate()
			add_child(ball)
			if currentOptions[menu.selected]["func"].is_valid():
				if "params" in currentOptions[menu.selected]:
					currentOptions[menu.selected]["func"].call(self, currentOptions[menu.selected]["params"])
				else:
					currentOptions[menu.selected]["func"].call(self)
			if menu.function.is_valid():
				menu.function.call()
			menu.free()
			menuOpen = false
	elif !gameOver:
		if ball.is_dropped:
			if ball.time_dropped != null: # Do something when ball is dropped
				ball.time_dropped = null
				if dropCost <= money:
					money -= dropCost
					dropCost *= 2
			if ball.impulse_factor > 5:
				objArr.erase(ball.last_touched)
				ball.last_touched.free()
				ball.impulse_factor = 1
			moneyEarned = ball.money_gathered
			levelHelper.level_handler(self, "during_drop")
			pass
		else:
			var ball_posx = get_global_mouse_position().x
			if get_global_mouse_position().x + ball.get_radius() < gameplay_viewport.left:
				ball_posx = gameplay_viewport.left + ball.get_radius()
			elif get_global_mouse_position().x > gameplay_viewport.left + gameplay_viewport.x - ball.get_radius():
				ball_posx = gameplay_viewport.left + gameplay_viewport.x - ball.get_radius()
			ball.position = Vector2(ball_posx, 100)


func _on_resetter_body_entered(body):
	if body.is_in_group("ball"):
		money += moneyEarned
		moneyEarned = 0
		for basket in basketArr:
			if basket.entered:
				basket.function.call()
				basket.entered = false
		moneyToLevel = Levels.check_level(money)
		if dropCost > money:
			do_game_over()
		else:
			play_sound("res://assets/audio/Hooray Sound Effect.mp3")
			menu = menuScene.instantiate()
			if levelStatus:
				levelHelper.level_handler(self, "after_landing")
				levelStatus = false
				levelCharacters = []
				$Level.text = "Next level at $" + str(moneyToLevel)
				currentOptions = upgrades.set_options(menu, upgradeWeights)
			else:
				levelStatus = Levels.get_level()
				levelCharacters.append(Levels.get_character(levelStatus))
				
				var spritePath = "res://assets/sprites/" + levelStatus + "/" + levelCharacters[0].get("name") + ".png"
				if FileAccess.file_exists(spritePath):
					var desiredSize = Vector2(384,400)
					$LevelSprite.texture = load(spritePath)
					$LevelSprite.scale = desiredSize / $LevelSprite.texture.get_size()
					$Level.text = generate_level_text(levelStatus, levelCharacters)
				else:
					print(spritePath + " does not exist.")
				
				music.stop_all()
				currentOptions = Levels.load_level(menu)
				levelHelper.level_handler(self, "level_start")
			if not gameOver:
				call_deferred("add_child", menu)
				menuOpen = true
		body.free()

func add_coll_object(objPosition, scene, shape, function: Dictionary = {}):
	var newObj = scene.instantiate()
	objArr.append(newObj)
	add_child(newObj)
	newObj.global_position = objPosition
	newObj.set_object(shape)
	newObj.mainScene = self
	if function != {}:
		var callableFunc = Callable(newObj, function["func"])
		function.func = callableFunc
		if function.has("trigger"):
			newObj.triggeredFunctions.append(function)
		else:
			newObj.functions.append(function)
	return newObj

func do_game_over():
	music.stop_all()
	$GameOver.visible = true
	gameOver = true

func play_sound(path: String):
	var sound_stream = load(path)
	$SoundPlayer.stream = sound_stream
	$SoundPlayer.play()

func generate_level_text(level: String, characters: Array):
	var returnText = ""
	returnText += level + "\n"
	for character in characters:
		returnText += character.get("name","No Name Found")
	returnText += "\n"
	returnText += characters[0].get("desc", "No Description")
	return returnText

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_input_event_left(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		for obj in leftButtonTriggers:
			for function in obj.triggeredFunctions:
				if function.trigger == "left_button":
					function.func.call(function.params)

func _on_input_event_right(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		for obj in rightButtonTriggers:
			for function in obj.triggeredFunctions:
				if function.trigger == "right_button":
					function.func.call(function.params)
