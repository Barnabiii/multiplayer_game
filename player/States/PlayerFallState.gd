class_name PlayerFallState extends State

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func get_next_state(_input: InputPackage) -> String:
	if Puppet.is_on_floor():
		return "Idle"
	return "self"


func enter() -> void:
	Animator.play("Jump")


func physics_update(_input: InputPackage, delta: float) -> void:
	Puppet.velocity.y -= gravity * delta
