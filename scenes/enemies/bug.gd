extends CharacterBody2D

#Variables
#Stats
var bug_health = 40;
var attack_dmg: int = 20;
#Bug attack speed is tied to attack animation frame per second lmao
var speed: int = 10000;

#Booleans
var player_nearby: bool = false;
var player_in_attack_range: bool = false;
var bug_iframes: bool = false;
var active: bool = false;

#Animation states
enum State {Walk, Attack, Idle}
var current_state: State = State.Idle;

#Player node stored
var target_in_range: Node2D;

#Refs
@onready var organic_impact_sfx: AudioStreamPlayer2D = $SFX/Organic_Impact_SFX;
@onready var iframes_timer: Timer = $Timers/IFrames_Timer;
@onready var attack_timer: Timer = $Timers/Attack_Timer;
@onready var bug_sprite: AnimatedSprite2D = $Bug_AnimatedSprite2D;
@onready var hit_vfx: GPUParticles2D = $VFX/Hit_VFX;

func _process(delta: float) -> void:
	if player_nearby == true:
		look_at(Globals.player_position);
		var direction: Vector2 = (Globals.player_position - position).normalized();
		velocity = direction * speed * delta;
		
	enemy_animations();
	if active:
		move_and_slide();

func hit(projectile_dmg: int) -> void:
	print("Bug hit!");
	if bug_iframes == false:
		organic_impact_sfx.play();
		iframes_timer.start();
		bug_iframes = true;
		bug_health -= projectile_dmg;
		hit_vfx.emitting = true;
		bug_sprite.material.set_shader_parameter("progress", 1);
		if bug_health <= 0:
			queue_free();

func enemy_animations():
	if current_state == State.Walk:
		bug_sprite.play("walk");
	elif current_state == State.Attack and player_in_attack_range:
		bug_sprite.play("attack");
	elif current_state == State.Idle:
		bug_sprite.stop();

func attack() -> void:
	current_state = State.Attack;
	attack_timer.start();
	
#Detection Areas
func _on_detection_area_2d_body_entered(body: Node2D) -> void:
	player_nearby = true;
	active = true;
	target_in_range = body;
	current_state = State.Walk;

func _on_detection_area_2d_body_exited(body: Node2D) -> void:
	player_nearby = false;
	active = false;
	target_in_range = null;
	current_state = State.Idle;

#Attack Areas
func _on_attack_aread_2d_body_entered(body: Node2D) -> void:
	player_nearby = true;
	player_in_attack_range = true;
	target_in_range = body;
	attack();

func _on_attack_aread_2d_body_exited(body: Node2D) -> void:
	if player_nearby:
		current_state = State.Walk;
	else:
		current_state = State.Idle;
	player_in_attack_range = false;

#TIMERS
#IFrame timer
func _on_i_frames_timer_timeout() -> void:
	bug_iframes = false;
	bug_sprite.material.set_shader_parameter("progress", 0);

func _on_attack_timer_timeout() -> void:
	attack();

#Check to see if the player is still in attack range
func _on_bug_animated_sprite_2d_animation_finished() -> void:
	if player_in_attack_range:
		if "hit" in target_in_range and target_in_range != null:
			target_in_range.hit(attack_dmg);
			attack_timer.start();
