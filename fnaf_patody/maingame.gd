extends Node2D

@onready var office_display: SubViewportContainer = $OfficeLayer/OfficeDisplay
@onready var office_viewport: SubViewport = $OfficeLayer/OfficeDisplay/OfficeViewport
@onready var camera: Camera2D = $OfficeLayer/OfficeDisplay/OfficeViewport/Camera2D

# === ОДИН СЛОЙ ОФИСА ===
@onready var office_sprite: Sprite2D = $OfficeLayer/OfficeDisplay/OfficeViewport/Camera2D/OfficeSprite
@onready var office_mask: Sprite2D = $OfficeLayer/OfficeDisplay/OfficeViewport/Camera2D/OfficeMask
# =======================

@onready var left_light: Sprite2D = $OfficeLayer/OfficeDisplay/OfficeViewport/Camera2D/Lights/LeftLight
@onready var right_light: Sprite2D = $OfficeLayer/OfficeDisplay/OfficeViewport/Camera2D/Lights/RightLight

@onready var left_light_button: Area2D = $OfficeLayer/OfficeDisplay/OfficeViewport/Camera2D/Buttons/LeftLightButton
@onready var right_light_button: Area2D = $OfficeLayer/OfficeDisplay/OfficeViewport/Camera2D/Buttons/RightLightButton
@onready var left_light_button_sprite: Sprite2D = $OfficeLayer/OfficeDisplay/OfficeViewport/Camera2D/Buttons/LeftLightButton/Sprite2D
@onready var right_light_button_sprite: Sprite2D = $OfficeLayer/OfficeDisplay/OfficeViewport/Camera2D/Buttons/RightLightButton/Sprite2D

@onready var left_door_button: Area2D = $OfficeLayer/OfficeDisplay/OfficeViewport/Camera2D/Buttons/LeftDoorButton
@onready var right_door_button: Area2D = $OfficeLayer/OfficeDisplay/OfficeViewport/Camera2D/Buttons/RightDoorButton
@onready var left_door_button_sprite: Sprite2D = $OfficeLayer/OfficeDisplay/OfficeViewport/Camera2D/Buttons/LeftDoorButton/Sprite2D
@onready var right_door_button_sprite: Sprite2D = $OfficeLayer/OfficeDisplay/OfficeViewport/Camera2D/Buttons/RightDoorButton/Sprite2D

@onready var fan_sprite: Sprite2D = $OfficeLayer/OfficeDisplay/OfficeViewport/Camera2D/FanSprite
@onready var fan_audio: AudioStreamPlayer = $OfficeLayer/OfficeDisplay/OfficeViewport/Camera2D/FanAudio
@onready var cassette_player_sprite: Sprite2D = $OfficeLayer/OfficeDisplay/OfficeViewport/Camera2D/CassettePlayerSprite
@onready var cassette_audio: AudioStreamPlayer = $OfficeLayer/OfficeDisplay/OfficeViewport/Camera2D/CassetteAudio

@onready var ui_root: Control = $UI/UIRoot
@onready var time_label: Label = $UI/UIRoot/TimeLabel
@onready var power_label: Label = $UI/UIRoot/PowerLabel
@onready var power_texture: TextureRect = $UI/UIRoot/PowerTexture
@onready var end_screen: Control = $UI/UIRoot/EndScreen
@onready var lose_screen: Control = $UI/UIRoot/LoseScreen

const OFFICE_WIDTH: float = 2560
const SCREEN_WIDTH: float = 1920
const SCREEN_HEIGHT: float = 1080

const LEFT_LIGHT_SIZE: Vector2 = Vector2(814, 1080)
const RIGHT_LIGHT_SIZE: Vector2 = Vector2(804, 1080)

# === НАСТРОЙКИ КАМЕРЫ ===
var camera_speed: float = 1000.0
var current_offset: float = -640.0
var min_offset: float = -960.0
var max_offset: float = -320.0
# =======================

# === ОРИГИНАЛЬНЫЕ ПОЗИЦИИ ОБЪЕКТОВ ===
const LEFT_LIGHT_POSITION: Vector2 = Vector2((-OFFICE_WIDTH / 2) + (LEFT_LIGHT_SIZE.x / 2), 0)
const RIGHT_LIGHT_POSITION: Vector2 = Vector2((OFFICE_WIDTH / 2) - (RIGHT_LIGHT_SIZE.x / 2) - 100, 0)
const FAN_POSITION: Vector2 = Vector2(370, 168)
const CASSETTE_PLAYER_POSITION: Vector2 = Vector2(-270, 242)
# =====================================

# === НАСТРОЙКИ ПЛЮШЕВОЙ ИГРУШКИ ===
const PLUSHIE_LIGHT_TEXTURE = preload("res://plushie_light.png")
const PLUSHIE_DARK_TEXTURE = preload("res://plushie_dark.png")
const PLUSHIE_SOUND = preload("res://funny_sound.mp3")

