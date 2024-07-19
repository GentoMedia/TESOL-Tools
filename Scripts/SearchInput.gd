extends LineEdit

var pasted = false


func _ready():
	var menu = get_menu()
	menu.item_count = 2
	menu.add_item("Paste", MENU_MAX + 1)
	menu.id_pressed.connect(menu_option_pressed)


func _input(event):
	if event is InputEventKey:
		if event.pressed and has_focus():
			if event.keycode == KEY_V and event.ctrl_pressed:
				editable = false
				paste_clipboard()
				pasted = true
		if !event.pressed and pasted:
			if event.keycode == KEY_V:
				editable = true


func menu_option_pressed(id):
	if id == MENU_MAX + 1:
		paste_clipboard()


func paste_clipboard():
	var temp_text = DisplayServer.clipboard_get()
	temp_text = temp_text.replace("\n", " ")
	temp_text = temp_text.replace("\t", " ")
	temp_text = temp_text.strip_escapes()
	if has_selection():
		delete_text(get_selection_from_column(), get_selection_to_column())
	text = text.insert(caret_column, temp_text)
