extends CanvasLayer

var color_rect = $ColorRect
var to_load : PackedScene

func transition():
	color_rect
	
	return true

func _process(delta):
	if to_load != null:
		
