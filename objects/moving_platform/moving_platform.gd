class_name MovingPlatform
extends KinematicBody2D


export var move_duration = 1.0
export var move_target = Vector2.ZERO

onready var tween: Tween = $Tween

var _tween_values := []


func _ready() -> void:
	_tween_values = [position, move_target]
	start_tween()


func start_tween() -> void:
	tween.interpolate_property(self, "position", _tween_values[0], _tween_values[1], 
			move_duration)
	tween.start()


func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	_tween_values.invert()
	start_tween()
