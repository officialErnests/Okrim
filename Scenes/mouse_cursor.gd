extends Node3D

var mouse_pos_last = Vector2(0,0)
var cursor_pos = Vector2(320, 180)
var last_vec = Vector2(0,0)
var vec_mul = 1

func _process(delta: float) -> void:
    if get_viewport().get_mouse_position() == mouse_pos_last:
        var in1 = Input.get_axis("ui_left", "ui_right")
        var in2 = Input.get_axis("ui_up", "ui_down")
        if (in1 > 0 and last_vec.x > 0) or (in1 < 0 and last_vec.x < 0) or (in2 > 0 and last_vec.y > 0) or (in2 < 0 and last_vec.y < 0):
            vec_mul += delta
        else:
            vec_mul = 1
        last_vec = Vector2(in1, in2)
        cursor_pos += Vector2 (in1, in2) * delta * 200 * vec_mul
        cursor_pos.x = clamp(cursor_pos.x, 0, 640)
        cursor_pos.y = clamp(cursor_pos.y, 0, 360)
    else:
        cursor_pos = get_viewport().get_mouse_position()
    mouse_pos_last = get_viewport().get_mouse_position()