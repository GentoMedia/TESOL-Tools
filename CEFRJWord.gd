extends Control


var regex = RegEx.new()

onready var CEFRJWordList = get_node("/root/WordList/")
onready var entry = preload("res://Entry.tscn")
onready var NGSLentry = preload("res://NGSLEntry.tscn")
onready var credits = preload("res://Credits.tscn")

func _ready():
	$VBoxContainer/SearchBar/SearchInput.grab_focus()

func _on_SearchButton_pressed(_words : String = "example"):
	regex.compile("[a-z]+")
	for child in $VBoxContainer/ScrollContainer/WordResults.get_children():
		child.queue_free()
	
	var searchWords = $VBoxContainer/SearchBar/SearchInput.text.split(" ")
	
	var tempWords = []
	for word in searchWords:
		word = word.to_lower()
		word = word.replace(".", "")
		word = word.replace("'", "")

		if regex.search(word) == null:
			word = ""
		else:
			word = regex.search(word).get_string()
		tempWords.append(word)
	
	searchWords = tempWords
	tempWords = []
	
	for word in searchWords:
		#Plurals & 3rd Person Present
		if word.ends_with("s"):
			if word.ends_with("es"):
				if word.ends_with("ies"):
					tempWords.append(word.rstrip("ies") + "y")
				else:
					tempWords.append(word.rstrip("s"))
					tempWords.append(word.rstrip("es"))
			else:
				tempWords.append(word.rstrip("s"))
		
		#Gerund or Present Participle
		if word.ends_with("ing"):
			tempWords.append(word.rstrip("ing"))
			tempWords.append(word.rstrip("ing") + "e")
		
		#Negative
		if word.ends_with("nt"):
			tempWords.append(word.rstrip("nt"))
			tempWords.append(word.rstrip("t"))
			
		#Past Tense
		if word.ends_with("d"):
			if word.ends_with("ed"):
				if word.ends_with("ied"):
					tempWords.append(word.rstrip("ied") + "y")
				else:
					tempWords.append(word.rstrip("d"))
					tempWords.append(word.rstrip("ed"))
		
	searchWords.append_array(tempWords)
	
	
	for word in searchWords:
		var NGSLentryInt = CEFRJWordList.ngslWords.find(word, 0)
		if NGSLentryInt >= 0:
			var newNGSLEntry = NGSLentry.instance()
			$VBoxContainer/ScrollContainer/WordResults.add_child(newNGSLEntry)
			newNGSLEntry.get_node("HBoxContainer/Word").text = CEFRJWordList.NGSL[NGSLentryInt][0]
			newNGSLEntry.get_node("HBoxContainer/List").text = CEFRJWordList.NGSL[NGSLentryInt][1]
			newNGSLEntry.get_node("HBoxContainer/Rank").text = CEFRJWordList.NGSL[NGSLentryInt][2]

		var entries = CEFRJWordList.Words.count(word)
		var entryPos = 0

		while entries > 0:
			var entryInt = CEFRJWordList.Words.find(word, entryPos)
			if entryInt >= 0:
				var newEntry = entry.instance()
				$VBoxContainer/ScrollContainer/WordResults.add_child(newEntry)
				newEntry.get_node("HBoxContainer/Word").text = CEFRJWordList.EntryList[entryInt][0]
				newEntry.get_node("HBoxContainer/CEFR").text = CEFRJWordList.EntryList[entryInt][2]
				newEntry.get_node("HBoxContainer/SpeechPart").text = CEFRJWordList.EntryList[entryInt][1]
			entryPos = entryInt + 1
			entries -= 1
