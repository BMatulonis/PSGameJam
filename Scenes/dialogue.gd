extends Control

@export var custom_text := "TEXT"
@export var prev_text : Control
@export var next_text : Control
@export var shop_list : VBoxContainer
@export var timer_increment := 0.01
@export var text_speed := 0.6

var leaving_shop := false
var current_text : bool
var final_text : bool
var visible_char := 0
var timer := 0.0

func _ready():
	$Label.text = custom_text
	if !prev_text:
		self.visible = true
		current_text = true
	else:
		self.visible = false
		current_text = false
	if !next_text:
		final_text = true
	else:
		final_text = false

func _process(delta):
	if Input.is_action_just_pressed("skip") and current_text and !leaving_shop:
		$Label.visible_ratio = 1
	if $Label.visible_ratio < 1 and current_text:
		$Label.visible_ratio += text_speed * delta
	elif $Label.visible_ratio >= 1 and current_text:
		timer += timer_increment
		if timer >= 1.0 and !final_text:
			timer = 0.0
			move_to_next_text()
		elif timer >= 1.0 and final_text:
			self.current_text = false
			self.visible = false
			if shop_list:
				shop_list.visible = true

	if visible_char != $Label.visible_characters:
		visible_char = $Label.visible_characters
		$AudioStreamPlayer2D.play()

func move_to_next_text() -> void:
	self.current_text = false
	self.visible = false
	next_text.visible = true
	next_text.current_text = true

func _on_shop_list_leave_leave_shop():
	leaving_shop = true
	self.visible = true
	current_text = true
	final_text = true
