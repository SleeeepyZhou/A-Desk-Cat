extends Node

var player = null
func _ready():
	player = get_parent().get_parent()

func enter_condition() -> bool:
	return player.speed.length() > 450

func update(delta: float) -> void:
	player.win.position += Vector2i(player.speed * delta)
	$"..".animation = player.dir + name

func exit_condition() -> bool:
	return player.speed.length() < 450

func on_enter() -> void:
	player.smulhun = 2
	$"..".play(player.dir + name)

func on_exit() -> void:
	pass
