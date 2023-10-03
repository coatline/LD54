extends Node2D
class_name Flash_Animation

@export var to_effect : Array[CanvasItem]
@export var speed = 6

var animating = false
var opacity = 0
var direction = 1

func animate():
	animating = true
	direction = 1
	opacity = 0.8

func _process(delta):
	if animating:
		opacity += delta * direction * speed
		
		for tex in to_effect:
			var s = tex as CanvasItem
			s.material.set_shader_parameter("hit_opacity", opacity)
		
		if opacity >= 1:
			direction = -1
		elif opacity <= 0:
			opacity = 0
			animating = false
