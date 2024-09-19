extends AnimatedSprite2D

@export var initial_state := "sit"

var current_state = null

func _ready():
	current_state = get_node(initial_state)
	current_state.on_enter()

func _process(delta):
	if current_state:
		await current_state.update(delta)
		check_state_transitions()

func check_state_transitions():
	for state in get_children():
		if state != current_state:
			if state.enter_condition():
				if current_state.exit_condition():
					$"..".nextstate = state.name
					await current_state.on_exit()
					current_state = state
					current_state.on_enter()
					break
