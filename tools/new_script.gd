@tool
extends Node

var animation: Animation
@export var animation_path: String:
	set(path):
		animation = ResourceLoader.load(path,"Animation")
		animation_path = path
@export var track: int:
	set(value):
		track = clampi(value,0,animation.get_track_count())
@export var init_key: int:
	set(value):
		init_key = clampi(value,0,min(animation.track_get_key_count(track), end_key))
		
@export var end_key: int:
	set(value):
		end_key = clampi(value,max(0,init_key),animation.track_get_key_count(track))

@export var offset: Vector3

@export_tool_button("offset")
var offset_button: Callable = edit_track


func edit_track() -> void:
	print("edit animation")
	#var path: NodePath = NodePath("%GeneralSkeleton:Hips")
	#print(animation.find_track(path,1)) = 0
	for key in range(init_key, end_key):
		var key_value: Vector3 = animation.track_get_key_value(track, key)
		animation.track_set_key_value(track, key, key_value + offset)
	ResourceSaver.save(animation,animation_path)
