extends Node2D

const ALPHA_LERP_SPEED = .25

@onready var weather_shadow = $"../CanvasLayer/WeatherShadow"
@onready var player = $"../Player"
@onready var rain = $Rain
@onready var snow = $Snow
@onready var rain_ambience : Ambience = $RainAmbience
@onready var snow_ambience : Ambience = $SnowAmbience
@onready var heat_ambience = $HeatAmbience

var offset : Vector2
var target_shadow_a = 0
var target_shadow_color : Color
var target_volume = 0

func _ready():
	offset = Vector2(120, -150)
	target_shadow_color = Color(0, 0, 0, 0)


func _process(delta):
	position = player.position + offset
	
	weather_shadow.color.r = move_toward(weather_shadow.color.r, target_shadow_color.r, delta)
	weather_shadow.color.g = move_toward(weather_shadow.color.g, target_shadow_color.g, delta)
	weather_shadow.color.b = move_toward(weather_shadow.color.b, target_shadow_color.b, delta)
	weather_shadow.color.a = move_toward(weather_shadow.color.a, target_shadow_color.a, delta * ALPHA_LERP_SPEED)

func tried_stepping_on(tile_type : Tile):
	if tile_type.name == "Snow":
		snow.emitting = true
		rain.emitting = false
		target_shadow_color = Color(0.1, 0.1, 0.3, .1)
		
		rain_ambience.turn_off()
		snow_ambience.turn_on()
		heat_ambience.turn_off()
		
	elif tile_type.name == "Rain":
		snow.emitting = false
		rain.emitting = true
		target_shadow_color = Color(0.0, 0.0, 0.1, .2)
		
		snow_ambience.turn_off()
		rain_ambience.turn_on()
		heat_ambience.turn_off()
		
	elif tile_type.name == "Sand":
		snow.emitting = false
		rain.emitting = false
		target_shadow_color = Color(1, 0.75, 0.0, .095)
		
		snow_ambience.turn_off()
		rain_ambience.turn_off()
		heat_ambience.turn_on()
	else:
		snow.emitting = false
		rain.emitting = false
		target_shadow_color = Color(0, 0, 0, 0)
		
		snow_ambience.turn_off()
		rain_ambience.turn_off()
		heat_ambience.turn_off()
