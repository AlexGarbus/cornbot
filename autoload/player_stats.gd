extends Node


var time := 0.0
var deaths := 0
var timing := false


func _process(delta: float) -> void:
	if timing:
		time += delta


func reset() -> void:
	time = 0
	deaths = 0
