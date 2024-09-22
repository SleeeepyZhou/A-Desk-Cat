extends MarginContainer

func _on_setting_pressed():
	visible = true
	$Panel/Box/Setting.visible = true
	$"../InfBack".visible = true

func _on_help_pressed():
	visible = true
	$Panel/Box/Help.visible = true
	$"../InfBack".visible = true

func _on_inf_back_pressed():
	visible = false
	$Panel/Box/Setting.visible = false
	$Panel/Box/Help.visible = false
	$"../InfBack".visible = false

func _on_ai_toggled(toggled_on):
	$Panel/Box/Setting/Setting/API.visible = toggled_on

func _on_save_pressed():
	API.save($Panel/Box/Setting/Setting/API/Url/Url.text, $Panel/Box/Setting/Setting/API/Key/Key.text)

func _on_help_text_meta_clicked(meta):
	OS.shell_open(meta)
