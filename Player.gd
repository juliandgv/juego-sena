extends KinematicBody2D

var motion = Vector2()
var SP = 280
const UP = Vector2(0,-1)
var Acc = 10 
var Battery = 100
var xstart = position.x
var ystart = position.y
var Charging = false 
var ChargeVal = 50 

var Ready = false
var Blinking = false
var StepFX = false 


func _ready():
	xstart = position.x
	ystart = position.y
	$Control/Canvas/ReadyPosition/ReadyText.hide()
	
func _physics_process(delta):
	
	if(get_slide_collision(get_slide_count()-1) !=null):
		var obj_col = get_slide_collision(get_slide_count()-1).collider
		if(obj_col.is_in_group("atake")):
			get_tree().change_scene("res://Level_1.tscn")
	
	if $StepsSound.is_playing():
		StepFX = false

	if is_on_floor() && motion.x > 10 || motion.x < -10:
		if StepFX:
			$StepsSound.play()
			
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().reload_current_scene() 
		
	motion.y += 20 
	if motion.y >= 680:
		motion.y = 680
	var friction = false
	
	
	if Input.is_action_pressed("ui_right") && Ready:
		motion.x += Acc
		motion.x = min(motion.x+Acc,SP)
		
		
		$Sprite.flip_h = false
		$Sprite.play("Run")
	elif Input.is_action_pressed("ui_left") && Ready:
		motion.x -= Acc
		motion.x = max(motion.x-Acc, -SP)
		
		
		$Sprite.flip_h = true
		$Sprite.play("Run")
	else:
		$Sprite.play("Stand")
		friction = true
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up") && Ready:
			motion.y = -SP*2
			
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.3) 
	else:
		if motion.y < 0:
			$Sprite.play("Jump")
		else:
			$Sprite.play("Fall")
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.5) 
			
	motion = move_and_slide(motion, UP)
	
	
	$Control/Canvas/Position2D/BarSprite.value = Battery

	
	if Charging && ChargeVal >0:
		ChargeVal -= 1
		Battery += 1
	if ChargeVal <= 0:
		Charging = false;
	if Battery > 100:
		Battery = 100
		Charging = false
		ChargeVal = 0
		
	
	if Battery > 50:
		$Control/Canvas/Position2D/BarSprite.texture_progress = load("res://Sprites/spr_bar_green.png")
	elif Battery > 20 && Battery <= 50:
		$Control/Canvas/Position2D/BarSprite.texture_progress = load("res://Sprites/spr_bar_yellow.png")
	elif Battery <= 20:
		$Control/Canvas/Position2D/BarSprite.texture_progress = load("res://Sprites/spr_bar_red.png")
		
	
	
	
	if Battery < 30:
		BG_Music.set_pitch_scale(1.1)
	else:
		BG_Music.set_pitch_scale(1)
func _on_BatteryTimer_timeout():
	if Battery > 0 && !Charging:
		Battery -= 1
	elif Battery <= 0:
		get_tree().change_scene("res://GameOver.tscn") 
		

func _get_energy():
	Charging = true
	ChargeVal += 50
	$BatterySound.play()
	$EnergySound.play()

func _on_StartGameTimer_timeout(): 
	$Control/Canvas/ReadyPosition/ReadyText.show()
	$HideReadyTimer.start()
	$BatteryTimer.start()
	Ready = true
	if BG_Music.PlayMusic == true:
		BG_Music.play()


func _on_HideReadyTimer_timeout():
	$Control/Canvas/ReadyPosition/ReadyText.hide()


func _on_Spikes_Hit():
	if Blinking == false:
		$HitSound.play()
		Ready = false
		$HitTimer.start()
		$BlinkHideShowTimer.start()
	
func _on_Spiks_Hit():
	if Blinking == false:
		Ready = false
		$HitTimer.start()
		$BlinkHideShowTimer.start()


func _on_HitTimer_timeout():
	Ready = true
	Blinking = true
	$BlinkingTimer.start()


func _on_BlinkingTimer_timeout():
	Blinking = false
	Ready = true
	$BlinkHideShowTimer.stop()
	$Sprite.modulate.a = 1


func _on_BlinkHideShowTimer_timeout():
	if $Sprite.modulate.a == 1:
		$Sprite.modulate.a = 0.5
	else:
		$Sprite.modulate.a = 1


func _on_StepsSound_finished():
	StepFX = true 


func _level_complete_goal():
	Ready = false
	Charging = true
	ChargeVal = 100
	
func _on_enemigo_Hit():
	if Blinking == false:
		$HitSound.play()
		Ready = false
		$HitTimer.start()
		$BlinkHideShowTimer.start()

func _on_dao_timeout():
	Ready = true
	Blinking = true
	$BlinkingTimer.start() # Replace with function body.


func _on_dao_enemigo_timeout():
	$Control/Canvas/ReadyPosition/ReadyText.hide() 
	
	
	
	



