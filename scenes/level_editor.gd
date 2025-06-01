extends Node2D

@onready var levels_container = $HBoxContainer/LeftMarginContainer/ScrollContainer/LevelDataContainer
@onready var character_order_list = $HBoxContainer/RightMarginContainer/ScrollContainer/CharacterOrderList

static var level_data_file = "res://assets/data/levels.json"
static var level_data_json = FileAccess.get_file_as_string(level_data_file)
static var level_data = JSON.parse_string(level_data_json)

static var level_order_file = "user://level_order.json"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for level_name in level_data.keys():
		var level = level_data[level_name]
		var collapsible = create_collapsible(level_name, level["characters"])
		levels_container.add_child(collapsible)
	load_character_order_from_file(level_order_file)


func load_character_order_from_file(file_path: String = "user://level_order.json") -> void:
	if not FileAccess.file_exists(file_path):
		print("No save file found.")
		return

	var file = FileAccess.open(file_path, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()

	var result = JSON.parse_string(json_string)
	if result is Array:
		rebuild_character_order_list(result)


func rebuild_character_order_list(order: Array) -> void:
	for character in order:
		add_character_to_right_panel(JSON.parse_string(character))


func create_collapsible(level_name: String, characters: Array) -> VBoxContainer:
	var box = VBoxContainer.new()
	var button = Button.new()
	button.text = level_name
	box.add_child(button)

	var character_list = VBoxContainer.new()
	character_list.name = "CharacterList"
	box.add_child(character_list)

	for character in characters:
		var hbox = HBoxContainer.new()
		var vbox = VBoxContainer.new()
		
		var name_label = Label.new()
		name_label.text = "* " + character.get("name", "Unknown")
		name_label.add_theme_font_size_override("font_size", 16)
		vbox.add_child(name_label)
		
		var desc_label = Label.new()
		desc_label.text = "- " + character.get("desc", "Unknown")
		vbox.add_child(desc_label)
		
		for key in character.keys():
			if key != "name" && key != "desc":
				var key_label = Label.new()
				key_label.text += "    - " + key + ": " + character[key]
				vbox.add_child(key_label)

		hbox.add_child(vbox)

		var spacer = Control.new()
		spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(spacer)

		var add_button = Button.new()
		add_button.text = "Add\n" + character.get("name", "Unknown")
		hbox.add_child(add_button)

		add_button.pressed.connect(func():
			add_character_to_right_panel(character)
		)

		character_list.add_child(hbox)

	button.connect("pressed", func():
		character_list.visible = !character_list.visible
	)

	return box


func add_character_to_right_panel(character: Dictionary):
	var hbox = HBoxContainer.new()
	hbox.set_meta("character_tag", JSON.stringify(character))

	var char_label = Label.new()
	char_label.text = character.get("name", "Name Not Found")
	hbox.add_child(char_label)

	var remove_button = Button.new()
	remove_button.text = "Remove"
	hbox.add_child(remove_button)

	remove_button.pressed.connect(func():
		character_order_list.remove_child(hbox)
		hbox.queue_free()
	)

	character_order_list.add_child(hbox)


func get_character_order() -> Array:
	var order := []
	for row in character_order_list.get_children():
		if row != $HBoxContainer/RightMarginContainer/ScrollContainer/CharacterOrderList/LeftTitleRow:
			var tag = row.get_meta("character_tag", "No Tag Found")
			order.append(tag)
	return order


func _on_X_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_save_button_pressed() -> void:
	var order = get_character_order()
	var json_string = JSON.stringify(order, "\t")

	var file = FileAccess.open(level_order_file, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		print("Saved character order to: ", level_order_file)
	else:
		print("Failed to save file!")


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
