extends Node

var root: Node3D = null
var ui: Control = null
var camera: Node3D = null

func _ready():
	root = get_tree().root.get_node("Game")
	ui = root.get_node("UI")
	camera = root.get_node("Camera")
