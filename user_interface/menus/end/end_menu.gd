extends Control


onready var stats: Label = $Stats


func _ready() -> void:
	stats.text = stats.text % [PlayerStats.deaths, stepify(PlayerStats.time, 0.01)]
