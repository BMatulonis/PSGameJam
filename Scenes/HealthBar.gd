extends TextureProgressBar

@export var player : CharacterBody2D

func _ready():
	player = get_node("../../Player")
	self.player.connect("healthChanged", _on_player_health_changed)
	max_value = player.max_health
	value = max_value

func _on_player_health_changed(old_health, health):
	value -= (old_health - health)
