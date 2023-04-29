extends CharacterBody3D


const SPEED = 8
const RUN_SPEED = 16
const SPEED_ACC = 4
const JUMP_VELOCITY = 4.5
const ROTATION_SPEED = 8
const STAMINA_USE_SPEED = 0.4
const STAMINA_RECHARGE_SPEED = 0.3

@export var camera: Node3D

var ThrowState = preload("res://scripts/ThrowStateScript.gd")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var action_state = ThrowState.new()
var current_speed = SPEED
var stamina = 1

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("pickup") and is_on_floor():
		var objects = $PickupArea.get_overlapping_bodies()
		if objects.size() > 0:
			action_state.pickup($PickupArea, objects[0])

	if Input.is_action_pressed("action"):
		if action_state.is_loaded():
			action_state.charge(delta)
			if action_state.is_fully_charged():
				action_state.release($PickupArea, position)

	if Input.is_action_just_released("action"):
		action_state.release($PickupArea, position)

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

#	var current_rot = Quaternion(get_basis())
#	var target_rot = Quaternion(camera.get_basis())
#	quaternion = current_rot.slerp(target_rot, delta * ROTATION_SPEED)
	quaternion = quaternion.slerp(Quaternion(camera.get_basis()), delta * ROTATION_SPEED)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (camera.get_basis() * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var target_speed = RUN_SPEED if Input.is_action_pressed("sprint") && stamina > 0 else SPEED
	current_speed = lerpf(current_speed, target_speed, delta * SPEED_ACC)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	if Input.is_action_pressed("sprint"):
		if stamina > 0:
			stamina -= delta * STAMINA_USE_SPEED
			if stamina < 0:
				stamina = 0
			Utils.ui.set_stamina_bar(stamina)
	else:
		if stamina < 1:
			stamina += delta * STAMINA_RECHARGE_SPEED
			if stamina > 1:
				stamina = 1
			Utils.ui.set_stamina_bar(stamina)

	move_and_slide()
