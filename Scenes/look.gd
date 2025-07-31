extends Camera3D

@onready var light = $OmniLight3D
@onready var spot_light =$SpotLight3D
var speed = 500
const RAY_LENGTH = 1000
var mouseDebounce = true
func _process(delta: float) -> void:
	var normilized_mouse = Vector2(0.5,0.5) - (get_viewport().get_mouse_position() / Vector2(get_viewport().get_visible_rect().size))
	if normilized_mouse.x > 0:
		normilized_mouse.x = normilized_mouse.x - 0.1
		if normilized_mouse.x < 0: normilized_mouse.x = 0
	else:
		normilized_mouse.x = normilized_mouse.x + 0.1
		if normilized_mouse.x > 0: normilized_mouse.x = 0
	rotation_degrees += Vector3(normilized_mouse.y * delta * speed,normilized_mouse.x * delta * speed,0)
	rotation_degrees.x += -rotation_degrees.x * delta * 10
	
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = project_ray_origin(mousepos)
	var end = origin + project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	print(origin,end)

	var result = space_state.intersect_ray(query)

	if result:
		light.global_position += (result.position - light.global_position)*delta
		light.global_position.y = 2
		spot_light.look_at(result.position)

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if mouseDebounce:
			mouseDebounce = false
			if result and result.position.y < 1:
				position = result.position * Vector3(1,0,1) + Vector3(0,2,0)
	else:
		mouseDebounce = true
