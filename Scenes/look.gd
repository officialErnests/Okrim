extends Camera3D

@onready var light = $"../PlayerUtil/PointLight"
@onready var tp_indicator = $"../PlayerUtil/Tp"
@onready var spot_light =$SpotLight3D
var selected_material = preload("res://Scenes/Shaders/selected.tres")
var speed = 500
const RAY_LENGTH = 1000
var mouseDebounce = true
var animation_switch = "End"
var last_selection : Area3D
var last_selected = false
func _process(delta: float) -> void:
	var normilized_mouse = Vector2(0.5,0.5) - (get_viewport().get_mouse_position() / Vector2(get_viewport().get_visible_rect().size))
	if normilized_mouse.x > 0:
		normilized_mouse.x = normilized_mouse.x - 0.1 
		if normilized_mouse.x < 0: normilized_mouse.x = 0
	else:
		normilized_mouse.x = normilized_mouse.x + 0.1
		if normilized_mouse.x > 0: normilized_mouse.x = 0
	rotation_degrees += Vector3(normilized_mouse.y * delta * speed,normilized_mouse.x * delta * speed,0)
	rotation_degrees.x += -rotation_degrees.x * delta * 5
	
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = project_ray_origin(mousepos)
	var end = origin + project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.hit_from_inside = false
	query.hit_back_faces = false
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)

	var ray_hit = false
	last_selected = false
	if animation_switch == "End" and not tp_indicator.get_node("AnimatedSprite3D").is_playing():
		animation_switch = "Start_End"
		position = tp_indicator.position + Vector3(0,2,0)
	if result:
		light.global_position += ((result.position * 0.8 + position *0.2) - light.global_position)*delta
		# light.global_position.y = 2
		spot_light.look_at(result.position)

		if not(animation_switch == "End" and tp_indicator.get_node("AnimatedSprite3D").is_playing()):
			if result.collider.is_in_group("Move_zone"):
				ray_hit = true
				tp_indicator.position = result.position
				tp_indicator.visible = true
				if not tp_indicator.get_node("AnimatedSprite3D").is_playing():
					if animation_switch == "Start":
						animation_switch = "Loop"
						tp_indicator.get_node("AnimatedSprite3D").play("Loop")
					else:
						animation_switch = "Start"
						tp_indicator.get_node("AnimatedSprite3D").play("Start")
			if result.collider.is_in_group("Interactable"):
				last_selected = true
				if result.collider != last_selection:
					if last_selection:
						for selected_mesh_iter in last_selection.get_parent().get_child(0).get_children():
							selected_mesh_iter.material_overlay = null
					last_selection = result.collider
					for selected_mesh_iter in last_selection.get_parent().get_child(0).get_children():
						selected_mesh_iter.material_overlay = selected_material
	if not last_selected and last_selection:
		for selected_mesh_iter in last_selection.get_parent().get_child(0).get_children():
			selected_mesh_iter.material_overlay = null
		last_selection = null
	if not ray_hit:
		if not (animation_switch == "Start_end" or animation_switch == "End"):
			animation_switch  = "Start_end"
			tp_indicator.get_node("AnimatedSprite3D").play("Start_end")
		if not tp_indicator.get_node("AnimatedSprite3D").is_playing():
			tp_indicator.visible = false

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouseDebounce:
		mouseDebounce = false
		if result and animation_switch == "Loop":
			animation_switch = "End"
			tp_indicator.get_node("AnimatedSprite3D").play("End")
	else:
		mouseDebounce = true
