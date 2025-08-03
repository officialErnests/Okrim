extends CanvasLayer

var pointed_at = ""
var movement = false
@onready var parent_script = $".."
@onready var music_player_norm = $"../Fun-8-bit"
@onready var music_players_not = $"../Not-so-fun-8-bit"
@onready var music_players_insane = $"../OhGod"
@onready var sfx_click = $"../Click"
@onready var sfx_crumble = $"../Crumble"
@onready var sfx_open = $"../Open"

class Main:
	var insanity = 0
	var days = 0
	#Save states:
	#1 : day = 1, insanity = 0
	#2 : day = 2, insanity = 0
	#3 : day = 3, insanity = 1
	var room_node : AnimatedSprite2D
	var room_name = "Bed"
	var room_state = 0
	#Uses insanity

	var music_player_norm
	var music_players_not
	var music_players_insane
	var sfx_click
	var sfx_crumble
	var sfx_open

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
	var diologue_popup_debounce = false

	var diologue_node : Sprite2D
	var diologue_current = "Wakeup"
	var diologue_offsets = {
		"0_Wakeup_Start" = [0,38,1],
		"0_Eat_Start" = [0,4,0],
		"0_Eat_End" = [0,5,1],
		"0_Door_Start" = [0,9,1],
		"0_Door_End" = [0,13,1],
		"0_Book_Start" = [0,16,1],
		"0_Book_End" = [0,20,1],
		"0_Mirror_Start" = [0,24,1],
		"0_Drink_Start" = [0,28,1],
		"0_Drink_End" = [0,33,1],
		"0_Wakeup_End" = [0,0,1],

		
		"1_Wakeup_Start" = [0,38,1],
		"1_Eat_End" = [0,5,1],
		"1_Door_Start" = [0,9,1],
		"1_Book_Start" = [0,16,1],
		"1_Book_End" = [0,20,1],
		"1_Wakeup_End" = [0,0,1],

		"1_Door_End" = [2,12,1],
		"1_Mirror_Start" = [2,24,1],
		"1_Drink_Start" = [2,47,1],
		"1_Eat_Start" = [1,0,1],

		"2_Drink_End" = [0,33,1],
		"2_Eat_Start" = [1,0,1],

		"2_Wakeup_End" = [1,44,1],
		"2_Eat_End" = [1,4,1],
		"2_Door_Start" = [2,8,1],
		"2_Door_End" = [1,9,1],
		"2_Book_Start" = [2,16,1],
		"2_Mirror_End" = [2,27,1],
		"2_Mirror_Start" = [2,32,1],
		"2_Drink_Start" = [2,38,1],
		"2_Wakeup_Start" = [1,36,1],

		"3_Wakeup_End" = [2,42,1],
		"3_Eat_Start" = [2,4,1],
		"3_Door_Start" = [2,19,1],
		"3_Book_Start" = [1,12,1],
		"3_Mirror_Start" = [1,28,1],
		"3_Drink_Start" = [2,36,0],
		"3_Wakeup_Start" = [1,40,1],

		"4_Wakeup_End" = [2,42,1],
		"4_Eat_Start" = [2,4,1],
		"4_Door_Start" = [2,19,1],
		"4_Book_Start" = [1,12,1],
		"4_Mirror_Start" = [1,28,1],
		"4_Drink_Start" = [2,36,0],
		"4_Wakeup_Start" = [1,40,1],

		"5_Door_Start" = [1,32,1],
	}
	#uses insanity

	var cursor_node : AnimatedSprite2D
	var cursor_state_current = "Default"
	var cursor_state = "Point"
	var cursor_debounce = true

	func _init(in_nodes, in_parent_node) -> void:
		task_node = in_nodes["Task"]
		room_node = in_nodes["Room"]
		cursor_node = in_nodes["Cursor"]
		diologue_node = in_nodes["Diologue"]
		animation_node = in_nodes["Animation"]
		background_node = in_nodes["Background"]
		diologue_popup_node = in_nodes["Diologue_popup"]

		task_node.position.x = -160

		diologue_node.visible = false

		diologue_popup_node.frame = 0
		
		diologue_current = "Wakeup"
		animation_current = "Wake_Up_Loop"
		room_state = 2
		start_animation()

		music_player_norm = in_parent_node.music_player_norm
		music_players_not = in_parent_node.music_players_not
		music_players_insane = in_parent_node.music_players_insane

		sfx_click = in_parent_node.sfx_click
		sfx_crumble = in_parent_node.sfx_crumble
		sfx_open = in_parent_node.sfx_open

	func tick(delta, cursor_position, in_class_holder) -> void:
		update_task(delta)
		update_background(delta)
		update_diologue_popup()
		update_animation()
		update_diologue()
		update_room(cursor_position, in_class_holder)
		update_cursor(cursor_position)
		# print(days, insanity)
		# print(animation_current)
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			cursor_debounce = true
		
	func update_task(delta) -> void:
		if task_current == "":
			task_node.position.x += (-640 - task_node.position.x) * delta * 2
			return
		if task_done:
			if task_node.animation != task_current + "_Done":
				task_node.play(task_current + "_Done")
			if not task_node.is_playing():
				task_node.position.x -= 1000 * delta 
				if task_node.position.x <= -200:
					task_done = false
					task_current = task_new
					task_new = "Idk"
		else:
			if task_node.animation != task_current + "_Done":
				task_node.play(task_current)
			task_node.position.x += (160 - task_node.position.x) * delta * 2
	
	func start_event(in_event_name, in_next_task, in_animation) -> void:
		diologue_current = in_event_name
		task_new = in_next_task
		animation_current = in_animation
		room_state = 0
		if func_diologue_check(true): start_diologue_popup()
		else: middle_event()
	
	func middle_event() -> void:
		room_state = 2
		if diologue_current == "Wakeup" and insanity >= 3: 
			stop_event()
			return
		if animation_current != "": start_animation()
		else: end_event()

	func end_event() -> void:
		room_state = 4
		if func_diologue_check(false): start_diologue_popup()
		else: stop_event()

	func stop_event() -> void:
		if insanity == 3 and diologue_current == "Mirror": insanity = 4
		if insanity == 4 and animation_current == "Key": insanity = 5
		if insanity == 5 and animation_current == "Open":
			task_node.position.x = -160

			diologue_node.visible = false

			diologue_popup_node.frame = 0
			
			diologue_current = "Wakeup"
			animation_current = "Wake_Up_Loop"
			animation_node.visible = true

			room_state = 2
			days = 0
			insanity = 0
			start_animation()
			room_node.visible = true
			music_players_insane.stop()
			music_player_norm.play()
			return
		task_done = true
		room_state = 6

	func start_animation() -> void:
		if animation_current == "Wake_Up_Loop" and task_current == "Sleep":
			task_done = true
		background_animation = true
		room_state = 3
		animation_node.visible = true
		if insanity > 1 and not animation_current == "Wake_Up" and not  animation_current == "Wake_Up_Loop" :
			animation_node.play(animation_current+"_Insanity")
		else:
			animation_node.play(animation_current)

	func update_animation() -> void:
		if animation_node.animation == "Wake_Up_Loop" and animation_node.is_playing():
			cursor_state = "Point"
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cursor_debounce:
				cursor_debounce = false
				cursor_state = "Grab"
				task_done = false
				animation_current = "Wake_Up"
				task_current = "Wake_Up"
				task_new = "Eat"
				if days == 2:
					insanity += 1
				if days == 3:
					if not music_players_not.playing:
						music_player_norm.stop()
						music_players_not.play()
					insanity += 1
				middle_event()
		if animation_node.animation == "Drink_Insanity" and animation_node.is_playing():
			insanity = 3
			if not music_players_insane.playing:
				music_players_not.stop()
				music_players_insane.play()
			room_node.visible = false
		else:
			if animation_node.animation != "Open_Insanity":
				if animation_node.is_playing() and animation_node.visible and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cursor_debounce:
					cursor_debounce = false
					background_animation = false
					animation_node.visible = false
					end_event()
		if not animation_node.is_playing() and animation_node.visible:
			background_animation = false
			animation_node.visible = false
			end_event()

	func start_diologue_popup() -> void:
		if room_state == 0:
			room_state = 1
		else:
			room_state = 5
		sfx_open.play()
		diologue_popup_node.play("Diologue_popup")
	
	func update_diologue_popup() -> void:
		if not diologue_popup_node.is_playing():
			if diologue_popup_node.frame == 5 and diologue_popup_debounce:
				diologue_popup_debounce = false
				start_diologue()
			if diologue_popup_node.frame == 0 and diologue_popup_debounce:
				diologue_popup_debounce = false
				if room_state == 1:
					middle_event()
				else:
					stop_event()
		else:
			diologue_popup_debounce = true

	func end_diologue_popup() -> void:
		sfx_crumble.play()
		diologue_popup_node.play_backwards("Diologue_popup")
		cursor_state = "Default"

	func func_diologue_check(in_animation_position) -> bool:
		var temp_animation_position = "Start" if in_animation_position else "End"
		return diologue_offsets.has(str(insanity) + "_" + diologue_current + "_" + temp_animation_position)

	func start_diologue() -> void:
		diologue_node.visible = true
		var temp_animation_position = "Start" if room_state == 1 else "End"
		var temp_dioologue_offset = diologue_offsets[str(insanity) + "_" + diologue_current + "_" + temp_animation_position]
		diologue_node.region_rect = Rect2(temp_dioologue_offset[0] * 640, temp_dioologue_offset[1] * 40, 640, 80 + temp_dioologue_offset[2] * 80)
	
	func update_diologue() -> void:
		if (room_state == 1 or room_state == 5) and diologue_node.visible:
			cursor_state = "Point"
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cursor_debounce:
				cursor_debounce = false
				end_diologue_popup()
				cursor_state = "Grab"
				diologue_node.visible = false
	
	func update_background(delta) -> void:
		if insanity > 2:
			if background_animation:
				background_node.color += (Color(1,1,1,1) - background_node.color) * delta * 10
			else:
				background_node.color += (Color(0,0,0,0) - background_node.color) * delta * 10
		else:
			if background_animation:
				background_node.color += (Color(1,1,1) - background_node.color) * delta * 10
			else:
				background_node.color += (Color(0,0,0) - background_node.color) * delta * 10

	func update_room(cursor_position, class_holder) -> void:
		var temp_insanity_check = "Normal" if insanity <= 1 else "Insanity"
		if room_node.animation != temp_insanity_check + "_" + room_name:
			room_node.play(temp_insanity_check + "_" + room_name)
		if days > 0 and randf() < 0.002:
			room_node.play(temp_insanity_check + "_" + room_name + "_Glitch")
		if insanity < 3:
			if room_state == 6 and not task_done:
				if cursor_position.x < 200:
					cursor_state = "Arrow_l"
					if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cursor_debounce:
						cursor_state = "Arrow"
						cursor_debounce = false
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
					if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cursor_debounce:
						cursor_state = "Arrow"
						cursor_debounce = false
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
					if task_current == "Eat" and room_name == "Door":
						cursor_state = "Point"
						if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cursor_debounce:
							cursor_debounce = false
							start_event("Eat", "Door", "Eat")
					elif task_current == "Door" and room_name == "Door":
						cursor_state = "Point"
						if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cursor_debounce:
							cursor_debounce = false
							start_event("Door", "Read", "Door")
					elif task_current == "Read" and room_name == "Shelf":
						cursor_state = "Point"
						if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cursor_debounce:
							cursor_debounce = false
							start_event("Book", "Yourself", "Book")
					elif task_current == "Yourself" and room_name == "Mirror":
						cursor_state = "Point"
						if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cursor_debounce:
							cursor_debounce = false
							if days == 1:
								start_event("Mirror", "Idk", "Mirror")
								music_player_norm.stop()
							else: 
								start_event("Mirror", "Drink", "Mirror")
					elif task_current == "Drink" and room_name == "Bed":
						cursor_state = "Point"
						if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cursor_debounce:
							cursor_debounce = false
							if days == 2:
								start_event("Drink", "Sleep", "")
							else:
								if days == 3:
									start_event("Drink", "Idk", "Drink")
								else:
									start_event("Drink", "Sleep", "Drink")
					elif task_current == "Sleep" and room_name == "Bed":
						cursor_state = "Point"
						if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cursor_debounce:
							cursor_debounce = false
							days += 1
							start_event("Wakeup", "", "Wake_Up_Loop")
					elif task_current == "Idk":
						cursor_state = "Point"
						if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cursor_debounce:
							cursor_debounce = false
							music_player_norm.play()
							start_event("", "Sleep", "")
					else:
						cursor_state = "Default"
		else:
			if room_state == 6 and not task_done:
				class_holder.parent_script.can_look  = true
				if class_holder.movement:
					cursor_state = "Arrow"
				else:
					if class_holder.pointed_at == "":
						if cursor_position.x < 200:
							cursor_state = "Arrow_l"
						elif cursor_position.x > 440:
							cursor_state = "Arrow_r"
						else:
							cursor_state = "Default"
					else:
						cursor_state = "Point"
						if insanity == 3:
							if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cursor_debounce:
								cursor_debounce = false
								match class_holder.pointed_at:
									"Books_0", "Books_1":
										start_event("Book", "Idk", "")
									"Door":
										start_event("Door", "Idk", "")
									"Table":
										start_event("Eat", "Idk", "")
									"Bed":
										start_event("Wakeup", "Idk", "")
									"Pills":
										start_event("Drink", "Idk", "")
									"Mirror":
										start_event("Mirror", "Idk", "")
						elif insanity == 4:
							if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cursor_debounce:
								cursor_debounce = false
								match class_holder.pointed_at:
									"Books_0":
										start_event("Book", "Idk", "")
									"Books_1":
										start_event("", "Idk", "Key")
									"Door":
										start_event("Door", "Idk", "")
									"Table":
										start_event("Eat", "Idk", "")
									"Bed":
										start_event("Wakeup", "Idk", "")
									"Pills":
										start_event("Drink", "Idk", "")
									"Mirror":
										start_event("Mirror", "Idk", "")
						elif insanity == 5:
							if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cursor_debounce:
								cursor_debounce = false
								match class_holder.pointed_at:
									"Books_0", "Books_1":
										start_event("Book", "Idk", "")
									"Door":
										start_event("Door", "Idk", "Open")
									"Table":
										start_event("Eat", "Idk", "")
									"Bed":
										start_event("Wakeup", "Idk", "")
									"Pills":
										start_event("Drink", "Idk", "")
									"Mirror":
										start_event("Mirror", "Idk", "")
			else:
				class_holder.parent_script.can_look  = false




	
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
							sfx_click.play()
							cursor_state_current = "Arrow_l"
						"Arrow_r":
							cursor_node.play("Arrow_Right")
							sfx_click.play()
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
	},self)

#debugs mouse
func debug():
	while true:
		await get_tree().create_timer(1).timeout
		var temp_random = ["Default","Point","Grab","Arrow", "Arrow_l", "Arrow_r"].pick_random()
		print(temp_random)
		main_class.cursor_state = temp_random

func _process(delta: float) -> void:
	main_class.tick(delta, get_viewport().get_mouse_position(), self)
