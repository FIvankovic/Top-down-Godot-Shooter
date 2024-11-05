extends Node

signal player_stats_changed

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.10,0.13,0.18,1.0));



var bullet_count = 20:
	get:
		return bullet_count;
	set(value):
		bullet_count = value;
		player_stats_changed.emit();

#Grenade
var grenade_count = 3:
	get:
		return grenade_count;
	set(value):
		grenade_count = value;
		player_stats_changed.emit();

var player_iframes: bool = false;
var player_health = 100:
	get:
		return player_health;
	set(value):
		if value > player_health:
			player_health = min(value,100)
		else:
			if player_iframes == false:
				player_health = max(value,0);
		player_stats_changed.emit();

var player_position: Vector2;
