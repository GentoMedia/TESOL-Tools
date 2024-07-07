extends Control


func _on_CEFRJWord_pressed():
	get_tree().change_scene_to_file("res://Scenes/CEFRJWord.tscn")


func _on_CreditsButton_pressed():
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")
