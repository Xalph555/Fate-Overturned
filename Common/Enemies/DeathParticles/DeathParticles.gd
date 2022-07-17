# DeathParticles
# -----------------------------------------
extends Particles2D


func _ready() -> void:
	emitting = true
	$AudioStreamPlayer2D.playing = true
