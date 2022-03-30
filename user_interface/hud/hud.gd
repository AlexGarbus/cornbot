class_name HUD
extends Control


onready var energy_bar := $HBoxContainer/EnergyBar


func set_energy_bar(value: float) -> void:
	energy_bar.value = value
