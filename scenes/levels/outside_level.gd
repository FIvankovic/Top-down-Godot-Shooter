extends LevelParent;

#Connected level
#@export var inside_level_scene: PackedScene = preload("res://scenes/levels/inside.tscn");

#Tweening functionality - changes camera when player enters the house object	
func _on_house_player_entered() -> void:
	print("Player has the House in entry level.");
	var tween = get_tree().create_tween();
	tween.tween_property($Player/Camera2D, "zoom",Vector2(1,1),1);


func _on_house_player_exited() -> void:
	# Tweening - reset the camera when exit
	var tween = get_tree().create_tween();
	tween.tween_property($Player/Camera2D, "zoom", Vector2(0.6,0.6),1);

#SIGNAL BASED FUNCTIONS

func _on_gate_object_player_entered_gate() -> void:
	print("Player entered gate on entry level.")
	var tween = create_tween();
	tween.tween_property($Player,"speed",0,0.5);
	TransitionScene.change_scene("res://scenes/levels/inside.tscn");
	#get_tree().change_scene_to_file("res://scenes/levels/inside.tscn");
