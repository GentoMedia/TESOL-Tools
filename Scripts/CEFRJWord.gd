extends Control


var regex = RegEx.new()

@onready var CEFRJWordList = get_node("/root/WordList/")
@onready var credits = preload("res://Scenes/Credits.tscn")
@onready var NGSLWord = $VBoxContainer/HBoxContainer/NGSLWord
@onready var CEFRJWord = $VBoxContainer/HBoxContainer/CEFRJWord
@onready var Data1 = $VBoxContainer/HBoxContainer/Data1
@onready var Data2 = $VBoxContainer/HBoxContainer/Data2

func _ready():
	$VBoxContainer/SearchBar/SearchInput.grab_focus()

func _on_SearchButton_pressed(_words : String = "example"):
	for child in $VBoxContainer/HBoxContainer.get_children():
		child.clear()
	
	regex.compile("[a-z]+")
	
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
	
	# *** Change this to update RichTextLabel
	for word in searchWords:
		var NGSLentryInt = CEFRJWordList.ngslWords.find(word, 0)
		if NGSLentryInt >= 0:
			NGSLWord.append_text("[b]" + CEFRJWordList.NGSL[NGSLentryInt][0] + "[/b]\n")
			Data1.append_text(CEFRJWordList.NGSL[NGSLentryInt][1] + "\n")
			Data2.append_text(CEFRJWordList.NGSL[NGSLentryInt][2] + "\n")

		var entries = CEFRJWordList.Words.count(word)
		var entryPos = 0

		while entries > 0:
			var entryInt = CEFRJWordList.Words.find(word, entryPos)
			if entryInt >= 0:
				CEFRJWord.append_text(CEFRJWordList.EntryList[entryInt][0] + "\n")
				Data1.append_text(CEFRJWordList.EntryList[entryInt][2] + "\n")
				Data2.append_text(CEFRJWordList.EntryList[entryInt][1] + "\n")
			entryPos = entryInt + 1
			entries -= 1

