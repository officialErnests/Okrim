extends Control
@onready var main_menu = $Main
@onready var option_menu = $Options
@onready var phase_menu = $Phases
@onready var transition_node = $transition_color
@onready var cursor_node = $Pointy
@onready var bg_color_node = $bg_color

var transition = false
var transition_time = 0
var transition_type = 0

func _ready() -> void:
	option_menu.get_node("Music/Music_slider").value = MainData.music_volume
	option_menu.get_node("Sfx/Sfx_slider").value = MainData.sfx_volume
	for child_node in main_menu.get_children():
		if child_node is Button:
			child_node.focus_entered.connect(button_hover)
			child_node.mouse_entered.connect(button_hover)
	for child_node in option_menu.get_children():
		if child_node is Button:
			child_node.focus_entered.connect(button_hover)
			child_node.mouse_entered.connect(button_hover)
	for child_node in phase_menu.get_children():
		if child_node is Button:
			child_node.focus_entered.connect(button_hover)
			child_node.mouse_entered.connect(button_hover)

func _process(delta: float) -> void:
	cursor_node.position = get_viewport().get_mouse_position() + Vector2(0,20)
	if transition:
		transition_time += delta
		if transition_type == 0:
			transition_node.color = Color(1,1,1,transition_time/2)
			if transition_time >= 2:
				get_tree().change_scene_to_file("res://Scenes/MainGame.tscn")
		elif transition_type == 1:
			bg_color_node.color = Color(0,0,0,0.4 + transition_time/3.8)
			if transition_time >= 2:
				get_tree().quit()

func button_hover() -> void:
	$Click.play()


func _on_new_game_button_up() -> void:
	if transition: return
	transition = true
	transition_type = 0
	$Open.play()


func _on_options_button_up() -> void:
	if transition: return
	main_menu.visible = false
	option_menu.visible = true
	$Open.play()


func _on_phase_select_button_up() -> void:
	if transition: return
	main_menu.visible = false
	phase_menu.visible = true
	$Open.play()


func _on_exit_button_up() -> void:
	if transition: return
	transition = true
	transition_type = 1
	main_menu.visible = false
	$Open.play()
	

func _on_back_button_up() -> void:
	if transition: return
	main_menu.visible = true
	phase_menu.visible = false
	option_menu.visible = false
	$Crumble.play()



func _on_music_slider_value_changed(value:float) -> void:
	if transition: return
	MainData.music_volume = value
	MainData.settings_changed.emit()
	$Click.play()

func _on_sfx_slider_value_changed(value:float) -> void:
	if transition: return
	MainData.sfx_volume = value
	MainData.settings_changed.emit()
	$Click.play()
