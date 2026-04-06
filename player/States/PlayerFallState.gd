class_name PlayerFallState extends State

func get_next_state(input: InputPackage) -> String:
	if Puppet.is_on_floor():
		if input.input_direction != Vector2.ZERO:
			return "Run"
		return "Idle"
	return "self"


func enter() -> void:
	Animator.play("Jump")


func update(_input: InputPackage, delta: float) -> void:
	Puppet.velocity.y -= Settings.gravity * delta
