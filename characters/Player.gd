extends KinematicBody2D


var speed = 600;
var RunSpeed = 1000;
var jump_force = -900;
var jump_2_max_force = -500;
var gravity = 30;
var acc = 30;
var aceFeeling = 0.2;
var max_jump_count = 2;
var current_jump_count = 0;
var playerMovment = Vector2();
onready var animation = $AnimatedSprite
const UP = Vector2(0,-1)
var animationName = "Idel";
func _physics_process(delta):
	playerMovment.y +=  gravity;
	
	animation.play(animationName)
	if Input.is_action_pressed("ui_left"):
		if Input.is_action_pressed("RunS"):
			if is_on_floor():
				animationName = "RunS"
				playerMovment.x = max(playerMovment.x - acc,-RunSpeed)
				jump_force = -1000;
				aceFeeling = 0.1;
				animation.flip_h = true;
		else:		
			jump_force = -900
			aceFeeling = 0.2;
			playerMovment.x = max(playerMovment.x - acc,-speed)
			animation.flip_h = true;
			if is_on_floor():
				#animation.play("Run")
				animationName = "Run"
			else:
				if animationName == "Run":
					animationName = "Fall"
	elif Input.is_action_pressed("ui_right"):
		if Input.is_action_pressed("RunS"):
			if is_on_floor():
				animationName = "RunS"
				playerMovment.x = min(playerMovment.x + acc,RunSpeed);
				jump_force = -1000;
				aceFeeling = 0.1;
				animation.flip_h = false;
		else:		
			jump_force = -900
			aceFeeling = 0.2;
			playerMovment.x = min(playerMovment.x + acc,speed); 
			animation.flip_h = false;
			if is_on_floor():
	#			animation.play("Run")
				animationName = "Run"
			else:
				if animationName == "Run":
					animationName = "Fall"
	elif Input.is_action_just_pressed("AttackHand"):
		animationName  = "AttackHand"
	elif Input.is_action_just_pressed("AttackKick"):
		animationName = "AttackKick"
	else:
		playerMovment.x = lerp(playerMovment.x,0,0.1);
		if is_on_floor():
#			animation.play("Idel")
			if animationName == "Fall":
				animationName = "FallFinished";
				
			elif animationName == "RunS":
				animationName = "RunStop"
				
			else:	
				if animationName != "FallFinished" && animationName != "RunStop" && animationName != "AttackHand" && animationName != "AttackKick":
					animationName = "Idel"
	
	if is_on_floor():
		current_jump_count = 0
	if is_on_wall():
		current_jump_count = 1
		
	if Input.is_action_just_pressed("ui_up")  &&  current_jump_count < max_jump_count:
		if current_jump_count == 0:
			playerMovment.y = jump_force
#aq 			animation.play("Jump")
			animationName = "Jump"
			
		else:
			playerMovment.y = jump_2_max_force
		current_jump_count = current_jump_count + 1
		animationName = "Jump"
				
	playerMovment = move_and_slide(playerMovment,UP)	 




func _on_AnimatedSprite_animation_finished():
	if !is_on_floor():
		if animationName == "Jump":
			animationName = "Fall"
	else:
		if animationName == "FallFinished" || animationName == "RunStop" || animationName == "AttackHand" || animationName == "AttackKick":
			animationName = "Idel"
			
