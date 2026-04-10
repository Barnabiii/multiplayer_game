extends Node
class_name State

var Puppet: CharacterBody3D
var Settings: LocomotionSettings

var animation: String
var enter_time: float

static var state_priority: Dictionary = {
	"Idle" : 1,
	"Emote" : 2,
	"Run" : 3,
	"Jump" : 10
}

static func moves_priority_sort(a: String, b: String) -> bool:
	if state_priority[a] > state_priority[b]:
		return true
	else:
		return false

func get_next_state(_input: InputPackage) -> String:
	return "none"

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_input: InputPackage, _delta: float) -> void:
	pass


func mark_enter_time() -> void:
	enter_time = Time.get_unix_time_from_system()

func get_progress() -> float:
	var now: float = Time.get_unix_time_from_system()
	return now - enter_time

func works_longer_than(time: float) -> bool:
	if get_progress() > time:
		return true
	return false

func works_less_than(time: float) -> bool:
	if get_progress() < time:
		return true
	return false

func works_between(start_time: float, finish_time: float) -> bool:
	var progress: float = get_progress()
	if progress > start_time and progress < finish_time:
		return true
	return false
