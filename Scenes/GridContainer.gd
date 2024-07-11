extends GridContainer

func _process(delta):
	var i=0;
	for y in Global.table_size:
		for x in Global.table_size:
			get_child(i).grid_pos = Vector2(x,y);
			i += 1;
