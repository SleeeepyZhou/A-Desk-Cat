extends Node

var player = null
func _ready():
	player = get_parent().get_parent()

func enter_condition() -> bool:
	return player.speed.length() < 450 and (player.nextstate == "sit" or player.nextstate == "run")

func update(delta: float) -> void:
	player.win.position += Vector2i(player.speed * delta)
	$"..".animation = player.dir + name
	if !player.speed:
		$"..".frame = 0
	
func exit_condition() -> bool:
	return !(player.speed.length() < 450 and player.speed.length() > 0)
	
func on_enter() -> void:
	player.smulhun = 1
	$"..".animation = player.dir + name
	$"..".play()
	
func on_exit() -> void:
	pass

