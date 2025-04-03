extends Node2D

const upgrades = preload("res://scenes/helpers/upgrades/upgrades.gd")
const functions = preload("res://scenes/helpers/functions.gd")
const levels = preload("res://scenes/levels/levels.gd")
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
var basketArr: Array
var music: AudioStreamPlayer
var gameplay_viewport: Dictionary

var prevMoney = 0
var money = 1
var prevMoneyEarned = 0
var moneyEarned = 0
var dropCost = 1
var upgradeWeights = [5,4,3,2,1]

var currLevel = levels.check_level(money)
var lastLevel: String
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
	basketArr.append(baskScene.instantiate()) # Instantiate basket
	basketArr.back().label = "Gain $10"
	basketArr.back().function = "+"
	basketArr.back().value = 10
	add_child(basketArr.back())
	basketArr.back().position = Vector2(gameplay_viewport.left,1080)
	music = musicScene.instantiate() # Instantiate music
	add_child(music)
	menu = menuScene.instantiate() # Instantiate menu
	add_child(menu)
	currentOptions = upgrades.setPegs.set_options(menu)
	menu.function = "randomize_pegs"
	
	$Level.text = "Next level at $" + str(currLevel)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Money.text = "Bank Account: $" + str(money)
	$MoneyEarned.text = "Money Earned: $" + str(moneyEarned)
	$DropCost.text = "Cost to Drop: $" + str(dropCost)
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
			upgrades.handle_options(self, currentOptions[menu.selected])
			functions.handle_function(self, menu)
			menu.free()
			menuOpen = false
	elif !gameOver:
		if ball.is_dropped:
			if ball.time_dropped != null: # Do something when ball is dropped
				ball.time_dropped = null
				if dropCost <= money:
					money -= dropCost
			if ball.impulse_factor > 5:
				objArr.erase(ball.last_touched)
				ball.last_touched.free()
				ball.impulse_factor = 1
			moneyEarned = ball.money_gathered
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
		dropCost *= 2
		moneyEarned = 0
		body.free()
		for basket in basketArr:
			if basket.entered:
				functions.handle_function(self, basket)
				basket.entered = false
		currLevel = levels.check_level(money)
		if dropCost > money:
			music.stop_all()
			$GameOver.visible = true
			gameOver = true
		else:
			$happySound.play()
			menu = menuScene.instantiate()
			if currLevel is String and currLevel != lastLevel:
				lastLevel = currLevel
				$Level.text = currLevel
				music.stop_all()
				currentOptions = levels.load_level(menu)
			else:
				$Level.text = "Next level at $" + str(currLevel)
				currentOptions = upgrades.pegUpgrades.set_options(menu, upgradeWeights)
			call_deferred("add_child", menu)
			menuOpen = true

func add_coll_object(objPosition, function, scene, shape):
	objArr.append(scene.instantiate())
	add_child(objArr.back())
	objArr.back().global_position = objPosition
	objArr.back().function = function
	objArr.back().set_object(shape)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
