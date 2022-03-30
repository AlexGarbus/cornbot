extends Node


export(PackedScene) var end_scene

onready var hud: HUD = $HUD
onready var level: Level = $Level0
onready var win_timer: Timer = $WinTimer


func _ready() -> void:
	PlayerStats.reset()
	PlayerStats.timing = true
	initialize_level()


func initialize_level() -> void:
	level.connect("finished", self, "_on_level_finished")
	level.player.connect("energy_updated", hud, "set_energy_bar")


func _on_level_finished() -> void:
	win_timer.start()
	yield(win_timer, "timeout")
	goto_next_level()


func goto_next_level() -> void:
	if level.next_level == null:
		PlayerStats.timing = false
		get_tree().change_scene_to(end_scene)
	else:
		call_deferred("_deferred_goto_next_level")


func _deferred_goto_next_level() -> void:
	var next_level = level.next_level
	level.free()
	level = next_level.instance()
	add_child(level)
	initialize_level()