const PLUSHIE_POSITION = Vector2(500, 200)
const NOSE_OFFSET = Vector2(-22, -16.5)
const NOSE_RADIUS = 6.0

var plushie_sprite: Sprite2D
var plushie_audio: AudioStreamPlayer
# =================================

# === НАСТРОЙКИ ДВЕРЕЙ ===
const LEFT_DOOR_TEXTURE = preload("res://door_left.png")
const RIGHT_DOOR_TEXTURE = preload("res://door_right.png")

const DOOR_WIDTH: float = 314.0
const DOOR_HEIGHT: float = 1002.0
const DOOR_ANIMATION_TIME: float = 0.4
const DOOR_SEGMENTS: int = 24
const DOOR_BOTTOM_STRETCH: float = 100.0

const LEFT_DOOR_CENTER_X: float = 317.0
const RIGHT_DOOR_CENTER_X: float = 2243.0

const LEFT_DOOR_TOP_HEIGHT: float = 996.0
const RIGHT_DOOR_TOP_HEIGHT: float = 875.0

const LEFT_DOOR_SKEW_AMOUNT: float = 121.0

var left_door_mesh: MeshInstance2D
var right_door_mesh: MeshInstance2D
var left_door_progress: float = 0.0
var right_door_progress: float = 0.0
# =================================

# === НАСТРОЙКИ ВКЛАДКИ КАМЕР ===
const CAM_TAB_NORMAL_TEXTURE = preload("res://cam_tab_1.png")
const CAM_TAB_HOVER_TEXTURE = preload("res://cam_tab_2.png")
const CAM_TAB_BOTTOM_OFFSET: float = 0.0

var cam_tab_rect: TextureRect
var cam_tab_pos: Vector2
var cam_tab_size: Vector2
var is_cam_tab_hovered: bool = false
var is_cam_tab_flipped: bool = false
# ================================

# === НАСТРОЙКИ МОНИТОРА ===
const MONITOR_TEXTURE = preload("res://monitor.png")  # Замени на свой файл (1920x1600)
const MONITOR_ANIM_TIME: float = 1.0  # Время подъёма/опускания монитора в секундах

var monitor_blackout: ColorRect
var monitor_rect: TextureRect
var monitor_start_y: float = 0.0  # Стартовая позиция спрайта (нижняя грань внизу экрана)
var is_monitor_active: bool = false   # Экран монитора включён (чёрный фон + спрайт)
var is_monitor_open: bool = false     # Целевое состояние: открыт или закрыт
var monitor_progress: float = 0.0     # 0.0 = внизу/чёрный, 1.0 = наверху/нормальный
var is_office_fadein: bool = false    # Офис сейчас высветляется из чёрного
var office_fadein_progress: float = 0.0
# ============================

# === НАСТРОЙКИ ВЕНТИЛЯТОРА ===
const FAN_FRAME_DURATION: float = 0.1
const FAN_SOUND_VOLUME: float = -15.0

const FAN_LIGHT_FRAMES = [
	preload("res://Vent1.png"),
	preload("res://Vent2.png"),
	preload("res://Vent3.png")
]

const FAN_DARK_FRAMES = [
	preload("res://Vent1dark.png"),
	preload("res://Vent2dark.png"),
	preload("res://Vent3dark.png"),
	preload("res://Vent4dark.png")
]

const FAN_SOUND = preload("res://fan_sound.ogg")

var current_fan_frame: int = 0
var fan_frame_timer: float = 0.0
var fan_rotation_cycles: int = 0
var fan_stopped: bool = false
# =================================

# === НАСТРОЙКИ КАССЕТОПРОИГРЫВАТЕЛЯ ===
const CASSETTE_LIGHT_TEXTURE = preload("res://cassette_player_light.png")
const CASSETTE_HIGHLIGHTED_TEXTURE = preload("res://cassette_player_highlighted.png")
const CASSETTE_DARK_TEXTURE = preload("res://cassette_player_dark.png")

const CASSETTE_SOUND = preload("res://cassette_music.mp3")

var is_cassette_hovered: bool = false
var is_cassette_used: bool = false
var cassette_image: Image
# =================================

# === НАСТРОЙКИ ШРИФТА ===
const CUSTOM_FONT = preload("res://font.ttf")
const FONT_SIZE_TIME: int = 48
const FONT_SIZE_POWER: int = 36
# =================================

# === ТЕКСТУРЫ ОФИСА ===
const OFFICE_LIGHT_TEXTURE = preload("res://office_light.png")
const OFFICE_DARK_TEXTURE = preload("res://office_dark.png")
# =================================

# === НАСТРОЙКИ КОЛИЗИЙ КНОПОК ===
const BUTTON_OFFSET_LEFT_X: float = 0.0
const BUTTON_OFFSET_RIGHT_X: float = 0.0
const BUTTON_OFFSET_LIGHT_Y: float = 27.0
const BUTTON_OFFSET_DOOR_Y: float = 60.0
# =================================

var is_left_light_on: bool = false
var is_right_light_on: bool = false
var is_left_door_open: bool = false
var is_right_door_open: bool = false

