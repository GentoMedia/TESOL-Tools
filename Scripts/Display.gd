extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_table_column_expand(0, true, 2)
	set_table_column_expand(1, true, 1)
	set_table_column_expand(2, true, 1)
