extends CharacterBody3D

@onready var input_gatherer: InputGatherer = $Input
@onready var model: PlayerModel = $Model
@onready var visuals: PlayerVisuals = $Visuals
@onready var camera_3d: Camera3D = $CamPivot/SpringArm3D/Camera3D
const BABYOIL = preload("uid://db3lmt1by2eii")
const BLOOD_PARTICLES = preload("uid://bcmqsnow2c6t4")


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
	
	
	if Input.is_action_just_pressed("click") and is_multiplayer_authority():
		var orientation: Vector3 = -camera_3d.get_global_transform().basis.z
		throw.rpc(orientation)

@rpc("any_peer", "call_local", "reliable", 0)
func throw(orientation :Vector3) -> void:
	var prop: RigidBody3D = BABYOIL.instantiate()
	prop.position = $CamPivot/SpringArm3D.global_position + orientation
	prop.apply_force(orientation * 1000.0)
	get_parent().add_child(prop)

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
	if event is InputEventMouseMotion:
		var CamPivot: Node3D = $CamPivot
		var spring: SpringArm3D = CamPivot.get_child(0)

		CamPivot.rotate_y(-event.relative.x * SENSITIVITY)
		spring.rotate_object_local(Vector3.LEFT,event.relative.y * SENSITIVITY)
		spring.rotation.x = clamp(spring.rotation.x, -PI/2.0, PI/2.3)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if is_multiplayer_authority():
			$".."._exit_game(name.to_int())
			get_tree().quit()

func _on_prop_entered(prop: Node3D) -> void:
	prop.queue_free()
	
	var blood: GPUParticles3D = BLOOD_PARTICLES.instantiate()
	blood.position.y = 1
	blood.restart()
	add_child(blood)
