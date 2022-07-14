extends Control


var regex = RegEx.new()

onready var CEFRJWordList = get_node("/root/WordList/")
onready var entry = preload("res://Entry.tscn")
onready var credits = preload("res://Credits.tscn")

func _ready():
	$VBoxContainer/SearchBar/SearchInput.grab_focus()

func _on_SearchButton_pressed(_words : String = "example"):
	regex.compile("[a-z]+")
	for child in $VBoxContainer/ScrollContainer/WordResults.get_children():
		child.queue_free()
	
	var searchWords = $VBoxContainer/SearchBar/SearchInput.text.split(" ")
	
	for word in searchWords:
		word = word.to_lower()
		word = word.replace(".", "")
		if regex.search(word) == null:
			word = ""
		else:
			word = regex.search(word).get_string()
		
		
		
		
		var entries = CEFRJWordList.WordList.count(word)
		var entryPos = 0
		
		while entries > 0:
			var entryInt = CEFRJWordList.WordList.find(word, entryPos)
			if entryInt >= 0:
				var newEntry = entry.instance()
				$VBoxContainer/ScrollContainer/WordResults.add_child(newEntry)
				newEntry.get_node("HBoxContainer/Word").text = CEFRJWordList.EntryList[entryInt][0]
				newEntry.get_node("HBoxContainer/CEFR").text = CEFRJWordList.EntryList[entryInt][2]
				newEntry.get_node("HBoxContainer/SpeechPart").text = CEFRJWordList.EntryList[entryInt][1]
			entryPos = entryInt + 1
			entries -= 1
	$VBoxContainer/ScrollContainer/WordResults.add_child(credits.instance())
