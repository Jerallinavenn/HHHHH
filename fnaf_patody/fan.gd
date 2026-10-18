func create_mask_from_texture(texture: Texture2D) -> Image:
	# Получаем данные из текстуры
	var image = texture.get_image()
	var width = image.get_width()
	var height = image.get_height()

	# Создаём новое изображение для маски
	var mask_image = Image.create(width, height, false, Image.FORMAT_RGBA8)

	for x in range(width):
		for y in range(height):
			# Получаем значение альфа-канала
			var alpha = image.get_pixel(x, y).a

			# Если альфа > 0, пиксель непрозрачный (белый), иначе прозрачный (чёрный)
			var color = Color(1, 1, 1, 1) if alpha > 0 else Color(0, 0, 0, 1)
			mask_image.set_pixel(x, y, color)

	return mask_image
