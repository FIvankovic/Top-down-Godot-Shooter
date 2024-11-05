extends CharacterBody2D

#Stats
var hunter_health: int;
var hunter_dmg: int;
var speed: int = 200;

#Booleans
var active: bool = false;

func _ready() -> void:
	$NavigationAgent2D.target_position = Globals.player_position;

func _physics_process(_delta: float) -> void:
	var next_path_pos: Vector2 = $NavigationAgent2D.get_next_path_position();
	var direction: Vector2 = (next_path_pos - global_position).normalized()
	velocity = direction * speed;
	move_and_slide();

func hit(dmg: int) -> void:
	print("Hunter was hit.");

func _on_detection_area_2d_body_entered(_body: Node2D) -> void:
	active = true;


func _on_detection_area_2d_body_exited(_body: Node2D) -> void:
	active = false;


func _on_navigation_timer_timeout() -> void:
	if active:
		$NavigationAgent2D.target_position = Globals.player_position;
