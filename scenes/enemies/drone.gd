extends CharacterBody2D

#Variables
#var direction: Vector2 = Vector2.RIGHT;

#Stats
var speed: int = 10000;
var max_speed: int = 30000;
var speed_multiplier: int = 1;
var drone_dmg: int = 35;
var drone_health: int = 50;
var explosion_radius: int = 400;

#Boolean
var active: bool = false;
var drone_iframes: bool = false;
var explosion_active: bool = false;

#Timer
@onready var iframes_timer: Timer = $Timers/IFrames_Timer;
@onready var solid_impact_sfx: AudioStreamPlayer2D = $SFX/Solid_Impact_SFX;
@onready var drone_sprite: Sprite2D = $Drone_Sprite2D

func _ready() -> void:
	$Explosion.hide();
	drone_sprite.show();
	

func _physics_process(delta: float) -> void:
	if active:
		look_at(Globals.player_position);
		var direction = (Globals.player_position - position).normalized();
		velocity = direction * speed * delta;
		var collision = move_and_collide(velocity * delta);
		if collision:
			stop_movement();
			$AnimationPlayer.play("explosion");
			explosion_active = true;
	if explosion_active:
		var targets = get_tree().get_nodes_in_group("Container") + get_tree().get_nodes_in_group("Entity");
		for target in targets:
			var in_range = target.global_position.distance_to(global_position) < explosion_radius;
			if "hit" in target and in_range:
				target.hit(drone_dmg);
		

func hit(dmg: int):
	if drone_iframes == false:
		print("Drone hit");
		solid_impact_sfx.play();
		drone_sprite.material.set_shader_parameter("progress", 0)
		drone_iframes = true;
		iframes_timer.start();
		drone_health -= dmg;
		if drone_health <= 0:
			$AnimationPlayer.play("explosion");
			explosion_active = true;
		
	
func stop_movement() -> void:
	speed_multiplier = 0;
	speed = 0;
	active = false;

func _on_detection_area_2d_body_entered(_body: Node2D) -> void:
	active = true;
	var tween = create_tween();
	tween.tween_property(self, "speed", max_speed, 6);


func _on_i_frames_timer_timeout() -> void:
	drone_iframes = false;
	drone_sprite.material.set_shader_parameter("progress", 0);
