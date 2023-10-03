extends Area2D

@onready var arrow = $Arrow
@onready var press_e = $PressE
@onready var respawn_position = $RespawnPosition

func _process(delta):
	if arrow.visible == true:
		if Input.is_action_just_pressed("interact"):
			Utils.show_message("Saved...", 1)
			SaveHandler.save(respawn_position.global_position)
			disappear()

func _on_body_entered(body):
	if body is Player:
		arrow.visible = true
		press_e.visible = true

func _on_body_exited(body):
	if body is Player:
		disappear()

func disappear():
	arrow.visible = false
	press_e.visible = false
