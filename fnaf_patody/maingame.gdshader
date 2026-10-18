shader_type canvas_item;

uniform float strength : hint_range(0.0, 0.5) = 0.2;
uniform float safe_zone : hint_range(0.0, 1.0) = 0.25; // 25% экрана по краям без искажения

void fragment() {
    vec2 uv = UV;
    vec2 center = vec2(0.5, 0.5);
    vec2 delta = uv - center;
    
    // Расстояние от центра по X и Y
    float dist_x = abs(delta.x);
    float dist_y = abs(delta.y);
    
    // Вычисляем фактор искажения: в центре = 1, по краям = 0
    // safe_zone = 0.25 означает, что 25% экрана по краям не искажаются
    float falloff_x = smoothstep(0.5, 0.5 - safe_zone, dist_x);
    float falloff_y = smoothstep(0.5, 0.5 - safe_zone, dist_y);
    float falloff = min(falloff_x, falloff_y);
    
    // Применяем искажение только в центре
    float distortion_x = strength * dist_x * dist_x * falloff;
    float distortion_y = strength * 0.4 * dist_y * dist_y * falloff;
    
    uv.x = center.x + delta.x * (1.0 - distortion_x);
    uv.y = center.y + delta.y * (1.0 - distortion_y);
    
    uv = clamp(uv, 0.0, 1.0);
    COLOR = texture(TEXTURE, uv);
}