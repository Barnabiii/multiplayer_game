extends Node
class_name State

var Puppet: CharacterBody3D
var Animator: AnimationPlayer
var Settings: LocomotionSettings

func get_next_state(_input: InputPackage) -> String:
	return "self"

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_input: InputPackage, _delta: float) -> void:
	pass
