extends Node

var player = null
func _ready():
	player = get_parent().get_parent()

func enter_condition() -> bool:
	return player.waiting

const waitact = ["lay", "look"]
var maxtimes = 3
var acting := false
var acttimes : int = 0
func update(_delta: float) -> void:
	if player.waitlong and acttimes < maxtimes and !acting:
		acting = true
		acttimes += 1
		var act : int = randi()%2
		$"..".play(sitdir + waitact[act])
		await get_tree().create_timer(3).timeout
		player.waitlong = false
		if act == 0:
			$"..".play_backwards(sitdir + waitact[act])
			await $"..".animation_finished
		elif act == 1:
			await $"..".animation_looped
		$"..".animation = sitdir + name
		$"..".frame = 5
		acting = false
	elif acttimes >= maxtimes and !acting:
		acting = true
		$"..".play(sitdir + "lay")
	await beg()

func beg():
	if player.hungry:
		if ((randi()%1000) / 10.0) - player.hungryt > player.hungry:
			if $"..".animation.ends_with("lay"):
				$"..".play_backwards(sitdir + "lay")
				await $"..".animation_finished
			$"..".play("beg")
			await $"..".animation_finished
			sitdir = "frontleft"
			$"..".animation = sitdir + name
			$"..".frame = 5

func exit_condition() -> bool:
	return !player.waiting

var sitdir : String
func on_enter() -> void:
	player.smulhun = 0
	$"..".play(player.dir + name)
	acting = false
	acttimes = 0
	sitdir = player.dir

func on_exit() -> void:
	$"..".speed_scale = 4
	if $"..".animation.ends_with("look"):
		await $"..".animation_looped
	elif $"..".animation.ends_with("lay"):
		$"..".play_backwards(sitdir + "lay")
		await $"..".animation_finished
	$"..".play_backwards(sitdir + name)
	await $"..".animation_finished
	$"..".speed_scale = 2
