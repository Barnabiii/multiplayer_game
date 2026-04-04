class_name PlayerIdleState extends State

var friction : float = 10.0

func Enter() -> void:
	animator.play("Idle")

func Physics_Update(_delta: float) -> void:
	if not puppet.is_multiplayer_authority():
		return
	puppet.velocity.x = lerp(puppet.velocity.x, 0.0, friction * _delta)
	puppet.velocity.z = lerp(puppet.velocity.z, 0.0, friction * _delta)
	if Input.is_action_pressed("up"):
		Transitioned.emit("PlayerRunState")
	if Input.is_action_just_pressed("space"):
		Transitioned.emit("PlayerJumpState")