const LEFT_LIGHT_ON_TEXTURE = preload("res://left_button_pressed_light.png")
const LEFT_LIGHT_OFF_TEXTURE = preload("res://left_button_light.png")
const RIGHT_LIGHT_ON_TEXTURE = preload("res://right_button_pressed_light.png")
const RIGHT_LIGHT_OFF_TEXTURE = preload("res://right_button_light.png")

const LEFT_DOOR_ON_TEXTURE = preload("res://left_button_pressed_light.png")
const LEFT_DOOR_OFF_TEXTURE = preload("res://left_button_light.png")
const RIGHT_DOOR_ON_TEXTURE = preload("res://right_button_pressed_light.png")
const RIGHT_DOOR_OFF_TEXTURE = preload("res://right_button_light.png")

const LEFT_LIGHT_ON_DARK_TEXTURE = preload("res://left_button_pressed_dark.png")
const LEFT_LIGHT_OFF_DARK_TEXTURE = preload("res://left_button_dark.png")
const RIGHT_LIGHT_ON_DARK_TEXTURE = preload("res://right_button_pressed_dark.png")
const RIGHT_LIGHT_OFF_DARK_TEXTURE = preload("res://right_button_dark.png")

const LEFT_DOOR_ON_DARK_TEXTURE = preload("res://left_button_pressed_dark.png")
const LEFT_DOOR_OFF_DARK_TEXTURE = preload("res://left_button_dark.png")
const RIGHT_DOOR_ON_DARK_TEXTURE = preload("res://right_button_pressed_dark.png")
const RIGHT_DOOR_OFF_DARK_TEXTURE = preload("res://right_button_dark.png")

const POWER_SPRITE_1 = preload("res://Zaryad_1.png")
const POWER_SPRITE_2 = preload("res://Zaryad_2.png")
const POWER_SPRITE_3 = preload("res://Zaryad_3.png")
const POWER_SPRITE_4 = preload("res://Zaryad_4.png")

var hour_durations: Array = [90.0, 89.0, 89.0, 89.0, 89.0, 89.0]
var hour_texts: Array = ["12 PM", "1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM"]
var current_hour_index: int = 0
var time_elapsed_in_hour: float = 0.0

var current_power: float = 100.0
var power_usage_level: int = 1
var is_power_out: bool = false
var power_out_timer: float = 0.0
var power_out_delay: float = 0.0

var is_game_finished: bool = false

var current_camera_speed: float = 0.0
var target_camera_speed: float = 0.0
var camera_smoothing: float = 5.0

