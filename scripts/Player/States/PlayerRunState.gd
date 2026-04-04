class_name PlayerRunState extends State

var RunSpeed: float = 4

func Enter() -> void:
	animator.play("Sprint")

func Physics_Update(_delta: float) -> void:	
	if not puppet.is_multiplayer_authority():
		return
	var move_direction: Vector3 = puppet.transform.basis * Vector3(0,0,-RunSpeed) 
	puppet.velocity.x = move_direction.x
	puppet.velocity.z = move_direction.z
	if Input.is_action_just_released("up"):
		Transitioned.emit("PlayerIdleState")
	if Input.is_action_just_pressed("space"):
		Transitioned.emit("PlayerJumpState")
