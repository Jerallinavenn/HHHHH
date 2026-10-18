shader_type canvas_item;

uniform float strength : hint_range(0.0, 0.5) = 0.2;

void fragment() {
    vec2 uv = UV;
    vec2 center = vec2(0.5, 0.5);
    vec2 delta = uv - center;
    
    // Расстояние от центра по горизонтали (для боковых стен)
    float dist_x = abs(delta.x);
    
    // Расстояние от центра по вертикали (для потолка/пола)
    float dist_y = abs(delta.y);
    
    // Боковые стены "выгибаются" к зрителю (сжимаются к центру)
    float distortion_x = strength * dist_x * dist_x;
    float distortion_y = strength * 0.4 * dist_y * dist_y;
    
    // Применяем перспективу: центр (дальняя стена) остаётся, края (боковые) сжимаются
    uv.x = center.x + delta.x * (1.0 - distortion_x);
    uv.y = center.y + delta.y * (1.0 - distortion_y);
    
    // Обрезаем UV
    uv = clamp(uv, 0.0, 1.0);
    
    COLOR = texture(TEXTURE, uv);
}