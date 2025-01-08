extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 12

var Grenade = preload("res://portal_nade.tscn")
var xform : Transform3D
var canThrow = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	#Play Robot Animations
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		$AnimationPlayer.play ("jump")
	elif is_on_floor() and input_dir != Vector2.ZERO:
		$AnimationPlayer.play("run")
	elif is_on_floor() and input_dir == Vector2.ZERO:
		$AnimationPlayer.play("idle")
		
	# Rotate camera Left / Right
	if Input.is_action_just_pressed("cam_left"):
		$Camera_Controller.rotate_y(deg_to_rad(-30))
	if Input.is_action_just_pressed("cam_right"):
		$Camera_Controller.rotate_y(deg_to_rad(30))
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	
	# New Vector3 dir taking into account cam rot an arrow input
	
	var direction = ($Camera_Controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#Rotate char meso so oriented towards the dir
	if input_dir != Vector2(0,0):
		$Armature.rotation_degrees.y = $Camera_Controller.rotation_degrees.y - rad_to_deg(input_dir.angle()) -90
	
	#Rotate Char to align with floor
	if is_on_floor():
		align_with_floor($RayCast3D.get_collision_normal())
		global_transform = global_transform.interpolate_with(xform, 0.3)
	elif not is_on_floor():
		align_with_floor(Vector3.UP)
		global_transform = global_transform.interpolate_with(xform, 0.3)
	
	#Update velocity and move Char
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	#Make Camera Controller Match the position of Bob
	$Camera_Controller.position = lerp($Camera_Controller.position, position, 0.15 )
	
	#Grenade function
	grenadeThrow()
	
func align_with_floor(floor_normal):
	xform = global_transform
	xform.basis.y = floor_normal
	xform.basis.x = -xform.basis.z.cross(floor_normal)
	xform.basis = xform.basis.orthonormalized()
	
func grenadeThrow():
	if Input.is_action_just_released("Throw") && canThrow:
		var grenadeins = Grenade.instantiate()
		grenadeins.position = $Armature/Skeleton3D/Nadepos.global_position
		get_tree().current_scene.add_child(grenadeins)
		
		canThrow = false
		$Throwtimer.start()
		
#		force var for grenade in negative so it moves away from player
		var force = -20
#		Contro Arch of grenade
		var upDirection = 15
		var direction = $Camera_Controller.transform.basis.z.normalized()
		var impulse = direction * force + Vector3(0, upDirection , 0)
		
		var playerRotation = $Armature/Skeleton3D/Nadepos.global_transform.basis.z.normalized()
		
		grenadeins.apply_central_impulse(impulse)
		
		
		
		
	
	
	
	
	
	
	
	


func _on_fall_zone_body_entered(body):
	get_tree().change_scene_to_file("res://level_1.tscn")
	
	
	
	
	


func _on_throwtimer_timeout() -> void:
	canThrow = true
