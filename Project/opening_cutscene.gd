extends CanvasLayer

@onready var s1 : Texture = preload("res://Graphics/OpeningCutscene/Scene1.png")
@onready var s2 : Texture = preload("res://Graphics/OpeningCutscene/Scene2.png")
@onready var s3 : Texture = preload("res://Graphics/OpeningCutscene/Scene3.png")
@onready var s4 : Texture = preload("res://Graphics/OpeningCutscene/Scene4.png")
@onready var s5 : Texture = preload("res://Graphics/OpeningCutscene/Scene5.png")
@onready var s6 : Texture = preload("res://Graphics/OpeningCutscene/Scene6.png")
@onready var s7 : Texture = preload("res://Graphics/OpeningCutscene/Scene7.png")
@onready var scene : TextureRect = $Background
@onready var narration = $Narration
@onready var fade = $Fade

@onready var ambience = $Ambience
@onready var wrecking_sound = $"Wrecking sound"
@onready var lightning = $Lightning
@onready var lightning2 = $Lightning2
@onready var thunder = $Thunder

var scenes = []
var index = 0

func _ready():
	scenes = [s1, s2, s3, s4, s5, s6, s7]

func begin():
	await(get_tree().create_timer(3).timeout)
	
	forward()
	thunder.playing = true
	# storm approaching
	await(get_tree().create_timer(1).timeout)
	
	# storm approaching
	forward()
	await(get_tree().create_timer(0.5).timeout)
	
	# storm arrives
	forward()
	# play thunder
	thunder.playing = true
	
	await(get_tree().create_timer(1).timeout)
	
	lightning.playing = true
	# lightning 1
	forward()
	await(get_tree().create_timer(0.5).timeout)
	
	# plane in storm
	forward()
	await(get_tree().create_timer(1.5).timeout)
	
	lightning2.playing = true
	wrecking_sound.playing = true
	# lightning 2
	forward()
	await(get_tree().create_timer(0.5).timeout)
	
	fade.visible = true

var end = false
var began = false

func _process(delta):
	
	if Input.is_action_just_pressed("skip"):
		index = 6
		forward()
	
	if began == false:
		fade.color.a -= delta / 2
		if fade.color.a <= 0:
			fade.visible = false
			began = true
			begin()
		return
	
	if fade.visible == false: return
	
	fade.color.a += delta * 8
	ambience.volume_db -= delta * 15

	if fade.color.a >= 1:
		if end == false:
			end = true
			await (get_tree().create_timer(4).timeout)
			forward()

func backward():
	index -= 1
	update()

func forward():
	index += 1
	update()

func update():
	if index >= 7:
		# Cutscene finished
		
		# We must have been watching again from the menu
		if SaveHandler.viewed_cutscene == true:
			get_tree().change_scene_to_file("res://main.tscn")
		else:
			SaveHandler.viewed_cutscene = true
			get_tree().change_scene_to_file("res://game.tscn")
	elif index == -1:
		# Main menu
		get_tree().change_scene_to_file("res://main.tscn")
	else:
		scene.texture = scenes[index]

func _on_forward_button_pressed():
	forward()

func _on_backward_button_pressed():
	backward()
