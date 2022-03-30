extends Button


func _on_PlayButton_button_up() -> void:
	get_tree().change_scene("res://game/game.tscn")
