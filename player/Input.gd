class_name InputGatherer extends Node

func gather_input() -> InputPackage:
	var new_input: InputPackage = InputPackage.new()

	new_input.is_jumping = Input.is_action_just_pressed("space")
	new_input.input_direction = Input.get_vector("left", "right", "up", "down")

	return new_input