func _ready():
	# === ЧЁРНЫЙ ФОН ===
	var bg_image = Image.create(1, 1, false, Image.FORMAT_RGBA8)
	bg_image.fill(Color(0, 0, 0, 1))
	var bg_texture = ImageTexture.create_from_image(bg_image)
	
	var background_sprite_new = Sprite2D.new()
	background_sprite_new.texture = bg_texture
	background_sprite_new.centered = true
	background_sprite_new.position = Vector2(0, 0)
	background_sprite_new.scale = Vector2(5000, 3000)
	background_sprite_new.z_index = -10
	camera.add_child(background_sprite_new)
	# ==================

	office_display.set_deferred("size", Vector2(1920, 1080))

	# Офис
	if office_sprite:
		office_sprite.texture = OFFICE_LIGHT_TEXTURE
		office_sprite.centered = true
		office_sprite.position = Vector2(0, 0)
		office_sprite.z_index = 5
	else:
		push_error("OfficeSprite not found!")

	create_office_mask()
	apply_shader_to_lights()

	# Свет
	left_light.position = LEFT_LIGHT_POSITION
	right_light.position = RIGHT_LIGHT_POSITION
	left_light.z_index = 1
	right_light.z_index = 1
	
	# Вентилятор и кассетница
	fan_sprite.position = FAN_POSITION
	fan_sprite.z_index = 10
	
	fan_audio.stream = FAN_SOUND
	fan_audio.stream.loop = true
	fan_audio.volume_db = FAN_SOUND_VOLUME
	fan_audio.play()
	
	update_fan_texture()
	
	cassette_player_sprite.position = CASSETTE_PLAYER_POSITION
	cassette_player_sprite.z_index = 10
	cassette_audio.stream = CASSETTE_SOUND
	cassette_audio.stream.loop = false
	
	cassette_image = CASSETTE_LIGHT_TEXTURE.get_image()
	update_cassette_texture()

	# Плюшевая игрушка
	plushie_sprite = Sprite2D.new()
	plushie_sprite.texture = PLUSHIE_LIGHT_TEXTURE
	plushie_sprite.centered = true
	plushie_sprite.position = PLUSHIE_POSITION
	plushie_sprite.z_index = 10
	camera.add_child(plushie_sprite)

	plushie_audio = AudioStreamPlayer.new()
	plushie_audio.stream = PLUSHIE_SOUND
	camera.add_child(plushie_audio)

	# === СОЗДАНИЕ ДВЕРЕЙ ===
	left_door_mesh = create_door_mesh(LEFT_DOOR_TEXTURE)
	camera.add_child(left_door_mesh)
	
	right_door_mesh = create_door_mesh(RIGHT_DOOR_TEXTURE)
	camera.add_child(right_door_mesh)
	# ========================

	# === СОЗДАНИЕ МОНИТОРА ===
	monitor_blackout = ColorRect.new()
	monitor_blackout.color = Color(0, 0, 0, 1)
	monitor_blackout.position = Vector2(0, 0)
	monitor_blackout.size = Vector2(SCREEN_WIDTH, SCREEN_HEIGHT)
	monitor_blackout.mouse_filter = Control.MOUSE_FILTER_IGNORE
	monitor_blackout.visible = false
	office_display.get_parent().add_child(monitor_blackout)
	
	monitor_rect = TextureRect.new()
	monitor_rect.texture = MONITOR_TEXTURE
	monitor_rect.size = MONITOR_TEXTURE.get_size()
	monitor_start_y = SCREEN_HEIGHT - MONITOR_TEXTURE.get_height()
	monitor_rect.position = Vector2(0, monitor_start_y)
	monitor_rect.modulate = Color(0, 0, 0, 1)
	monitor_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	monitor_rect.visible = false
	office_display.get_parent().add_child(monitor_rect)
	# =========================

	# Кнопки
	left_light_button.z_index = 10
	right_light_button.z_index = 10
	left_door_button.z_index = 10
	right_door_button.z_index = 10

	update_button_textures()
	update_door_button_textures()

	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

	setup_ui()
	
	# === СОЗДАНИЕ ВКЛАДКИ КАМЕР ===
	cam_tab_rect = TextureRect.new()
	cam_tab_rect.texture = CAM_TAB_NORMAL_TEXTURE
	cam_tab_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_root.add_child(cam_tab_rect)
	
	cam_tab_size = CAM_TAB_NORMAL_TEXTURE.get_size()
	cam_tab_pos = Vector2(
		SCREEN_WIDTH / 2.0 - cam_tab_size.x / 2.0,
		SCREEN_HEIGHT - cam_tab_size.y - CAM_TAB_BOTTOM_OFFSET
	)
	cam_tab_rect.position = cam_tab_pos
	cam_tab_rect.size = cam_tab_size
	# ==============================
	
	update_time_display()
	update_power_texture()
	update_power_label()
	calculate_power_usage()

