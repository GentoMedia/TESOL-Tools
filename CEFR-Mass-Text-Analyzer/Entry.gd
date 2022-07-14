extends VBoxContainer


func _on_LookupButton_pressed():
	var searchAddress = "https://www.google.com/search?q="
	searchAddress += $HBoxContainer/Word.text + "+def"
	OS.shell_open(searchAddress)
