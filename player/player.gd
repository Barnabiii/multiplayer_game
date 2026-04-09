extends CharacterBody3D

@onready var input_gatherer: InputGatherer = $Input
@onready var model: PlayerModel = $Model
@onready var visuals: PlayerVisuals = $Visuals

const SENSITIVITY = 0.0015

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
func _ready() -> void:
	$CamPivot/SpringArm3D/Camera3D.current = is_multiplayer_authority()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	visuals.accept_skeleton(model.skeleton)

	var animation_path : NodePath = ^"Model/AnimationPlayer:current_animation"
	var config : SceneReplicationConfig = $MultiplayerSynchronizer.replication_config
	if config.has_property(animation_path):
		return
	config.add_property(animation_path)
	$MultiplayerSynchronizer.replication_config = config
	
func _physics_process(delta: float) -> void:
	var input: InputPackage = input_gatherer.gather_input()
	model.physics_update(input,delta)
	move_and_slide()
	
	if input.is_quitting:
		get_parent()._exit_game(name.to_int())
		get_tree().quit()

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
	if event is InputEventMouseMotion:
		var CamPivot: Node3D = $CamPivot
		var spring: SpringArm3D = CamPivot.get_child(0)

		CamPivot.rotate_y(-event.relative.x * SENSITIVITY)
		spring.rotate_object_local(Vector3.LEFT,event.relative.y * SENSITIVITY)
		spring.rotation.x = clamp(spring.rotation.x, -PI/2.5, PI/4.1)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if is_multiplayer_authority():
			$".."._exit_game(name.to_int())
			get_tree().quit()
