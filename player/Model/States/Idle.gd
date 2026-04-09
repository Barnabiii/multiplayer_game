extends State
class_name Idle

func get_next_state(input: InputPackage) -> String:
	if not Puppet.is_on_floor():
		return "MidAir"
	input.actions.sort_custom(moves_priority_sort)
	return input.actions[0]


func enter() -> void:
	Puppet.velocity.y  = 0
	animation = "moves/idle"


func update(_input: InputPackage,delta: float) -> void:
	if not Puppet.is_multiplayer_authority():
		return
	
	Puppet.velocity.x = lerp(Puppet.velocity.x, 0.0, Settings.friction * delta)
	Puppet.velocity.z = lerp(Puppet.velocity.z, 0.0, Settings.friction * delta)
