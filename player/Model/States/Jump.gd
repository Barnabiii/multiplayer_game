extends State
class_name Jump

const TRANSITION_TIME = 0.4
const JUMP_TIME = 0.1

var jumped: bool = false

func enter() -> void:
	animation = "_moves/jump_start"

func get_next_state(_input: InputPackage) -> String:
	if works_longer_than(TRANSITION_TIME):
		jumped = false
		return "MidAir"
	return "none"

func update(input: InputPackage, delta: float) -> void:
	if works_longer_than(JUMP_TIME):
		if not jumped:
			Puppet.velocity.y = Settings.jump_velocity
			jumped = true

	Puppet.velocity.y -= Settings.gravity * delta
	var CamBasis: Basis = Puppet.get_node("CamPivot").global_transform.basis
	var direction: Vector3 = (CamBasis.z * input.input_direction.y + CamBasis.x * input.input_direction.x).normalized()

	Puppet.velocity.x = lerp(Puppet.velocity.x, direction.x * Settings.speed, Settings.air_acceleration * delta)
	Puppet.velocity.z = lerp(Puppet.velocity.z, direction.z * Settings.speed, Settings.air_acceleration * delta)
	
	if not direction:
		return

	var target_rotation: float = atan2(direction.x,direction.z)
	Puppet.get_node("Visuals").rotation.y = lerp_angle(Puppet.get_node("Visuals").rotation.y, target_rotation, Settings.air_rotation_speed * delta)
