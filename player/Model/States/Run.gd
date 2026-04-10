extends State
class_name Run

var foot_ray : RayCast3D

func get_next_state(input: InputPackage) -> String:
	if not foot_ray.is_colliding():
		return "MidAir"
	input.actions.sort_custom(moves_priority_sort)
	return input.actions[0]
	#if not input.input_direction:
		#return "Idle"
	#if input.is_jumping:
		#return "Jump"


func enter() -> void:
	animation = "_moves/running"
	foot_ray = Puppet.get_node("foot_raycast")


func update(input: InputPackage, delta: float) -> void:	
	if not Puppet.is_multiplayer_authority():
		return

	var CamBasis: Basis = Puppet.get_node("CamPivot").global_transform.basis
	var direction: Vector3 = (CamBasis.z * input.input_direction.y + CamBasis.x * input.input_direction.x).normalized()

	Puppet.velocity.x = lerp(Puppet.velocity.x, direction.x * Settings.speed, Settings.acceleration * delta)
	Puppet.velocity.z = lerp(Puppet.velocity.z, direction.z * Settings.speed, Settings.acceleration * delta)
		
	var target_rotation: float = atan2(direction.x,direction.z)
	Puppet.get_node("Visuals").rotation.y = lerp_angle(Puppet.get_node("Visuals").rotation.y, target_rotation, Settings.rotation_speed * delta)
