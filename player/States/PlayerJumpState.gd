class_name PlayerJumpState extends State

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var acceleration: float = 2.
var speed: float = 4.
var rotation_speed: float = 10.

func get_next_state(_input: InputPackage) -> String:
	if Puppet.is_on_floor():
		return "Idle"
	if not Animator.is_playing():
		return "Fall"
	return "self"


func enter() -> void:
	Puppet.velocity.y = 5.
	Animator.play("Jump_Start")


func physics_update(input: InputPackage, delta: float) -> void:
	Puppet.velocity.y -= gravity * delta
	
	var CamBasis: Basis = Puppet.get_node("CamPivot").global_transform.basis
	var direction: Vector3 = (CamBasis.z * input.input_direction.y + CamBasis.x * input.input_direction.x).normalized()

	Puppet.velocity.x = lerp(Puppet.velocity.x, direction.x * speed, acceleration * delta)
	Puppet.velocity.z = lerp(Puppet.velocity.z, direction.z * speed, acceleration * delta)
	
	if not direction:
		return
	var target_rotation: float = atan2(direction.x,direction.z)
	Puppet.get_node("Mesh").rotation.y = lerp_angle(Puppet.get_node("Mesh").rotation.y, target_rotation, rotation_speed * delta)
