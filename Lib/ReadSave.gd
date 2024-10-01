extends Window

var SAVE : String = (OS.get_executable_path().get_base_dir() + "/data.save").simplify_path()
func _ready():
	close_requested.connect(hide)

func _on_read_save_pressed():
	visible = true

var data : Dictionary = {}
var days : Array = []
var day_time : Dictionary = {}
func _on_day_pressed():
	if FileAccess.file_exists(SAVE):
		data = FileAccess.open(SAVE, FileAccess.READ).get_var()
		days = []
		day_time = {}
		for time in data.keys():
			var i = time.get_slice("T", 0)
			if days.has(i):
				day_time[i].append(time)
			else:
				days.append(i)
				day_time[i] = [time]
		update_day()

func update_day():
	$Box/Box/ButtonBox/Day.clear()
	$Box/Box/ButtonBox/Day.add_item("Press")
	$Box/Box/ButtonBox/Day.set_item_disabled(0, true)
	for day in days:
		$Box/Box/ButtonBox/Day.add_item(day)

const FOOD_UNIT = preload("res://Lib/food_unit.tscn")
func _on_load_pressed():
	if data.is_empty():
		return
	var timedata : Array = day_time[$Box/Box/ButtonBox/Day.text]
	for time in timedata:
		var new_unit = FOOD_UNIT.instantiate()
		new_unit.time = time
		new_unit.inf = data[time]
		$Box/Box/Food/FoodBox.add_child(new_unit)

func _on_save_pressed():
	if data.is_empty():
		return
	for child in $Box/Box/Food/FoodBox.get_children():
		data[child.time] = child.inf
		var dir = FileAccess.open(SAVE, FileAccess.WRITE)
		dir.store_var(data)
		dir.close()
	update_day()

const zero_inf = {"foodName":"","foodNutrition":{"carbohydrate":0,"enerage":0,"fat":0,"mass":0,"protein":0},"isFood":true}
func _on_add_pressed():
	var new_unit = FOOD_UNIT.instantiate()
	new_unit.time = Time.get_datetime_string_from_system()
	new_unit.inf = zero_inf
	data[new_unit.time] = new_unit.inf
	$Box/Box/Food/FoodBox.add_child(new_unit)
