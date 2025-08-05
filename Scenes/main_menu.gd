extends Control
@onready var main_menu = $Main
@onready var opton_menu = $Options
@onready var phase_menu = $Phases
@onready var transition_node = $transition_color
@onready var cursor_node = $Pointy

var transition = false
var transition_time = 0

func _ready() -> void:
	for child_node in main_menu.get_children():
		if child_node is Button:
			child_node.focus_entered.connect(button_hover)
			child_node.mouse_entered.connect(button_hover)

func _process(delta: float) -> void:
	cursor_node.position = get_viewport().get_mouse_position() + Vector2(0,20)
	if transition:
		transition_time += delta
		transition_node.color = Color(1,1,1,transition_time/2)
		if transition_time >= 2:
			get_tree().change_scene_to_file("res://Scenes/MainGame.tscn")

func button_hover() -> void:
	$Click.play()


func _on_new_game_button_up() -> void:
	if transition: return
	transition = true


func _on_options_button_up() -> void:
	if transition: return


func _on_phase_select_button_up() -> void:
	if transition: return


func _on_exit_button_up() -> void:
	if transition: return