func _process(delta):
	if is_game_finished:
		return

	fan_frame_timer += delta
	
	if is_power_out:
		if not fan_stopped:
			if fan_frame_timer >= FAN_FRAME_DURATION:
				fan_frame_timer = 0.0
				current_fan_frame += 1
				
				if current_fan_frame >= FAN_DARK_FRAMES.size():
					current_fan_frame = 0
					fan_rotation_cycles += 1
				
				if fan_rotation_cycles >= 2:
					fan_stopped = true
					current_fan_frame = 0
					
			update_fan_texture()
	else:
		if fan_frame_timer >= FAN_FRAME_DURATION:
			fan_frame_timer = 0.0
			current_fan_frame = (current_fan_frame + 1) % FAN_LIGHT_FRAMES.size()
		update_fan_texture()
	
	if not is_cassette_used and not is_power_out and not is_monitor_active:
		var local_mouse = camera.get_local_mouse_position()
		var cassette_pos = cassette_player_sprite.position
		var cassette_texture = cassette_player_sprite.texture
		
		var was_hovered = is_cassette_hovered
		is_cassette_hovered = false
		
		if cassette_texture and cassette_image:
			var cassette_size = cassette_texture.get_size()
			var cassette_rect = Rect2(cassette_pos - cassette_size / 2.0, cassette_size)
			
			if cassette_rect.has_point(local_mouse):
				var pixel_x = int(local_mouse.x - cassette_rect.position.x)
				var pixel_y = int(local_mouse.y - cassette_rect.position.y)
				
				if pixel_x >= 0 and pixel_x < cassette_size.x and pixel_y >= 0 and pixel_y < cassette_size.y:
					var pixel_color = cassette_image.get_pixel(pixel_x, pixel_y)
					
					if pixel_color.a > 0.1:
						is_cassette_hovered = true
		
		if was_hovered != is_cassette_hovered:
			update_cassette_texture()

	# === ВКЛАДКА КАМЕР: переключение при наведении ===
	var mouse_ui = get_viewport().get_mouse_position()
	var tab_hovered = Rect2(cam_tab_pos, cam_tab_size).has_point(mouse_ui)
	
	# Монитор занят, пока едет или пока офис высветляется — вкладка не работает
	var monitor_busy = (is_monitor_active and monitor_progress < 1.0) or is_office_fadein
	
	if not is_power_out and tab_hovered and not is_cam_tab_hovered and not monitor_busy:
		is_cam_tab_flipped = not is_cam_tab_flipped
		if is_cam_tab_flipped:
			cam_tab_rect.texture = CAM_TAB_HOVER_TEXTURE
		else:
			cam_tab_rect.texture = CAM_TAB_NORMAL_TEXTURE
		
		if is_cam_tab_flipped:
			is_monitor_active = true
			is_monitor_open = true
			# При открытии монитора свет в коридорах гаснет на 100%
			turn_off_lights()
		else:
			is_monitor_open = false
			# Свет после закрытия монитора НЕ включается сам —
			# только по нажатию кнопки (состояние кнопок сохранено)
	
	is_cam_tab_hovered = tab_hovered
	# ================================================

	# === МОНИТОР: анимация подъёма/опускания (ускорена в 4 раза) ===
	if is_monitor_active:
		if is_monitor_open:
			monitor_progress = min(1.0, monitor_progress + delta / (MONITOR_ANIM_TIME * 0.25))
		else:
			monitor_progress = max(0.0, monitor_progress - delta / (MONITOR_ANIM_TIME * 0.25))
			if monitor_progress <= 0.0:
				is_monitor_active = false
				is_office_fadein = true
				office_fadein_progress = 0.0
		update_monitor_visuals()
	
	# === Высветление офиса из чёрного (без изменений, 0.5 сек) ===
	if is_office_fadein:
		office_fadein_progress = min(1.0, office_fadein_progress + delta / (MONITOR_ANIM_TIME * 0.5))
		update_office_fadein()
		if office_fadein_progress >= 1.0:
			is_office_fadein = false
			monitor_blackout.visible = false
			monitor_blackout.color = Color(0, 0, 0, 1)
	# ============================================

	# Обновление анимации дверей
	update_doors(delta)

	var mouse_pos = get_viewport().get_mouse_position()
	var screen_width = get_viewport_rect().size.x
	
	target_camera_speed = 0.0
	
	# Камера офиса не двигается, пока мы за монитором или офис высветляется
	if not is_monitor_active:
		if mouse_pos.x < 500:
			if mouse_pos.x < 250:
				target_camera_speed = camera_speed
			else:
				target_camera_speed = camera_speed * 0.5
		elif mouse_pos.x > screen_width - 500:
			if mouse_pos.x > screen_width - 250:
				target_camera_speed = -camera_speed
			else:
				target_camera_speed = -camera_speed * 0.5
	
	current_camera_speed = lerp(current_camera_speed, target_camera_speed, delta * camera_smoothing)
	
	current_offset += current_camera_speed * delta
	current_offset = clamp(current_offset, min_offset, max_offset)
	camera.position.x = current_offset

	time_elapsed_in_hour += delta
	
	if time_elapsed_in_hour >= hour_durations[current_hour_index]:
		time_elapsed_in_hour = 0.0
		current_hour_index += 1
		
		update_time_display()
		
		if current_hour_index >= 6:
			trigger_win()
			return

	if not is_power_out:
		var hour_duration = hour_durations[current_hour_index]
		var drain_per_second = (9.0 * power_usage_level) / hour_duration
		current_power -= drain_per_second * delta
		
		if current_power <= 0:
			current_power = 0
			trigger_power_out()
		
		update_power_label()
	else:
		power_out_timer += delta
		if power_out_timer >= power_out_delay:
			trigger_lose()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
		elif event.keycode == KEY_F1:
			current_power = 0
			trigger_power_out()
		elif event.keycode == KEY_F2:
			current_hour_index = 5
			time_elapsed_in_hour = hour_durations[5] - 3.0
			update_time_display()
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Клики по офису не работают, пока мы за монитором или офис высветляется
		if not is_monitor_active:
			handle_plushie_click()
			handle_cassette_click()
			handle_button_clicks()

# === МОНИТОР ===
func update_monitor_visuals():
	monitor_blackout.visible = is_monitor_active
	monitor_blackout.color = Color(0, 0, 0, 1)
	monitor_rect.visible = is_monitor_active
	
	if is_monitor_active:
		var t = monitor_progress
		# Открытие: с -520 до 0. Закрытие: с 0 до -520 (точно в обратную сторону)
		var p = lerp(monitor_start_y, 0.0, t)
		monitor_rect.position = Vector2(0.0, p)
		
		# Осветление/затемнение от чёрного до нормального
		var b = clamp(t, 0.0, 1.0)
		monitor_rect.modulate = Color(b, b, b, 1.0)

func update_office_fadein():
	monitor_blackout.visible = true
	var a = 1.0 - clamp(office_fadein_progress, 0.0, 1.0)
	monitor_blackout.color = Color(0, 0, 0, a)
# ===============

# === ПЛЮШЕВАЯ ИГРУШКА ===
func handle_plushie_click():
	if is_power_out or is_game_finished:
		return
	
	var local_mouse = camera.get_local_mouse_position()
	var nose_pos = plushie_sprite.position + NOSE_OFFSET
	
	if local_mouse.distance_to(nose_pos) < NOSE_RADIUS:
		plushie_audio.play()

