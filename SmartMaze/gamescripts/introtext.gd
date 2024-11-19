extends RichTextLabel

var current_text = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	visible_ratio = 0.0

func _on_text_timer_timeout():
	if visible_ratio != 1.0:
		visible_ratio += 0.01

func _on_next_button_pressed():
	match current_text:
		1: update_textbox("[center]Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus tincidunt eros sit amet nunc maximus convallis. Aenean suscipit euismod lacus ut maximus. Ut aliquet mattis leo, vestibulum dignissim mauris rhoncus ut. Aliquam sed congue elit. Phasellus fermentum consequat nibh sed pellentesque. Nunc vehicula mollis suscipit. Nunc luctus lorem ut efficitur. [/center]")
		2: update_textbox("[center]Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus tincidunt eros sit amet nunc maximus convallis. Aenean suscipit euismod lacus ut maximus. Ut aliquet mattis leo, vestibulum dignissim mauris rhoncus ut. Aliquam sed congue elit. Phasellus fermentum consequat nibh sed pellentesque. Nunc vehicula mollis suscipit. Nunc luctus lorem ut efficitur. [/center]")
		3: get_tree().change_scene_to_file("res://game.tscn")

func update_textbox(update_text):
		visible_ratio = 0.0
		text = update_text
		current_text += 1
