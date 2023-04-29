extends Node

class_name ThrowState

const CHARGE_TIME = 1
const SHOOT_SPEED_MIN = 20
const SHOOT_SPEED_MAX = 80

# var ProjectileObject = preload("res://objects/ProjectileObject.tscn")

var picked_up_object: RigidBody3D = null
var picked_up_model: Node3D = null
var charge_timer = 0
var fully_charged = false

func _init():
	pass

func is_loaded():
	return picked_up_object != null

func is_fully_charged():
	return fully_charged

func pickup(parent: Node3D, object: RigidBody3D):
	if picked_up_object != null:
		return
	
	picked_up_object = object
	picked_up_model = picked_up_object.get_node("model")
	picked_up_object.get_parent().remove_child(picked_up_object)
	picked_up_object.freeze = true
	picked_up_object.remove_child(picked_up_model)
	fully_charged = false
	charge_timer = 0
	parent.add_child(picked_up_model)

func charge(delta):
	charge_timer += delta
	if charge_timer >= CHARGE_TIME:
		fully_charged = true
		charge_timer = CHARGE_TIME
	
	Utils.ui.set_charge_bar(charge_timer / CHARGE_TIME)

func release(parent: Node3D, position: Vector3):
	if picked_up_object == null:
		return
	
	var projectile = picked_up_object
	picked_up_object = null
	parent.remove_child(picked_up_model)
	projectile.add_child(picked_up_model)
	picked_up_model = null
	projectile.freeze = false
	# projectile = ProjectileObject.instantiate()
	var camera_basis = Utils.camera.get_basis()
	var camera_direction = Utils.camera.get_direction()
	projectile.position = position - camera_basis.z * 1 + Vector3.UP * 2
	projectile.quaternion = Quaternion.IDENTITY
	projectile.shoot(camera_direction, SHOOT_SPEED_MIN + (charge_timer / CHARGE_TIME) * (SHOOT_SPEED_MAX - SHOOT_SPEED_MIN))
	Utils.root.add_child(projectile)
	
	Utils.ui.set_charge_bar(0)
