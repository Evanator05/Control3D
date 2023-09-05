@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Control3D", "MeshInstance3D", preload("res://addons/control3d/Control3D.gd"), preload("res://addons/control3d/Node3D.svg"))


func _exit_tree():
	remove_custom_type("Control3D")
