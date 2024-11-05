extends Area2D

signal player_entered;
signal player_exited;

func _on_body_entered(_body: Node2D) -> void:
	print("Player has entered the House.");
	player_entered.emit();


func _on_body_exited(_body: Node2D) -> void:
	print("Player has exited the House.");
	player_exited.emit()
