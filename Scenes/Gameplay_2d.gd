extends CanvasLayer

class Main:
	var insanity = 0

	var room_node : AnimatedSprite2D
	var room_name = "Bed"
	var room_mouse_debounce = true
	#Uses insanity

	var background_node : ColorRect
	var background_animation = true

	var task_node : AnimatedSprite2D
	var task_done = false
	var task_current = ""
	var task_new = ""
	
	var animation_node : AnimatedSprite2D
	var animation_current = "Wake_Up_Loop"
	#Uses insanity

	var diologue_popup_node : AnimatedSprite2D
	var diologue_popup_start = true
	var diologue_popup_debounce = true

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
	var cursor_state_current = "Default"
	var cursor_state = "Point"

	func _init(in_nodes) -> void:
		task_node = in_nodes["Task"]
		room_node = in_nodes["Room"]
		cursor_node = in_nodes["Cursor"]
		diologue_node = in_nodes["Diologue"]
		animation_node = in_nodes["Animation"]
		background_node = in_nodes["Background"]
		diologue_popup_node = in_nodes["Diologue_popup"]

		task_node.position.x = -160

		start_animation()

		diologue_node.visible = false

		diologue_popup_node.frame = 0

		start_animation()

	func tick(delta, cursor_position) -> void:
		update_task(delta)
		update_background(delta)
		update_diologue_popup()
		update_animation()
		update_diologue()
		update_room(cursor_position)
		update_cursor(cursor_position)

	func update_task(delta) -> void:
		if task_current == "":
			task_node.position.x += (-640 - task_node.position.x) * delta * 2
			return
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
		background_animation = true
		animation_node.play(animation_current)

	func update_animation() -> void:
		if animation_node.animation == "Wake_Up_Loop" and animation_node.is_playing():
			cursor_state = "Point"
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				cursor_state = "Grab"
				diologue_current = "Wakeup"
				animation_current = "Wake_Up"
				task_current = "Wake_Up"
				task_new = "Eat"
				room_name = "Bed"
				start_animation()
		if not animation_node.is_playing() and animation_node.visible:
			background_animation = false
			animation_node.visible = false
			diologue_popup_start = false
			start_diologue_popup()

	func start_diologue_popup() -> void:
		if not func_diologue_check(diologue_popup_start):
			if diologue_popup_start:
				start_animation()
			else:
				end_task()
		diologue_popup_node.play("Diologue_popup")
	
	func update_diologue_popup() -> void:
		if not diologue_popup_node.is_playing():
			if diologue_popup_node.frame == 5 and not diologue_up:
				diologue_up = true
				diologue_popup_debounce = true
				start_diologue(diologue_popup_start)
			if diologue_popup_node.frame == 0 and diologue_popup_debounce:
				diologue_popup_debounce = false
				if diologue_popup_start:
					start_animation()
				else:
					end_task()

	func end_diologue_popup() -> void:
		diologue_popup_node.play_backwards("Diologue_popup")
		cursor_state = "Default"
		diologue_up = false

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
		if diologue_up:
			cursor_state = "Point"
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				if diologue_mouse_debounce: return
				diologue_mouse_debounce = true
				end_diologue_popup()
				diologue_node.visible = false
			else:
				diologue_mouse_debounce = false
	
	func end_task() -> void:
		task_done = true
		animation_node.visible = false
		diologue_popup_start = false
	
	func update_background(delta) -> void:
		if background_animation:
			background_node.color += (Color(1,1,1) - background_node.color) * delta
		else:
			background_node.color += (Color(0,0,0) - background_node.color) * delta

	func update_room(cursor_position) -> void:
		var temp_insanity_check = "Normal" if insanity <= 1 else "Insane"
		if room_node.animation != temp_insanity_check + "_" + room_name:
			room_node.play(temp_insanity_check + "_" + room_name)
		if not diologue_up and not background_animation:
			if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				room_mouse_debounce = true
			if cursor_position.x < 200:
				cursor_state = "Arrow_l"
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and room_mouse_debounce:
					cursor_state = "Arrow"
					room_mouse_debounce = false
					match room_name:
						"Bed":
							room_name = "Mirror"
						"Door":
							room_name = "Bed"
						"Mirror":
							room_name = "Shelf"
						"Shelf":
							room_name = "Door"
			elif cursor_position.x > 440:
				cursor_state = "Arrow_r"
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and room_mouse_debounce:
					cursor_state = "Arrow"
					room_mouse_debounce = false
					match room_name:
						"Bed":
							room_name = "Door"
						"Door":
							room_name = "Shelf"
						"Mirror":
							room_name = "Bed"
						"Shelf":
							room_name = "Mirror"
			else:
				cursor_state = "Default"


	
	func update_cursor(cursor_position) -> void:
		cursor_node.position = cursor_position + Vector2(0,20)
		if cursor_state_current == cursor_state: return
		if not cursor_node.is_playing():
			match cursor_state_current:
				"Default":
					match cursor_state:
						"Point":
							cursor_node.play("Point")
							cursor_state_current = "Point"
						"Arrow", "Arrow_l", "Arrow_r":
							cursor_node.play("Arrow")
							cursor_state_current = "Arrow"
				"Point":
					if cursor_state == "Grab":
						cursor_node.play("Point_Grab")
						cursor_state_current = "Grab"
					else:
						cursor_node.play_backwards("Point")
						cursor_state_current = "Default"
				"Grab":
						cursor_node.play_backwards("Point_Grab")
						cursor_state_current = "Point"
				"Arrow":
					match cursor_state:
						"Default","Point","Grab":
							cursor_node.play_backwards("Arrow")
							cursor_state_current = "Default"
						"Arrow_l":
							cursor_node.play("Arrow_Left")
							cursor_state_current = "Arrow_l"
						"Arrow_r":
							cursor_node.play("Arrow_Right")
							cursor_state_current = "Arrow_r"
				"Arrow_l":
					cursor_node.play_backwards("Arrow_Left")
					cursor_state_current = "Arrow"
				"Arrow_r":
					cursor_node.play_backwards("Arrow_Right")
					cursor_state_current = "Arrow"


var main_class
func _ready() -> void:
	main_class = Main.new({
		"Task" : $Tasks,
		"Room" : $Room,
		"Cursor" : $Pointy,
		"Diologue" : $Diologue,
		"Animation" : $Animations,
		"Background" : $Background,
		"Diologue_popup" : $Diologue_PopUp
	})

#debugs mouse
func debug():
	while true:
		await get_tree().create_timer(1).timeout
		var temp_random = ["Default","Point","Grab","Arrow", "Arrow_l", "Arrow_r"].pick_random()
		print(temp_random)
		main_class.cursor_state = temp_random

func _process(delta: float) -> void:
	main_class.tick(delta, get_viewport().get_mouse_position())
