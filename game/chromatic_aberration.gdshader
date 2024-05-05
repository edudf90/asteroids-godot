shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float offset = 0.002;

void fragment() {
	vec4 green_channel = texture(screen_texture, SCREEN_UV);
	vec2 red_coord = vec2(SCREEN_UV.x + offset, SCREEN_UV.y);
	vec2 blue_coord = vec2(SCREEN_UV.x - offset, SCREEN_UV.y);
	vec4 red_channel = texture(screen_texture, red_coord);
	vec4 blue_channel = texture(screen_texture, blue_coord);
	COLOR = vec4(red_channel.r, green_channel.g, blue_channel.b, 1.0);
}
