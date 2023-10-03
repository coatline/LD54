extends CanvasLayer

@onready var instruction = $Instruction
@onready var end_visual = $EndVisual
@onready var end_2_text = preload("res://Graphics/Ending/ending2.png")
@onready var flares_parent = $Flares
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

var index = 0
var flares = []
var can_continue = false
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	flares = flares_parent.get_children()
	SaveHandler.delete_save()

var last_flare = null

func _process(delta):
	time += delta * 2
	
	if time > 19:
		can_continue = true
		instruction.text = "Press anything to continue."
	elif time > 8:
		instruction.modulate.a += delta
		instruction.text = "I see a helicopter!"
		end_visual.texture = end_2_text
	elif time > 2:
		if int(time) >= flares.size():
			return
		
		var flare : RigidBody2D = flares[int(time)]
		
		if flare != last_flare:
			audio_stream_player_2d.playing = true
		
		last_flare = flare
		flare.freeze = false
		
		flare.linear_velocity = Vector2(randf_range(-50, 50), randf_range(-700, -400))
		flare.get_child(0).emitting = true
		flare.get_child(1).visible = true
	
	if can_continue == false: return
	
	if Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://main.tscn")
