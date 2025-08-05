extends CanvasLayer

func _ready() -> void:
    visible = false

func _input(event):
    if event.is_action_pressed("escape"):
        if get_parent().menu_opened:
            visible = false
            get_parent().menu_opened = false
        else:
            $ColorRect/VBoxContainer/Continue.grab_focus()
            visible = true
            get_parent().menu_opened = true


func _on_menu_button_up() -> void:
    get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_continue_button_up() -> void:
    visible = false
    get_parent().menu_opened = false
