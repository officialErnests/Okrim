shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX = VERTEX + vec3(cos(VERTEX.x + VERTEX.z + TIME*3.0)/10.0,cos(VERTEX.y + VERTEX.z + TIME*1.0)/10.0,sin(VERTEX.x + VERTEX.y + TIME*2.0)/10.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
