extends CanvasLayer

class Main:
	var glitch_precentile = 0
	var insanity = 0

	var room_node : AnimatedSprite2D
	var room_name = "Bed"
	#Uses insanity

	var background_node : ColorRect
	var background_animation = false

	var task_node : AnimatedSprite2D
	var task_done = false
	var task_current = ""
	var task_new = ""
	
	var animation_node : AnimatedSprite2D
	var animation_current = "Wake_Up_Loop"
	#Uses insanity

	var diologue_popup_node : AnimatedSprite2D
	var diologue_popup_start = false

	var diologue_node : Sprite2D
	var diologue_current = "Wakeup"
	var diologue_up = false
	var diologue_mouse_debounce = false
	var diologue_offsets = {
		"0_Wakeup_Start" = Vector3(0,39,1),  
		"0_Eat_Start" = Vector3(0,4,0),
		"0_Eat_End" = Vector3(0,6,1),
		"0_Door_Start" = Vector3(0,10,1),
		"0_Door_End" = Vector3(0,14,1),
		"0_Book_Start" = Vector3(0,18,1),
		"0_Book_End" = Vector3(0,22,1),
		"0_Mirror_Start" = Vector3(0,26,1),
		"0_Drink_Start" = Vector3(0,30,1),
		"0_Drink_End" = Vector3(0,34,1),
		"0_Wakeup_End" = Vector3(0,0,1),

		"1_Door_End" = Vector3(2,12,1),
		"1_Mirror_Start" = Vector3(2,24,1),
		"1_Drink_Start" = Vector3(2,47,1),
		"1_Eat_Start" = Vector3(1,0,1),

		"2_Wakeup_End" = Vector3(1,38,0),
		"2_Eat_End" = Vector3(1,4,1),
		"2_Door_Start" = Vector3(2,8,1),
		"2_Door_End" = Vector3(1,8,1),
		"2_Book_Start" = Vector3(2,16,1),
		"2_Mirror_End" = Vector3(2,28,1),
		"2_Mirror_Start" = Vector3(2,32,1),
		"2_Drink_Start" = Vector3(2,39,0),
		"2_Wakeup_Start" = Vector3(1,43,0),

		"3_Wakeup_End" = Vector3(2,42,1),
		"3_Eat_Start" = Vector3(2,4,1),
		"3_Door_Start" = Vector3(2,20,1),
		"3_Book_Start" = Vector3(1,12,1),
		"3_Mirror_Start" = Vector3(1,28,1),
		"3_Drink_Start" = Vector3(2,36,0),
		"3_Wakeup_Start" = Vector3(1,39,0),

		"4_Door_Start" = Vector3(1,32,1),
	}
	#uses insanity

	var cursor_node : AnimatedSprite2D

	func _init(in_nodes) -> void:
		task_node = in_nodes["Task"]
		room_node = in_nodes["Room"]
		diologue_node = in_nodes["Diologue"]
		animation_node = in_nodes["Animation"]
		background_node = in_nodes["Background"]
		diologue_popup_node = in_nodes["Diologue_popup"]

		task_node.position.x = -160

		start_animation()

		diologue_node.visible = false

		diologue_popup_node.frame = 0
		start_diologue_popup()

	func tick(delta) -> void:
		update_task(delta)
		update_diologue_popup()
		update_animation()

	func update_task(delta) -> void:
		if task_current == "":
			task_node.position.x += (-640 - task_node.position.x) * delta * 2
		if task_done:
			if task_node.animation != task_current + "_Done":
				task_node.play(task_current + "_Done")
			if not task_node.is_playing():
				task_node.position.x += (-250 - task_node.position.x) * delta * 2
				if task_node.position.x <= -200:
					task_done = false
					task_current = task_new
					task_new = "Idk"
		else:
			if task_node.animation != task_current + "_Done":
				task_node.play(task_current)
			task_node.position.x += (160 - task_node.position.x) * delta * 2
	
	func start_animation() -> void:
		animation_node.play(animation_current)

	func update_animation() -> void:
		if animation_node.animation == "Wake_Up_Loop" and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			diologue_current = "Wakeup"
			animation_current = "Wake_Up"
			task_current = "Wake_Up"
			task_new = "Eat"
			room_name = "Bed"
			start_animation()
		if not animation_node.is_playing() and animation_node.visible:
			animation_node.visible = false
			diologue_popup_start = false
			task_done = true
			start_diologue_popup()

	func start_diologue_popup() -> void:
		if not func_diologue_check(diologue_popup_start): return
		diologue_popup_node.play("Diologue_popup")
	
	func update_diologue_popup() -> void:
		if diologue_popup_node.frame == 5 and not diologue_up:
			diologue_up = true
			start_diologue(diologue_popup_start)

	func func_diologue_check(in_animation_position) -> bool:
		var temp_animation_position = "Start" if in_animation_position else "End"
		return diologue_offsets.has(str(insanity) + "_" + diologue_current + "_" + temp_animation_position)

	func start_diologue(in_animation_position) -> void:
		diologue_node.visible = true
		var temp_animation_position = "Start" if in_animation_position else "End"
		var temp_dioologue_offset = diologue_offsets[str(insanity) + "_" + diologue_current + "_" + temp_animation_position]
		print(temp_dioologue_offset)
		diologue_node.region_rect = Rect2(temp_dioologue_offset.x * 640, temp_dioologue_offset.y * 40, 640, 80 + temp_dioologue_offset.z * 80)
	
	func update_diologue() -> void:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if diologue_mouse_debounce: return
			diologue_mouse_debounce = true
		else:
			diologue_mouse_debounce = false


var main_class
func _ready() -> void:
	main_class = Main.new({
		"Task" : $Tasks,
		"Room" : $Room,
		"Diologue" : $Diologue,
		"Animation" : $Animations,
		"Background" : $Background,
		"Diologue_popup" : $Diologue_PopUp
	})

func _process(delta: float) -> void:
	main_class.tick(delta)
