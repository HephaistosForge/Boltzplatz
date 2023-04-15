extends Node

# Backgrounds
@export var bg_default: CompressedTexture2D
@export var bg_default2: CompressedTexture2D
@export var bg_default_no_goal: CompressedTexture2D
@export var bg_street: CompressedTexture2D
@export var bg_mud: CompressedTexture2D
@export var bg_ice: CompressedTexture2D
@export var bg_sand: CompressedTexture2D

@onready var ball: RigidBody2D = get_parent().get_node("Ball")
@onready var background: TextureRect = get_parent().get_node("Background")


func _ready():
	set_level_settings(Global.selected_level_settings)


func set_level_settings(level_setting: int) -> void:
	match level_setting as Global.LEVEL_SETTINGS:
		Global.LEVEL_SETTINGS.DEFAULT:
			_update_level_settings(700, bg_default)
		Global.LEVEL_SETTINGS.DEFAULT2:
			_update_level_settings(700, bg_default2)
		Global.LEVEL_SETTINGS.DEFAULT_NO_GOAL:
			_update_level_settings(700, bg_default_no_goal)
		Global.LEVEL_SETTINGS.STREET:
			_update_level_settings(900, bg_street)
		Global.LEVEL_SETTINGS.MUD:
			_update_level_settings(550, bg_mud)
		Global.LEVEL_SETTINGS.ICE:
			_update_level_settings(1400, bg_ice)
		Global.LEVEL_SETTINGS.SAND:
			_update_level_settings(600, bg_sand)
		_:
			pass


func _update_level_settings(new_velocity, background_texture: CompressedTexture2D) -> void:
	ball.set_velocity(new_velocity)
	background.texture = background_texture


func set_random_level_settings() -> void:
	set_level_settings(randi_range(0, Global.LEVEL_SETTINGS.size() - 1))
