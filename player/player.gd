extends CharacterBody3D

@export var input_gatherer: InputGatherer
@export var state_machine: LocomotionStateMachine

const SENSITIVITY = 0.0015

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
func _ready() -> void:
	$CamPivot/SpringArm3D/Camera3D.current = is_multiplayer_authority()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
	if event is InputEventMouseMotion:
		var CamPivot: Node3D = $CamPivot
		var spring: SpringArm3D = CamPivot.get_child(0)
		CamPivot.rotate_y(-event.relative.x * SENSITIVITY)
		spring.rotate_object_local(Vector3.LEFT,event.relative.y * SENSITIVITY)
		spring.rotation.x = clamp(spring.rotation.x, -PI/2.5, PI/4.1)

func _physics_process(delta: float) -> void:
	var input: InputPackage = input_gatherer.gather_input()
	state_machine.physics_update(input,delta)
	move_and_slide()
	
	if input.is_quitting:
		$".."._exit_game(name.to_int())
		get_tree().quit()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if is_multiplayer_authority():
			$".."._exit_game(name.to_int())
			get_tree().quit()
