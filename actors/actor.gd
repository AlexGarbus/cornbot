class_name Actor
extends KinematicBody2D


export var speed = Vector2(8, 8)
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")

const FLOOR_NORMAL = Vector2.UP

var _velocity = Vector2.ZERO


func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
