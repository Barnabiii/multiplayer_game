extends State
class_name Land

const TRANSITION_TIME = 0.15

func enter() -> void:
	animation = "_moves/landing"
	
func get_next_state(input: InputPackage) -> String:
	var collider: CollisionShape3D = Puppet.get_node("Collider")
	collider.shape.height = lerp(collider.shape.height, 1.6, 0.4) 
	collider.position.y = lerp(collider.position.y, 0.8, 0.4)

	if works_longer_than(TRANSITION_TIME):
		input.actions.sort_custom(moves_priority_sort)
		return input.actions[0]
	return "none"
