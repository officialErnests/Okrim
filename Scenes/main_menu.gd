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
	$OhSoBeutifulFradile.play()
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
	main_menu.get_node("New_game").grab_focus()
	if MainData.player_save != 0: main_menu.get_node("Phase select").text = "Phases"
	if MainData.player_save >= 1: phase_menu.get_node("Day1").text = "DAY - 1 - DAY"
	if MainData.player_save >= 2: phase_menu.get_node("Day2").text = "DAY - 2 - DAY"
	if MainData.player_save >= 3: phase_menu.get_node("Day3").text = "DAY - 3 - DAY"
	if MainData.player_save >= 4: phase_menu.get_node("Room").text = "ROOM - 4 - ROOM"

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
	MainData.selected_level = 0
	transition_type = 0
	$Open.play()


func _on_options_button_up() -> void:
	if transition: return
	option_menu.get_node("Back").grab_focus()
	main_menu.visible = false
	option_menu.visible = true
	$Open.play()


func _on_phase_select_button_up() -> void:
	if transition: return
	if MainData.player_save == 0: return
	phase_menu.get_node("Back").grab_focus()
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
	main_menu.get_node("Options").grab_focus()
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

func _on_day_1_button_up() -> void:
	if MainData.player_save < 1: return
	transition = true
	MainData.selected_level = 1
	transition_type = 0
	$Open.play()

func _on_day_2_button_up() -> void:
	if MainData.player_save < 2: return
	transition = true
	MainData.selected_level = 2
	transition_type = 0
	$Open.play()

func _on_day_3_button_up() -> void:
	if MainData.player_save < 3: return
	transition = true
	MainData.selected_level = 3
	transition_type = 0
	$Open.play()

func _on_room_button_up() -> void:
	if MainData.player_save < 4: return
	transition = true
	MainData.selected_level = 4
	transition_type = 0
	$Open.play()
