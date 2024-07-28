extends Control

@export var custom_text := "TEXT"
@export var prev_text : Control
@export var next_text : Control
@export var shop_list : VBoxContainer
@export var timer_increment := 0.01
@export var text_speed := 0.6
@export var skippable := false
@export var fontSize := 24
@export var collisionFlag : Area2D

var flag_passed := false
var leaving_shop := false
var current_text : bool
var final_text : bool
var visible_char := 0
var timer := 0.0

func _ready():
	$Label.text = custom_text
	$Label.set("theme_override_font_sizes/font_size", fontSize)
	if !prev_text and !collisionFlag:
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
	if Input.is_action_just_pressed("skip") and current_text and !leaving_shop and skippable:
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

func _on_flag_entered():
	flag_passed = true
	self.visible = true
	self.current_text = true

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

func _on_collision_flag_body_entered(body):
	if !flag_passed:
		_on_flag_entered()

func _on_collision_flag_2_body_entered(body):
	if !flag_passed:
		_on_flag_entered()

func _on_collision_flag_3_body_entered(body):
	if !flag_passed:
		_on_flag_entered()

func _on_collision_flag_4_body_entered(body):
	if !flag_passed:
		_on_flag_entered()
