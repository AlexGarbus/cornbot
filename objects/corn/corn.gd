class_name Corn
extends Area2D


signal collected

var hidden := false setget set_hidden

onready var sprite: Sprite = $Sprite


func set_hidden(value: bool) -> void:
	set_deferred("monitoring", !value)
	set_deferred("monitorable", !value)
	sprite.visible = !value
	hidden = value


func _on_Corn_body_entered(body: Node) -> void:
	emit_signal("collected")
	self.hidden = true
