extends CharacterBody2D

#Variables
var player_nearby: bool = false;
var can_shoot: bool = true;
var scout_health: int = 10;
var invincibility_window: bool = false;

#Signals
signal shoot(pos: Vector2, direction, source: String);

#Refs
@onready var shoot_timer: Timer = $Timers/Shoot_Timer;
@onready var iframes_timer: Timer = $Timers/IFrames_Timer;
@onready var shoot_SFX: AudioStreamPlayer2D = $SFX/Shoot_SFX;
@onready var solid_impact_sfx: AudioStreamPlayer2D = $SFX/Solid_Impact_SFX;

func _process(_delta: float) -> void:
	if player_nearby == true:
		look_at(Globals.player_position);
		if can_shoot == true:
			scout_shoot();

func scout_shoot() -> void:
	#Randomly select one of the 2 markers
	var laser_markers = $LaserSpawnPositions.get_children();
	var selected_laser_marker = laser_markers[randi() % laser_markers.size()]; 
	
	#Position and direction which get signaled to the parent level
	var pos: Vector2 = selected_laser_marker.global_position;
	var direction: Vector2 = (Globals.player_position - position).normalized();
	shoot.emit(pos, direction, "enemy"); #Emit signal
	
	can_shoot = false;
	shoot_SFX.play();
	shoot_timer.start();

func hit(projectile_dmg: int) -> void:
	if invincibility_window == false:
		print("Scout was hit.");
		invincibility_window = true;
		iframes_timer.start();
		solid_impact_sfx.play();
		scout_health -= projectile_dmg;
		$Scout_Sprite2D.material.set_shader_parameter("progress", 1);
		if scout_health == 0:
			queue_free();

#When player enters aggro range
func _on_detection_range_area_2d_body_entered(_body: Node2D) -> void:
	player_nearby = true;

#When player exits aggro range
func _on_detection_range_area_2d_body_exited(_body: Node2D) -> void:
	player_nearby = false;

#Reset shooting timer
func _on_shoot_timer_timeout() -> void:
	can_shoot = true;

func _on_i_frames_timer_timeout() -> void:
	invincibility_window = false;
	$Scout_Sprite2D.material.set_shader_parameter("progress", 0);
