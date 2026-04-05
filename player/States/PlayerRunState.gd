class_name PlayerRunState extends State

var speed: float = 4
var rotation_speed: float = 10.
var acceleration: float = 5.

func get_next_state(input: InputPackage) -> String:
	if not input.input_direction:
		return "Idle"
	if input.is_jumping:
		return "Jump"
	if not Puppet.is_on_floor():
		return "Fall"
	return "self"


func enter() -> void:
	Animator.play("Sprint")


func physics_update(input: InputPackage, delta: float) -> void:	
	if not Puppet.is_multiplayer_authority():
		return

	var CamBasis: Basis = Puppet.get_node("CamPivot").global_transform.basis
	var direction: Vector3 = (CamBasis.z * input.input_direction.y + CamBasis.x * input.input_direction.x).normalized()

	Puppet.velocity.x = lerp(Puppet.velocity.x, direction.x * speed, acceleration * delta)
	Puppet.velocity.z = lerp(Puppet.velocity.z, direction.z * speed, acceleration * delta)
		
	var target_rotation: float = atan2(direction.x,direction.z)
	Puppet.get_node("Mesh").rotation.y = lerp_angle(Puppet.get_node("Mesh").rotation.y, target_rotation, rotation_speed * delta)
