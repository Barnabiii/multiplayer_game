extends State
class_name Land

const TRANSITION_TIME = 0.15

func enter() -> void:
	animation = "moves/landing"

func get_next_state(input: InputPackage) -> String:
	if works_longer_than(TRANSITION_TIME):
		input.actions.sort_custom(moves_priority_sort)
		return input.actions[0]
	return "none"
