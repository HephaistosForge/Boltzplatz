extends Node

@export var level_settings: LEVEL_SETTINGS = LEVEL_SETTINGS.DEFAULT

# Backgrounds
@export var bg_default: CompressedTexture2D

@onready var ball: RigidBody2D = get_parent().get_node("Ball")
@onready var background: TextureRect = get_parent().get_node("Background")

enum LEVEL_SETTINGS {
	DEFAULT,
	STREET
}


func _ready():
	set_level_settings(level_settings)


func set_level_settings(level_setting: int) -> void:
	match level_setting as LEVEL_SETTINGS:
		LEVEL_SETTINGS.DEFAULT:
			_update_level_settings(700, bg_default)
		LEVEL_SETTINGS.STREET:
			_update_level_settings(1000, null)
		_:
			pass


func _update_level_settings(new_velocity, background_texture: CompressedTexture2D) -> void:
	ball.set_velocity(new_velocity)
	background.texture = background_texture