func update_plushie_texture():
	if is_power_out:
		plushie_sprite.texture = PLUSHIE_DARK_TEXTURE
	else:
		plushie_sprite.texture = PLUSHIE_LIGHT_TEXTURE
# =============================

# === ДВЕРИ ===
func create_door_mesh(texture: Texture2D) -> MeshInstance2D:
	var mi = MeshInstance2D.new()
	mi.texture = texture
	mi.z_index = 3
	return mi

func update_doors(delta: float):
	if is_left_door_open and left_door_progress < 1.0:
		left_door_progress = min(1.0, left_door_progress + delta / DOOR_ANIMATION_TIME)
	elif not is_left_door_open and left_door_progress > 0.0:
		left_door_progress = max(0.0, left_door_progress - delta / DOOR_ANIMATION_TIME)
	
	animate_door(left_door_mesh, -OFFICE_WIDTH / 2.0 + LEFT_DOOR_CENTER_X, true, left_door_progress)
	
	if is_right_door_open and right_door_progress < 1.0:
		right_door_progress = min(1.0, right_door_progress + delta / DOOR_ANIMATION_TIME)
	elif not is_right_door_open and right_door_progress > 0.0:
		right_door_progress = max(0.0, right_door_progress - delta / DOOR_ANIMATION_TIME)
	
	animate_door(right_door_mesh, -OFFICE_WIDTH / 2.0 + RIGHT_DOOR_CENTER_X, false, right_door_progress)

func animate_door(mi: MeshInstance2D, center_x: float, is_left: bool, progress: float):
	var half_width = DOOR_WIDTH / 2.0
	var door_h = DOOR_HEIGHT
	var skew_amount = 121.0
	var lift = 3.0

	var p0_bl_y: float
	var p0_br_y: float
	var p1_bl_y: float
	var p1_br_y: float

	if is_left:
		p0_bl_y = -456.0 - lift
		p0_br_y = -335.0 - lift
		p1_bl_y = 661.0 - lift
		p1_br_y = 540.0 - lift
	else:
		p0_bl_y = -335.0 - lift
		p0_br_y = -456.0 - lift
		p1_bl_y = 540.0 - lift
		p1_br_y = 661.0 - lift

	var p0_tl_y = p0_bl_y - door_h
	var p0_tr_y = p0_br_y - door_h

	var p1_tl_y: float
	var p1_tr_y: float

	if is_left:
		p1_tl_y = (p1_bl_y - door_h) - skew_amount
		p1_tr_y = p1_br_y - door_h
	else:
		p1_tl_y = p1_bl_y - door_h
		p1_tr_y = (p1_br_y - door_h) - skew_amount

	p1_bl_y += DOOR_BOTTOM_STRETCH
	p1_br_y += DOOR_BOTTOM_STRETCH

	var top_left = Vector2(center_x - half_width, lerp(p0_tl_y, p1_tl_y, progress))
	var top_right = Vector2(center_x + half_width, lerp(p0_tr_y, p1_tr_y, progress))
	var bottom_left = Vector2(center_x - half_width, lerp(p0_bl_y, p1_bl_y, progress))
	var bottom_right = Vector2(center_x + half_width, lerp(p0_br_y, p1_br_y, progress))

	var vertices = PackedVector2Array()
	var uvs = PackedVector2Array()
	var indices = PackedInt32Array()

	for i in range(DOOR_SEGMENTS + 1):
		var t = float(i) / DOOR_SEGMENTS
		var left_pt = top_left.lerp(bottom_left, t)
		var right_pt = top_right.lerp(bottom_right, t)
		vertices.append(left_pt)
		vertices.append(right_pt)
		uvs.append(Vector2(0, t))
		uvs.append(Vector2(1, t))

	for i in range(DOOR_SEGMENTS):
		var a = i * 2
		var b = i * 2 + 1
		var c = i * 2 + 3
		var d = i * 2 + 2
		indices.append_array([a, b, c, a, c, d])

	var mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = indices
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mi.mesh = mesh
# =============================

func handle_button_clicks():
	if is_power_out or is_game_finished:
		return
	
	var viewport_mouse_pos = office_viewport.get_mouse_position()
	
	check_button_click(viewport_mouse_pos, left_light_button, left_light_button_sprite, "LeftLightButton", true)
	check_button_click(viewport_mouse_pos, right_light_button, right_light_button_sprite, "RightLightButton", true)
	check_button_click(viewport_mouse_pos, left_door_button, left_door_button_sprite, "LeftDoorButton", false)
	check_button_click(viewport_mouse_pos, right_door_button, right_door_button_sprite, "RightDoorButton", false)

