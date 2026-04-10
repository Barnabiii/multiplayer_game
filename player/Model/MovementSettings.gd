class_name LocomotionSettings extends Resource

@export_group("Grounded")
@export var speed : float = 4.0
@export var acceleration : float = 5.0
@export var friction : float = 15.0
@export var rotation_speed : float = 10.0

@export_group("Air")
@export var jump_velocity: float = 6.5
@export var air_acceleration : float = 2.0
@export var air_rotation_speed : float = 5.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
