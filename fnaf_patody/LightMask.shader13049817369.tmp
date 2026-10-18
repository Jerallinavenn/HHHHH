shader_type canvas_item;

uniform sampler2D office_texture; // Текстура офиса
uniform sampler2D mask_texture;   // Текстура маски

void fragment() {
    // Получаем цвет пикселя из текстуры офиса
    vec4 office_color = texture(office_texture, FRAGCOORD.xy / SCREEN_PIXEL_SIZE);

    // Получаем цвет пикселя из маски
    vec4 mask_color = texture(mask_texture, FRAGCOORD.xy / SCREEN_PIXEL_SIZE);

    // Если маска чёрная (прозрачная), делаем свет невидимым
    if (mask_color.r < 0.5) {
        COLOR.a = 0.0; // Прозрачность
    } else {
        COLOR = vec4(1.0, 1.0, 1.0, 1.0); // Белый свет
    }
}