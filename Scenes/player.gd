extends CharacterBody2D;
## Number of lives
@export var life = 3: set = set_life;
## Was hurt, needs moved
signal respawn;
## Life is @ 0
signal died;
## How fast the player falls
@export var gravity = 750;
## The max run speed of the player
@export var run_speed = 150;
## The max jump speed for the player (negitive is up in Godot)
@export var jump_speed = -300;

var score = 0: set = set_score;

func _ready() -> void:
	change_state(IDLE);
	update_label();

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta;
	get_input();
	move_and_slide();
	#region collision handeler
	if state == HURT:
		return
	for i in get_slide_collision_count(): #NOTE Multi collsion tester
		var collision = get_slide_collision(i);
		if collision.get_collider().is_in_group("danger"):
			hurt();
		if collision.get_collider().is_in_group("enemies"):
			if position.y < collision.get_collider().position.y:
				collision.get_collider().take_damage();
				velocity.y = -200;
			else:
				hurt();
		if collision.get_collider().is_in_group("goodie") and position.y > collision.get_collider().position.y and !is_on_floor():
			set_score(5);
	if is_on_floor(): 
		change_state(IDLE);
	#endregion

#region State Machine
enum {IDLE, HURT, DEAD};
var state = IDLE;

func change_state(new_state):
	state = new_state;
	match state:
		IDLE:
			pass;
		HURT:
			velocity.y = -200;
			life -= 1;
			if life <= 0:
				return
			respawn.emit();
			await get_tree().create_timer(0.5).timeout;
			change_state(IDLE);
		DEAD:
			died.emit();
			hide();
#endregion

func set_life(value):
	life = value;
	if life <= 0:
		change_state(DEAD);
	update_label();

## This should remove 1 life and return Greg to the start
func hurt():
	if state != HURT:
		change_state(HURT);


func get_input():
	#Hurt players can't move
	if state == HURT:
		return;
	#CAUTION ALERT HARD STOP HERE ALERT
	
	var right = Input.is_action_pressed("right");
	var left = Input.is_action_pressed("left");
	var jump = Input.is_action_just_pressed("jump"); #NOTE: "_just" is used to only have the jump activate once per press.
	
	#region Right & Left Movement + States
	velocity.x = 0; # Movement always starts from 0;
	if right:
		velocity.x += run_speed;
		$Sprite2D.flip_h = false;
	
	if left:
		velocity.x -= run_speed;
		$Sprite2D.flip_h = true;
	#endregion
	
	#NOTE: Jumping can only happen from the floor, no double jumping
	if jump and is_on_floor(): 
		velocity.y = jump_speed;
#endregion

## Really Add_score
func set_score(_score):
	score += _score;
	update_label();

func update_label():
	$CanvasLayer/Container/Label.text = "Lives: " + str(life) + "\nCoins: " + str(score);
