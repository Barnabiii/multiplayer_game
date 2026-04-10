class_name InputGatherer extends Node

func gather_input() -> InputPackage:
	var new_input: InputPackage = InputPackage.new()
	
	new_input.is_quitting = Input.is_action_just_pressed("quit")
	
	if Input.is_action_just_pressed("space"):
		new_input.actions.append("Jump")

	new_input.input_direction = Input.get_vector("left", "right", "up", "down")
	if new_input.input_direction != Vector2.ZERO:
		new_input.actions.append("Run")
	
	if Input.is_action_just_pressed("emote1"):
		new_input.actions.append("Emote")
	
	if new_input.actions.is_empty():
		new_input.actions.append("Idle")
	
	return new_input
