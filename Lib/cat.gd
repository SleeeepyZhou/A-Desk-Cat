extends CharacterBody2D

@export var max_waitact : int = 3:
	set(i):
		$Animated/sit.maxtimes = i
		max_waitact = i

@export var hungry : float = 100.0:
	set(f):
		hungry = clampf(f, 0.0, 100.0)
		$Panel/Box/Hunger.value = hungry
@export var hungryt : float = 60.0
@export var mulhunger = [0.1, 0.5, 1]
var smulhun : int = 0:
	set(i):
		smulhun = clampi(i, 0, 2)
func _on_hunger_timeout():
	hungry -= mulhunger[smulhun]

var state : String = "sit"
var nextstate : String = "sit":
	set(t):
		state = nextstate
		nextstate = t

const dir2anim = {
			Vector2(1,0)  :"right",
			Vector2(1,1)  :"frontright",
			Vector2(0,1)  :"front",
			Vector2(-1,1) :"frontleft",
			Vector2(-1,0) :"left", 
			Vector2(-1,-1):"backleft",
			Vector2(0,-1) :"back",
			Vector2(1,-1) :"backright",
				}
var direction : Vector2 = Vector2(0,1):
	set(d):
		if d == Vector2.ZERO:
			return
		direction = d
		dir = dir2anim[d]
var dir : String = "front"

var win : Window
func _ready():
	win = get_viewport().get_window()

var rate : int = 300
var is_run : bool = false:
	set(b):
		if $Panel/ShiftRun.button_pressed:
			is_run = true
		else:
			is_run = b
var speed : Vector2 = Vector2.ZERO
@export var pursue : float = 500
func _process(_delta):
	var tempdir : Vector2 = Vector2.ZERO
	if $Panel/ButtonBox/Keyboard.button_pressed:
		if Input.is_action_pressed("ui_select"):
			is_run = true
		else:
			is_run = false
		tempdir.x = Input.get_axis("ui_left", "ui_right")
		tempdir.y = Input.get_axis("ui_up", "ui_down")
	elif $Panel/ButtonBox/Fish.button_pressed:
		var road : Vector2 = DisplayServer.mouse_get_position() - win.position
		if road.length() > pursue:
			is_run = true
		else:
			is_run = false
		if road.length() > 262:
			tempdir.x = int(clamp(road.x, -1, 1))
			tempdir.y = int(clamp(road.y, -1, 1))
	speed = tempdir * rate
	if is_run:
		speed *= 2
	direction = tempdir
	if !speed and $Timer.is_stopped() and !waiting:
		$Timer.start(2)
	elif speed:
		waiting = false
		$Timer.stop()

var waiting : bool = false:
	set(b):
		if b:
			waiting = b
		else:
			waiting = b
			waitlong = b
var waitlong : bool = false

func _on_timer_timeout():
	if !waiting:
		waiting = true
		$Timer.start(2)
	else:
		waitlong = true
		$Timer.start(5)

const miao = [preload("res://Res/miao01.mp3"), preload("res://Res/miao02.mp3"), 
			preload("res://Res/miao03.mp3"), preload("res://Res/miao04.mp3"),
			preload("res://Res/miao05.mp3"),
			preload("res://Res/hulu.mp3"), preload("res://Res/pity.mp3"),]
var miaoing := false
@export var huhutime : float = 10.0
func _on_animation_changed():
	var anima : String = $Animated.animation
	if anima == "beg" and !miaoing:
		miaoing = true
		$Miao.stream = miao[6]
		$Miao.play()
		await $Miao.finished
	elif anima.begins_with("back") and anima.ends_with("lay") and !miaoing:
		$Miao.stream = miao[5]
		$Miao.play()
		await get_tree().create_timer(huhutime).timeout
		$Miao.stop()
	elif anima.ends_with("look") and !miaoing:
		$Miao.stop()
	elif nextstate == "walk" and anima.ends_with("walk") and !miaoing:
		miaoing = true
		$Miao.stream = miao[randi()%5]
		$Miao.play()
		await $Miao.finished

func _on_miao_finished():
	miaoing = false

