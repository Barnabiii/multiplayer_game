class_name PlayerIdleState extends State

var friction : float = 15.

func get_next_state(input: InputPackage) -> String:
	if input.input_direction.length() > 0.1:
		return "Run"
	if input.is_jumping:
		return "Jump"
	if not Puppet.is_on_floor():
		return "Fall"
	return "self"


func enter() -> void:
	Animator.play("Idle")


func physics_update(_input: InputPackage,delta: float) -> void:
	if not Puppet.is_multiplayer_authority():
		return

	Puppet.velocity.x = lerp(Puppet.velocity.x, 0.0, friction * delta)
	Puppet.velocity.z = lerp(Puppet.velocity.z, 0.0, friction * delta)
