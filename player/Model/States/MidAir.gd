extends State
class_name MidAir 

var foot_ray : RayCast3D

func get_next_state(_input: InputPackage) -> String:
	if foot_ray.is_colliding():
		return "Land"
	return "none"


func enter() -> void:
	animation = "_moves/midair"
	foot_ray = Puppet.get_node("foot_raycast")

func update(input: InputPackage, delta: float) -> void:
	Puppet.velocity.y -= Settings.gravity * delta
	
	var CamBasis: Basis = Puppet.get_node("CamPivot").global_transform.basis
	var direction: Vector3 = (CamBasis.z * input.input_direction.y + CamBasis.x * input.input_direction.x).normalized()

	Puppet.velocity.x = lerp(Puppet.velocity.x, direction.x * Settings.speed, Settings.air_acceleration * delta)
	Puppet.velocity.z = lerp(Puppet.velocity.z, direction.z * Settings.speed, Settings.air_acceleration * delta)
	
	if not direction:
		return

	var target_rotation: float = atan2(direction.x,direction.z)
	Puppet.get_node("Visuals").rotation.y = lerp_angle(Puppet.get_node("Visuals").rotation.y, target_rotation, Settings.air_rotation_speed * delta)
