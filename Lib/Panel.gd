extends Control

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

func _ready():
	get_viewport().files_dropped.connect(feed)
	SAVE = (OS.get_executable_path().get_base_dir() + "/data.save").simplify_path()

const IMAGE_TYPE = ["JPG", "PNG", "BMP", "GIF", "TIF", "TIFF", "JPEG", "WEBP"]
var SAVE : String
const prompt = "Please identify the items in the picture. If they are food, estimate their nutritional value."
const format = {"type": "json_schema",
				"json_schema": {"name": "Food_nutrition_estimation",
								"strict": true,
								"schema": {"type": "object",
											"properties": {"isFood": { "type": "boolean" },
															"foodName": { "type": "string" },
															"foodNutrition": {"type": "object",
																			"properties": {"enerage":{"type":"number"},
																							"mass":{"type":"number",
																									"description":"Estimated mass, in grams."},
																							"carbohydrate": { "type": "number"},
																							"protein": { "type": "number"},
																							"fat": { "type": "number"},
																							},
																			"required": ["enerage", "mass", "carbohydrate", "protein", "fat"],
																			"additionalProperties": false},
															},
											"required": ["isFood", "foodName", "foodNutrition"],
											"additionalProperties": false}
								}
				}

var last_food : String = "Unknown"
func feed(files):
	var path : String = files[0]
	if $InfBox/Panel/Box/Setting/Setting/AI.button_pressed:
		if IMAGE_TYPE.has(path.get_extension().to_upper()) and !API.read().is_empty():
			var image_path := path
			var temp_an = await API.run_VLMapi(prompt, 1, 50, image_path, 1, format)
			print(temp_an)
			var an = JSON.parse_string(temp_an)
			if an:
				if an["isFood"]:
					last_food = an["foodName"]
					$"..".hungry += an["foodNutrition"]["enerage"] / 10
					var time = Time.get_datetime_string_from_system()
					if FileAccess.file_exists(SAVE):
						var data = FileAccess.open(SAVE, FileAccess.READ).get_var()
						data[time] = an
						var dir = FileAccess.open(SAVE, FileAccess.WRITE)
						dir.store_var(data)
						dir.close()
					else:
						var dir = FileAccess.open(SAVE, FileAccess.WRITE)
						dir.store_var({time:an})
						dir.close()
				else:
					var lab = Label.new()
					lab.text = "This not food"
					lab.modulate = Color.RED
					lab.autowrap_mode = TextServer.AUTOWRAP_WORD
					lab.rotation_degrees = -90
					$"../Area/Box".add_child(lab)
					lab.position = Vector2(10, 60)
					var tween = get_tree().create_tween()
					tween.tween_property(lab, "position", Vector2(-30, 60), 5)
					tween.tween_callback(lab.queue_free)
			else:
				var lab = Label.new()
				lab.text = temp_an
				lab.modulate = Color.RED
				lab.autowrap_mode = TextServer.AUTOWRAP_WORD
				lab.rotation_degrees = -90
				$"../Area/Box".add_child(lab)
				lab.position = Vector2(10, 60)
				var tween = get_tree().create_tween()
				tween.tween_property(lab, "position", Vector2(-30, 60), 5)
				tween.tween_callback(lab.queue_free)
			
	else:
		var data = FileAccess.open(path, FileAccess.READ).get_length() / 100000
		last_food = "Unknown"
		$"..".hungry += data

'''
食物能量，估算碳蛋脂，饮食记录
健身计划，健康建议
手机移动信息(手机接口)，走路，能量消耗
肌肉猫，胖猫，瘦猫

实验1回复
{"foodName":"Dog kibble","foodNutrition":{"carbohydrate":50,"enerage":350,"fat":15,"mass":100,"protein":25},"isFood":true}

'''
const CHEESEBURGER = preload("res://Res/cheeseburger.ogg")
func _on_burger_pressed():
	var burger = AudioStreamPlayer.new()
	burger.stream = CHEESEBURGER
	burger.finished.connect(burger.queue_free)
	add_child(burger)
	$"..".hungry += 10
	last_food = "cheese burger"
	burger.play()
