extends CharacterBody3D

const SENSITIVITY = 0.0015

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
func _ready() -> void:
	$camOrigin/SpringArm3D/Camera3D.current = is_multiplayer_authority()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSITIVITY)
		$camOrigin.rotate_x(-event.relative.y * SENSITIVITY)
		$camOrigin.rotation.x = clamp($camOrigin.rotation.x, -PI/2, PI/3)

func _notification(what):
	if not is_multiplayer_authority():
		return
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		$"../"._exit_game(name.to_int())
		get_tree().quit() # default behavior
