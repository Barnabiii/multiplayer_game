class_name PlayerJumpState extends State

func get_next_state(input: InputPackage) -> String:
	if Puppet.is_on_floor():
		if input.input_direction != Vector2.ZERO:
			return "Run"
		return "Idle"
	if not Animator.is_playing():
		return "Fall"
	return "self"


func enter() -> void:
	Puppet.velocity.y = Settings.jump_velocity
	Animator.play("Jump_Start")


func update(input: InputPackage, delta: float) -> void:
	Puppet.velocity.y -= Settings.gravity * delta
	
	var CamBasis: Basis = Puppet.get_node("CamPivot").global_transform.basis
	var direction: Vector3 = (CamBasis.z * input.input_direction.y + CamBasis.x * input.input_direction.x).normalized()

	Puppet.velocity.x = lerp(Puppet.velocity.x, direction.x * Settings.speed, Settings.air_acceleration * delta)
	Puppet.velocity.z = lerp(Puppet.velocity.z, direction.z * Settings.speed, Settings.air_acceleration * delta)
	
	if not direction:
		return

	var target_rotation: float = atan2(direction.x,direction.z)
	Puppet.get_node("Mesh").rotation.y = lerp_angle(Puppet.get_node("Mesh").rotation.y, target_rotation, Settings.rotation_speed * delta)
