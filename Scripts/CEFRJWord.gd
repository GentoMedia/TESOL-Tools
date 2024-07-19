extends Control


var regex = RegEx.new()
var display_cache = ""
var display_array = [""]

@onready var CEFRJWordList = get_node("/root/WordList/")
@onready var credits = preload("res://Scenes/Credits.tscn")
@onready var Display = $VBoxContainer/Display


func _ready():
	$VBoxContainer/SearchBar/SearchInput.grab_focus()
	Display.resized.connect(set_tab_lengths)
	_on_SearchButton_pressed()


func _on_SearchButton_pressed(_words : String = ""):
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
	
# ####################### #
# # Displaying the data # #
# ####################### #
	Display.clear()
	display_cache = ""
	display_array.clear()
	
	for word in searchWords:
		
		var NGSLentryInt = CEFRJWordList.ngslWords.find(word, 0)
		if NGSLentryInt >= 0:
			set_table_row(
				CEFRJWordList.NGSL[NGSLentryInt][0], 
				CEFRJWordList.NGSL[NGSLentryInt][1], 
				CEFRJWordList.NGSL[NGSLentryInt][2]
				)
				
			
		elif CEFRJWordList.Words.count(word) > 0:
			set_table_row(word, "N/A", "N/A")
		else:
			continue
			
		var entries = CEFRJWordList.Words.count(word)
		var entryPos = 0
		
		while entries > 0:
			var entryInt = CEFRJWordList.Words.find(word, entryPos)
			if entryInt >= 0:
				set_table_row("", 
					CEFRJWordList.EntryList[entryInt][2], 
					CEFRJWordList.EntryList[entryInt][1]
					)
				
			entryPos = entryInt + 1
			entries -= 1
			
		display_array.append(display_cache)
		display_cache = ""
	
	set_tab_lengths()
	


func set_table_row(column_0 : String = "", column_1 : String = "", column_2 : String = ""):
	if column_0 == "":
		pass
	else:
		display_cache += "[font_size=32][b][url=https://www.google.com/search?q=" + column_0 +"+def]" + column_0 + "[/url][/b][/font_size]"
		display_cache += "  [font_size=12][url=https://jisho.org/search/" + column_0
		display_cache += "][lb]日本語[rb][/url][/font_size]"
	display_cache += "\t"
	display_cache += column_1
	display_cache += "\t"
	display_cache += column_2
	display_cache += "\n"
	


func set_tab_lengths():
	var tab_length_string = str(Display.size.x / 3)
	var display_temp = "[p tab_stops=" + tab_length_string + "]"
	
	for entry in display_array:
		display_temp += entry
		display_temp += "[font_size=24]\n[/font_size]"
		display_temp += "[img=" + str(Display.size.x - 32) + "x1]res://Resources/line_break.tres[/img]\n"
		display_temp += "[font_size=4]\n[/font_size]"
	
	display_temp += "[/p]"
	Display.parse_bbcode(display_temp)
	


func _on_display_meta_clicked(meta):
	OS.shell_open(str(meta))
	
