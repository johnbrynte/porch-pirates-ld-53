extends CharacterBody3D


const SPEED = 8
const JUMP_VELOCITY = 4.5
const ROTATION_SPEED = 8

@export var camera: Node3D

var ProjectileObject = preload("res://objects/ProjectileObject.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var picked_up_object: RigidBody3D = null

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("pickup") and is_on_floor() and picked_up_object == null:
		var objects = $PickupArea.get_overlapping_bodies()
		print(objects)
		if objects.size() > 0:
			picked_up_object = objects[0]
			var model = picked_up_object.get_node("model")
			print(model)
			picked_up_object.get_parent().remove_child(picked_up_object)
			picked_up_object.freeze = true
			picked_up_object.remove_child(model)
			$PickupArea.add_child(model)

	if Input.is_action_just_pressed("action"):
		var projectile: RigidBody3D
		if picked_up_object != null:
			print("has picked up")
			projectile = picked_up_object
			picked_up_object = null
			var model = $PickupArea.get_node("model")
			print(model)
			$PickupArea.remove_child(model)
			projectile.add_child(model)
			projectile.freeze = false
		else:
			projectile = ProjectileObject.instantiate()
		var camera_basis = camera.get_basis()
		var camera_direction = camera.get_direction()
		projectile.position = position - camera_basis.z * 1 + Vector3.UP * 2
		projectile.shoot(camera_direction, 50)
		get_parent().add_child(projectile)

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var current_rot = Quaternion(get_basis())
	var target_rot = Quaternion(camera.get_basis())
	quaternion = current_rot.slerp(target_rot, delta * ROTATION_SPEED)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (camera.get_basis() * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