func handle_cassette_click():
	if is_power_out or is_game_finished:
		return
	
	if is_cassette_used:
		return
	
	var local_mouse = camera.get_local_mouse_position()
	var cassette_pos = cassette_player_sprite.position
	var cassette_texture = cassette_player_sprite.texture
	
	if cassette_texture and cassette_image:
		var cassette_size = cassette_texture.get_size()
		var cassette_rect = Rect2(cassette_pos - cassette_size / 2.0, cassette_size)
		
		if cassette_rect.has_point(local_mouse):
			var pixel_x = int(local_mouse.x - cassette_rect.position.x)
			var pixel_y = int(local_mouse.y - cassette_rect.position.y)
			
			if pixel_x >= 0 and pixel_x < cassette_size.x and pixel_y >= 0 and pixel_y < cassette_size.y:
				var pixel_color = cassette_image.get_pixel(pixel_x, pixel_y)
				
				if pixel_color.a > 0.1:
					is_cassette_used = true
					is_cassette_hovered = false
					cassette_audio.play()
					update_cassette_texture()

func check_button_click(_mouse_pos: Vector2, _button: Area2D, button_sprite: Sprite2D, button_name: String, is_light: bool):
	if button_sprite.texture == null:
		return
	
	var local_mouse = camera.get_local_mouse_position()
	var local_button_pos = _button.position
	
	var offset_x = BUTTON_OFFSET_LEFT_X if button_name.begins_with("Left") else BUTTON_OFFSET_RIGHT_X
	var offset_y = BUTTON_OFFSET_LIGHT_Y if is_light else BUTTON_OFFSET_DOOR_Y
	
	var corrected_pos = local_button_pos + Vector2(offset_x, offset_y)
	var size = button_sprite.texture.get_size()
	
	var top_left = corrected_pos - size / 2.0
	var rect = Rect2(top_left, size)
	
	if rect.has_point(local_mouse):
		if is_light:
			on_light_button_pressed(button_name)
		else:
			on_door_button_pressed(button_name)

func setup_ui():
	ui_root.position = Vector2(0, 0)
	ui_root.set_deferred("size", Vector2(1920, 1080))
	ui_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	time_label.position = Vector2(1750, 20)
	time_label.set_deferred("size", Vector2(200, 50))
	
	if CUSTOM_FONT:
		time_label.add_theme_font_override("font", CUSTOM_FONT)
		time_label.add_theme_font_size_override("font_size", FONT_SIZE_TIME)
	time_label.add_theme_color_override("font_color", Color.WHITE)
	time_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	power_label.position = Vector2(35, 880)
	power_label.set_deferred("size", Vector2(200, 50))
	
	if CUSTOM_FONT:
		power_label.add_theme_font_override("font", CUSTOM_FONT)
		power_label.add_theme_font_size_override("font_size", FONT_SIZE_POWER)
	power_label.add_theme_color_override("font_color", Color.WHITE)
	power_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	power_texture.position = Vector2(20, 940)
	power_texture.set_deferred("size", Vector2(200, 100))
	power_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	end_screen.position = Vector2(0, 0)
	end_screen.set_deferred("size", Vector2(1920, 1080))
	end_screen.visible = false
	end_screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	lose_screen.position = Vector2(0, 0)
	lose_screen.set_deferred("size", Vector2(1920, 1080))
	lose_screen.visible = false
	lose_screen.mouse_filter = Control.MOUSE_FILTER_IGNORE

func create_office_mask():
	if not office_mask or not office_sprite:
		return
	
	var office_texture = office_sprite.texture
	if office_texture == null:
		return
	
	var image = office_texture.get_image()
	var width = image.get_width()
	var height = image.get_height()

	var mask_image = Image.create(width, height, false, Image.FORMAT_RGBA8)

	for x in range(width):
		for y in range(height):
			var alpha = image.get_pixel(x, y).a
			var color = Color(1, 1, 1, 1) if alpha > 0 else Color(0, 0, 0, 1)
			mask_image.set_pixel(x, y, color)

	var mask_texture = ImageTexture.create_from_image(mask_image)
	office_mask.texture = mask_texture
	office_mask.visible = false

func apply_shader_to_lights():
	if not office_mask:
		return
	
	if not left_light.material:
		left_light.material = ShaderMaterial.new()
	if not right_light.material:
		right_light.material = ShaderMaterial.new()

	var mask_texture = office_mask.texture
	left_light.material.set_shader_parameter("mask_texture", mask_texture)
	right_light.material.set_shader_parameter("mask_texture", mask_texture)

func update_button_textures():
	if is_power_out:
		left_light_button_sprite.texture = LEFT_LIGHT_OFF_DARK_TEXTURE
		right_light_button_sprite.texture = RIGHT_LIGHT_OFF_DARK_TEXTURE
		left_door_button_sprite.texture = LEFT_DOOR_OFF_DARK_TEXTURE
		right_door_button_sprite.texture = RIGHT_DOOR_OFF_DARK_TEXTURE
	else:
		left_light_button_sprite.texture = LEFT_LIGHT_ON_TEXTURE if is_left_light_on else LEFT_LIGHT_OFF_TEXTURE
		right_light_button_sprite.texture = RIGHT_LIGHT_ON_TEXTURE if is_right_light_on else RIGHT_LIGHT_OFF_TEXTURE
		left_door_button_sprite.texture = LEFT_DOOR_ON_TEXTURE if is_left_door_open else LEFT_DOOR_OFF_TEXTURE
		right_door_button_sprite.texture = RIGHT_DOOR_ON_TEXTURE if is_right_door_open else RIGHT_DOOR_OFF_TEXTURE

