class_name LocomotionStateMachine extends Node

@export var initial_state: State
@export var puppet: CharacterBody3D
@export var animation_player: AnimationPlayer

@export var settings: LocomotionSettings

var current_state: State
var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Puppet = puppet
			child.Animator = animation_player
			child.Settings = settings

	if initial_state:
		initial_state.enter()
		current_state = initial_state

func physics_update(input: InputPackage, delta: float) -> void:
	if not puppet.is_multiplayer_authority():
		return
	
	var next_state: String = current_state.get_next_state(input)
	if next_state != "self":
		switch_to(next_state)
	
	if current_state:
		current_state.update(input, delta)

func switch_to(new_state_name: String) -> void:
	if not puppet.is_multiplayer_authority():
		return
	print(new_state_name)
	var new_state: State = states[new_state_name.to_lower()]
	if !new_state:
		return
	if current_state:
		current_state.exit()
	new_state.enter()
	
	current_state = new_state
