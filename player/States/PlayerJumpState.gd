class_name PlayerJumpState extends State

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var air_speed: float = 3

func get_next_state(_input: InputPackage) -> String:
	if Puppet.is_on_floor():
		return "Idle"
	if not Animator.is_playing():
		return "Fall"
	return "self"


func enter() -> void:
	Puppet.velocity.y = 5.
	Animator.play("Jump_Start")


func physics_update(_input: InputPackage, delta: float) -> void:
	Puppet.velocity.y -= gravity * delta
