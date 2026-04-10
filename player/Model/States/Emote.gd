extends State
class_name Emote

var foot_ray : RayCast3D

func get_next_state(input: InputPackage) -> String:
	if not foot_ray:
		return "MidAir"
	input.actions.sort_custom(moves_priority_sort)
	return input.actions[0] if input.actions[0] != "Idle" else "none"


func enter() -> void:
	animation = "_moves/dance_chicken"
	Puppet.velocity.y  = 0
	foot_ray = Puppet.get_node("foot_raycast")


func update(_input: InputPackage,delta: float) -> void:
	if not Puppet.is_multiplayer_authority():
		return
	
	Puppet.velocity.x = lerp(Puppet.velocity.x, 0.0, Settings.friction * delta)
	Puppet.velocity.z = lerp(Puppet.velocity.z, 0.0, Settings.friction * delta)
