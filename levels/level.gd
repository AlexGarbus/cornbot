class_name Level
extends Node2D


signal finished

export(PackedScene) var next_level

var _max_corn_count := 0
var _corn_count := 0
var _player_start_position := Vector2.ZERO

onready var player: Player = $Player
onready var corn_holder: Node = $Corn


func _ready() -> void:
	_player_start_position = player.position
	player.connect("died", self, "reset")
	for corn in corn_holder.get_children():
		_max_corn_count += 1
		corn.connect("collected", self, "_on_corn_collected")
	_corn_count = _max_corn_count


func _on_corn_collected() -> void:
	_corn_count -= 1
	if _corn_count == 0:
		finish()


func finish() -> void:
	player.win()
	emit_signal("finished")
	

func reset() -> void:
	player.position = _player_start_position
	player.reset()
	
	yield(get_tree(), "idle_frame")
	
	for corn in corn_holder.get_children():
		corn.hidden = false
	_corn_count = _max_corn_count
