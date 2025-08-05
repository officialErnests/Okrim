shader_type canvas_item;

uniform sampler2D test_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 texture_col = texture(test_texture, UV * vec2(sin(TIME)/4.0+2.0, 1.0) + vec2(sin(TIME*PI/2.0)/2.0-0.75, cos(TIME*PI/2.0)/10.0)/2.0);
	//COLOR = vec4(round(UV.x),0.0,0.0,1.0);
	COLOR = texture_col - vec4(0.0,0.0,0.0,clamp(pow(abs(UV.x-0.5)*2.0,10.0) + pow(abs(UV.y-0.5)*2.0,10.0) + (sin(TIME * 10.0+ UV.y*500.0)/2.0+0.5),0.0,1.0));
	//COLOR = vec4(1.0, 0.0, 0.0, 1.0-);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
