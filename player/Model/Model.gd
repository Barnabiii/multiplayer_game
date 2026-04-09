extends Node
class_name PlayerModel

@export var initial_state: State
@onready var puppet: CharacterBody3D = $".."
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var skeleton: Skeleton3D = $GeneralSkeleton

@export var settings: LocomotionSettings

var current_state: State
var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Puppet = puppet
			child.Settings = settings

	if initial_state:
		initial_state.enter()
		current_state = initial_state

func physics_update(input: InputPackage, delta: float) -> void:
	if not puppet.is_multiplayer_authority():
		return

	var next_state_name: String = current_state.get_next_state(input)
	if next_state_name != "none":
		switch_to(next_state_name)
	
	if current_state:
		current_state.update(input, delta)
	handheld_to_hand()

func switch_to(new_state_name: String) -> void:
	if not puppet.is_multiplayer_authority():
		return
	
	var new_state: State = states[new_state_name.to_lower()]
	if current_state == new_state:
		return
	
	current_state.exit()
	new_state.enter()
	new_state.mark_enter_time()
	animator.play(new_state.animation)

	current_state = new_state

func handheld_to_hand() -> void:
	var hand_id : int = skeleton.find_bone("RightHand")
	var hand_transform: Transform3D = skeleton.get_bone_global_pose(hand_id)
	var handheld : Node3D = puppet.get_node("Visuals").get_node("Handheld")
	handheld.transform = hand_transform
