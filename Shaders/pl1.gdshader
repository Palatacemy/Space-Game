shader_type canvas_item;
uniform float influence: hint_range(0.0, 1.0, 0.1) = 0.5;
vec3 hsv2rgb(vec3 _c){
	vec4 _K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 _p = abs(fract(_c.xxx + _K.xyz) * 6.0 - _K.www);
	return _c.z * mix(_K.xxx, clamp(_p - _K.xxx, 0.0, 1.0), _c.y);
}
void fragment() {
	vec2 pos = vec2(0.5) - UV;
	COLOR.rgb += influence * hsv2rgb(vec3(atan(pos.y +0.0, pos.x), length(pos) * 3.0, 1.0));
}