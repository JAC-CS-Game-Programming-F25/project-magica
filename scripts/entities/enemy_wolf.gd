extends CharacterBody3D

@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D

func _ready() -> void:
	sprite.play("Idle")
