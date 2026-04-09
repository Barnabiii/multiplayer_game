extends Node3D
class_name PlayerVisuals 

@onready var beta_surface: MeshInstance3D = $Beta_Surface
@onready var beta_joints: MeshInstance3D = $Beta_Joints
@onready var ch_32: MeshInstance3D = $Ch32

func accept_skeleton(skeleton: Skeleton3D) -> void:
	for child in get_children():
		if child is MeshInstance3D:
			child.skeleton = skeleton.get_path()
