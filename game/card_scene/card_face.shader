shader_type spatial;
render_mode depth_draw_alpha_prepass;

uniform vec4 albedo : hint_color;
uniform sampler2D stencil;
uniform sampler2D center_scene;
uniform vec4 stencil_color : hint_color;

void fragment() {
	vec4 stencil_test = texture(stencil, SCREEN_UV);
	vec4 color_test = stencil_color;

	float stencil_id = stencil_test.r * 10.0 + stencil_test.g + 100.0 * stencil_test.b + 1000.0;
	float mask_id = stencil_color.r * 10.0 + stencil_color.g + 100.0 * stencil_color.b + 1000.0;

	float mask_result = abs(stencil_id - mask_id);

	if(mask_result == 0.0){
		ALPHA = 0.0; // 中间的部分透明
	}
	else{
		vec4 end_color = texture(center_scene, SCREEN_UV);
		ALPHA = end_color.a;
		ALBEDO = end_color.rgb;
		// ALPHA = 0.5;
		// ALBEDO = vec3(0.8,0.1,0.8);
	}
}