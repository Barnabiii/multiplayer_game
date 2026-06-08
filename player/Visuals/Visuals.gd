extends Node3D
class_name PlayerVisuals 

func accept_skeleton(skeleton: Skeleton3D) -> void:
	for child in get_children():
		if child is MeshInstance3D:
			child.skeleton = skeleton.get_path()
