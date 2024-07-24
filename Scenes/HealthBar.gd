extends RichTextLabel

@export var player: CharacterBody2D
var max_health

func _ready():
	max_health = player.max_health
	append_text(str(max_health))

func _on_player_health_changed(old_health, health):
	health -= (old_health - health)
	if health > max_health:
		health = max_health
	if health <= 0:
		health = 0
	clear()
	append_text(str(health))
