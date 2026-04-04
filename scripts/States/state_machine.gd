class_name StateMachine extends Node

@export var initial_state: State
@export var puppet: CharacterBody3D
@export var animation_player: AnimationPlayer

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var current_state: State
var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.puppet = puppet
			child.animator = animation_player
			child.Transitioned.connect(on_state_transition)

	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta: float) -> void:
	current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if not puppet.is_multiplayer_authority():
		return
	
	if not puppet.is_on_floor():
		puppet.velocity.y -= gravity * delta
		print(puppet.velocity.y)
	
	if Input.is_action_just_pressed("quit"):
		$"../.."._exit_game(puppet.name.to_int())
		puppet.get_tree().quit()
	
	if current_state:
		current_state.Physics_Update(delta)
	
	puppet.move_and_slide()

func on_state_transition(new_state_name: String) -> void:
	if not puppet.is_multiplayer_authority():
		return
	var new_state: State = states[new_state_name.to_lower()]
	if !new_state:
		return
	if current_state:
		current_state.Exit()
	new_state.Enter()
	
	current_state = new_state
