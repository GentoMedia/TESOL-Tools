extends Node


var Words = []
var ngslWords = []
var NGSL = []
var EntryList = []

func _ready():
	open_list("res://CEFRJWordlist", EntryList, Words)
	open_list("res://NGSL", NGSL, ngslWords)


func open_list(file_path : String, entry_list : Array, word_list : Array):
	var regex = RegEx.new()
	regex.compile("[a-z]+")
	var file = File.new()
	file.open(file_path, File.READ)
	while file.get_position() < file.get_len():
		var entry = file.get_csv_line()
		var splitEntry = entry[0].split("/")
		for word in splitEntry:
			entry_list.append([word, entry[1], entry[2]])
			word = word.to_lower()
			word = word.replace(".", "")
			word = regex.search(word).get_string()
			word_list.append(word)
	file.close()
