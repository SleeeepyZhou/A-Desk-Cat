extends HBoxContainer

var ok : bool = false
var time : String:
	set(t):
		time = t
		$Time.text = t.get_slice("T", 1)
var inf : Dictionary:
	set(a):
		inf = a
		$Main/Name.text = a["foodName"]
		$Main/Mass/Mass.value = a["foodNutrition"]["mass"]
		$carbohydrate/carbohydrate.value = a["foodNutrition"]["carbohydrate"]
		$carbohydrate/per.value = a["foodNutrition"]["carbohydrate"]
		$protein/protein.value = a["foodNutrition"]["protein"]
		$protein/per.value = a["foodNutrition"]["protein"]
		$fat/fat.value = a["foodNutrition"]["fat"]
		$fat/per.value = a["foodNutrition"]["fat"]
		$carbohydrate/mass.value = $carbohydrate/per.value / 100 * $Main/Mass/Mass.value
		$protein/mass.value = $protein/per.value / 100 * $Main/Mass/Mass.value
		$fat/mass.value = $fat/per.value / 100 * $Main/Mass/Mass.value
		ok = true

func _on_del_pressed():
	queue_free()

func _on_name_text_changed(new_text):
	if ok:
		inf["foodName"] = new_text

func _on_mass_value_changed(value):
	if ok:
		inf["foodNutrition"]["mass"] = value

func _on_carbohydrate_value_changed(value):
	if ok:
		$carbohydrate/carbohydrate.value = value
		$carbohydrate/mass.value = value / 100 * $Main/Mass/Mass.value
		inf["foodNutrition"]["carbohydrate"] = value

func _on_protein_value_changed(value):
	if ok:
		$protein/protein.value = value
		$protein/mass.value = value / 100 * $Main/Mass/Mass.value
		inf["foodNutrition"]["protein"] = value

func _on_fat_value_changed(value):
	if ok:
		$fat/fat.value = value
		$fat/mass.value = value / 100 * $Main/Mass/Mass.value
		inf["foodNutrition"]["fat"] = value