func update_door_button_textures():
	update_button_textures()

func on_light_button_pressed(button_name: String):
	if is_power_out:
		return
	
	match button_name:
		"LeftLightButton":
			is_left_light_on = not is_left_light_on
			left_light.visible = is_left_light_on
			if is_right_light_on:
				is_right_light_on = false
				right_light.visible = false
		"RightLightButton":
			is_right_light_on = not is_right_light_on
			right_light.visible = is_right_light_on
			if is_left_light_on:
				is_left_light_on = false
				left_light.visible = false

	update_button_textures()
	calculate_power_usage()
	update_power_texture()

func on_door_button_pressed(button_name: String):
	if is_power_out:
		return
	
	match button_name:
		"LeftDoorButton":
			is_left_door_open = not is_left_door_open
		"RightDoorButton":
			is_right_door_open = not is_right_door_open

	update_button_textures()
	calculate_power_usage()
	update_power_texture()

func calculate_power_usage():
	power_usage_level = 1
	if is_left_light_on: power_usage_level += 1
	if is_right_light_on: power_usage_level += 1
	if is_left_door_open: power_usage_level += 1
	if is_right_door_open: power_usage_level += 1
	# Открытый монитор потребляет +1 уровень энергии (как в FNAF)
	if is_monitor_active: power_usage_level += 1

func turn_off_lights():
	# Полностью гасит свет в коридорах (вызывается при открытии монитора).
	# Состояние кнопок сохраняется — после закрытия монитора свет остаётся
	# выключенным и включается только повторным нажатием кнопки.
	if not (is_left_light_on or is_right_light_on):
		return
	is_left_light_on = false
	is_right_light_on = false
	left_light.visible = false
	right_light.visible = false
	update_button_textures()
	calculate_power_usage()
	update_power_texture()

func update_time_display():
	time_label.text = hour_texts[current_hour_index]

func update_power_texture():
	match power_usage_level:
		1:
			power_texture.texture = POWER_SPRITE_1
		2:
			power_texture.texture = POWER_SPRITE_2
		3:
			power_texture.texture = POWER_SPRITE_3
		_:
			power_texture.texture = POWER_SPRITE_4  # 5+ (монитор + двери + свет) — максимальная планка

func update_power_label():
	power_label.text = str(int(current_power)) + "%"

func update_fan_texture():
	if is_power_out and fan_stopped:
		fan_sprite.texture = FAN_DARK_FRAMES[0]
	elif is_power_out:
		fan_sprite.texture = FAN_DARK_FRAMES[current_fan_frame]
	else:
		fan_sprite.texture = FAN_LIGHT_FRAMES[current_fan_frame]

func update_cassette_texture():
	if is_power_out:
		cassette_player_sprite.texture = CASSETTE_DARK_TEXTURE
	elif is_cassette_used:
		cassette_player_sprite.texture = CASSETTE_LIGHT_TEXTURE
	elif is_cassette_hovered:
		cassette_player_sprite.texture = CASSETTE_HIGHLIGHTED_TEXTURE
	else:
		cassette_player_sprite.texture = CASSETTE_LIGHT_TEXTURE

func reset_fan():
	fan_stopped = false
	fan_rotation_cycles = 0
	current_fan_frame = 0
	fan_frame_timer = 0.0
	update_fan_texture()

func trigger_power_out():
	is_power_out = true
	
	is_left_light_on = false
	is_right_light_on = false
	is_left_door_open = false
	is_right_door_open = false
	
	left_light.visible = false
	right_light.visible = false
	
	if office_sprite:
		office_sprite.texture = OFFICE_DARK_TEXTURE
	
	# === Если мы за монитором — монитор просто выключается ===
	if is_monitor_active:
		is_monitor_active = false
		is_monitor_open = false
		monitor_progress = 0.0
		update_monitor_visuals()
	is_office_fadein = false
	monitor_blackout.visible = false
	monitor_blackout.color = Color(0, 0, 0, 1)
	is_cam_tab_flipped = false
	cam_tab_rect.texture = CAM_TAB_NORMAL_TEXTURE
	cam_tab_rect.visible = false  # Вкладка пропадает вместе со светом
	# ==========================================================
	
	update_button_textures()
	update_cassette_texture()
	update_plushie_texture()
	
	cassette_audio.stop()
	fan_audio.stop()
	
	time_label.visible = false
	power_label.visible = false
	power_texture.visible = false
	
	power_out_delay = randf_range(5.0, 20.0)
	power_out_timer = 0.0

func trigger_win():
	is_game_finished = true
	ui_root.visible = true
	end_screen.visible = true

func trigger_lose():
	is_game_finished = true
	ui_root.visible = true
	lose_screen.visible = true
