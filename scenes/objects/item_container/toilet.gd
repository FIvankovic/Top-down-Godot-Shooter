extends ItemContainerParent

var player_nearby: bool = false;

func _ready() -> void:
	add_to_group('ItemContainer');
	add_to_group('Container');

func hit(_projectile_dmg):
	if not opened:
		$LidSprite.hide();
		$AudioStreamPlayer2D.play();
		
		for i in range(1):
			var pos = $SpawnPositions.get_child(0).global_position;
			open.emit(pos, current_direction);
	opened = true;

#Open the container with the press of the "E" key or middle mouse button
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and opened == false and player_nearby:
		hit(0);


func _on_interact_area_2d_body_entered(_body: Node2D) -> void:
	player_nearby = true;


func _on_interact_area_2d_body_exited(_body: Node2D) -> void:
	player_nearby = false;
