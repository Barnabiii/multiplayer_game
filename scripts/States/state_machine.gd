extends Node

@export var current_state: State

func init(parent: CharacterBody2D) -> void:
	for child in get_children():
		if child is State:
			child.parent = parent
