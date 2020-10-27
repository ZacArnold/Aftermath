extends KinematicBody2D


###VARIABLE SETUP###
const MOVE_SPEED = 275
const GRAVITY = 19.6
const JUMP_SPEED = -425
var velocity = Vector2(0,0)
var bullet = preload("res://Bullet.tscn")


###PLAYER LOOP###
func _physics_process(_delta):
	
	#Input Control
	if Input.is_action_pressed("move_left"):
		velocity.x = -MOVE_SPEED
		$PlayerSprite.play("Walk")
		$PlayerSprite.flip_h = true
	
	elif Input.is_action_pressed("move_right"):
		velocity.x = MOVE_SPEED
		$PlayerSprite.play("Walk")
		$PlayerSprite.flip_h = false
	
	elif velocity.x == 0 and velocity.y == 0:
		$PlayerSprite.play("Idle")
	
	else: 
		velocity.x = 0
	
	#Jump Control
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_SPEED

	elif velocity.y  < 0:
		$PlayerSprite.play("Jump")
	
	elif velocity.y > 200:
		$PlayerSprite.play("Fall")
	
	#Crouch Contrtol
	if Input.is_action_pressed("crouch") and is_on_floor():
		velocity.x = 0
		velocity.y = 0
		$PlayerSprite.play("Crouch")
	
	#Shooting
	if Input.is_action_just_pressed("shoot") and Global.global_ammo > 0:
		var bullet_shoot = bullet.instance()
		get_parent().add_child(bullet_shoot)
		bullet_shoot.position = position
		Global.global_ammo -= 1
		
		if $PlayerSprite.flip_h == true:
			bullet_shoot.direction = -1
			$PlayerSprite.play("Shoot")
		elif $PlayerSprtie.flip_h == false:
			bullet_shoot.direction = 1
			$PlayerSprite.play("Shoot")
	
	#Gravity and Movement
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity,Vector2.UP)
	
	#Death
	if Global.global_health <= 0:
		get_tree().change_scene("res://Menu.tscn")
	
	#Health Range
	if Global.global_health > 20:
		Global.global_health = 20
	elif Global.global_health < 0:
		Global.global_health = 0
		
	#Ammo Range
	if Global.global_ammo > 6:
		Global.global_ammo = 6
	elif Global.global_ammo < 0:
		Global.global_ammo = 0


func _on_Glutton_damage():
	Global.global_health = Global.global_health - randi()%4+3


###PICKUPS###
#Ammo Pickup
func _on_Ammo_collected():
	Global.global_ammo = Global.global_ammo + randi()%2+1


#MRE Pickup
func _on_MRE_collected():
	Global.global_health = Global.global_health + randi()%3+2
