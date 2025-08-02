shader_type spatial;

uniform sampler2D sampled_texture;
void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX = VERTEX + vec3(0,cos((VERTEX.y + VERTEX.z + VERTEX.x + TIME/40.0)*100.0)/100.0,0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 texture_procesed = texture(sampled_texture, UV+TIME/16.0);
	ALBEDO = vec3(1.0-texture_procesed.x,0.0,0.0);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
