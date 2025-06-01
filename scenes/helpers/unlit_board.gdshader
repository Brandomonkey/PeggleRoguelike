shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform vec2 light_center;
uniform float radius = 200.0;
uniform float softness = 80.0;

void fragment() {
    vec2 screen_pos = SCREEN_UV * vec2(textureSize(SCREEN_TEXTURE, 0));
    float dist = distance(screen_pos, light_center);
    float alpha = smoothstep(radius, radius + softness, dist);
    COLOR = vec4(0.0, 0.0, 0.0, alpha); // Transparent center, black edges
}