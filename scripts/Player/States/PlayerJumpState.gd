class_name PlayerJumpState extends State

var AirSpeed: float = 3

func Enter() -> void:
	puppet.velocity.y = 5.
	animator.play("Jump_Start")

func Physics_Update(_delta: float) -> void:
	if not puppet.is_multiplayer_authority():
		return
	if puppet.is_on_floor():
		Transitioned.emit("PlayerIdleState")
	
	if Input.is_action_pressed("up"):
		var move_direction: Vector3 = puppet.transform.basis * Vector3(0,0,-AirSpeed) 
		puppet.velocity.x = move_direction.x
		puppet.velocity.z = move_direction.z
