extends RichTextLabel

var stats = PlayerStats
var count

func _ready():
	stats.connect("life_lost", _on_lives_changed)
	count = stats.lives
	append_text(str(count))

func _on_lives_changed():
	count = stats.lives
	clear()
	append_text(str(count))
