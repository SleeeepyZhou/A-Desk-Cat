extends Control

func _ready():
	get_viewport().files_dropped.connect(feed)

const IMAGE_TYPE = ["JPG", "PNG", "BMP", "GIF", "TIF", "TIFF", "JPEG", "WEBP"]
func feed(files):
	var path : String = files[0]
	if IMAGE_TYPE.has(path.get_extension().to_upper()):
		var single_path := path
		#var image = Image.load_from_file(path)
		#$SingleImage/UpOut/ImageUp/Label.visible = false
		#$SingleImage/UpOut/ImageUp.texture = ImageTexture.create_from_image(image)
		#if path.get_extension().to_upper() == "PNG":
			#var file = FileAccess.get_file_as_bytes(path)
			#print(file)

func _input(event):
	if event and event.is_action_pressed("ui_cancel"):
		_on_esc_pressed()

func _on_cat_mouse_entered():
	visible = true

func _on_cat_mouse_exited():
	await get_tree().create_timer(3).timeout
	visible = false

func _on_audio_toggled(toggled_on):
	AudioServer.set_bus_mute(0, toggled_on)

func _on_esc_pressed():
	get_tree().quit()

var fish = preload("res://Res/Fish.png")
func _on_fish_toggled(toggled_on):
	if toggled_on:
		Input.set_custom_mouse_cursor(fish)
	else:
		Input.set_custom_mouse_cursor(null)
