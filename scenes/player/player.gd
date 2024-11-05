extends CharacterBody2D

#var direction: Vector2 = Vector2.RIGHT;

#Timer booleans
var can_shoot: bool = true;
var can_grenade: bool = true;
var player_iframes: bool = false;

#SPEED
@export var max_speed: int = 25000;
var speed: int = max_speed;

#Signals - sends the global position
signal shoot_input_pressed(pos, direction, source: String);
signal grenade_input_pressed(pos, direction);

#References
@onready var player_sprite: Sprite2D = $PlayerSprite;
@onready var shoot_timer: Timer = $Timers/ShootTimer
@onready var grenade_timer: Timer = $Timers/GrenadeTimer
@onready var iframes_timer: Timer = $Timers/IFrames_Timer;
@onready var shootbullet_SFX: AudioStreamPlayer2D = $SFX/ShootBullet_SFX;
@onready var playerhit_SFX: AudioStreamPlayer2D = $SFX/PlayerHit_SFX;
@onready var laser_markers_node: Node2D = $LaserMarkers #Node2D with three markers for shooting positions start


func _ready() -> void:
	pass;

func _process(delta: float) -> void:
	
	
	var player_direction = (get_global_mouse_position() - position).normalized();
	player_move(delta);
	#Important function whcih moves the body of player by the velocity value
	move_and_slide();
	Globals.player_position = global_position;
	
	#Other functions
	player_shoot(delta, player_direction);
	player_grenade(delta, player_direction);

func player_move(delta: float) -> void:
	#Rotation of player
	look_at(get_global_mouse_position());
	var direction = Input.get_vector("move_left", "move_right","move_up","move_down");
	velocity = direction * speed * delta


func hit(projectile_dmg: int) -> void:
	if player_iframes == false:
		print("Player was hit!");
		player_sprite.material.set_shader_parameter("progress", 1);
		playerhit_SFX.play();
		player_iframes = true;
		iframes_timer.start();
		Globals.player_health -= projectile_dmg;
	

#Shooting functionality
func player_shoot(_delta: float, player_direction) -> void:
	if Input.is_action_pressed("primary_action") and can_shoot and Globals.bullet_count > 0:
		print("Shoot");
		var laser_markers = laser_markers_node.get_children();
		var selected_laser_marker = laser_markers[randi() % laser_markers.size()]; #Randomly select one of the 3 markers
		Globals.bullet_count -= 1;
		can_shoot = false;
		$Gunshot_VFX.emitting = true;
		#$ShootBullet_SFX.pitch_scale();
		shootbullet_SFX.play();
		shoot_timer.start();
		shoot_input_pressed.emit(selected_laser_marker.global_position, player_direction, "ally"); #Global position
	
#Grenade throw - secondary fire functionality
func player_grenade(_delta: float, player_direction) -> void:
	if Input.is_action_pressed("secondary_action") and can_grenade and Globals.grenade_count > 0:
		print ("Grenade Toss");
		var grenade_marker = laser_markers_node.get_children()[0].global_position;
		Globals.grenade_count -= 1;
		can_grenade = false;
		grenade_timer.start(); #Timer
		grenade_input_pressed.emit(grenade_marker, player_direction);
	


#Activates when the timer is finished/done
func _on_shoot_timer_timeout() -> void:
	can_shoot = true; # Re-enable the shooting

func _on_grenade_timer_timeout() -> void:
	can_grenade = true;

func _on_i_frames_timer_timeout() -> void:
	player_iframes = false;
	player_sprite.material.set_shader_parameter("progress", 0);
