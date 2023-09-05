##A node used as the parent of other control nodes to display them in 3D
@tool class_name Control3D extends MeshInstance3D

##Sets size of the [QuadMesh]
@export var size:Vector2 = Vector2(1, 1) :
	set(value):
		size = value
		mesh.size = value

##Sets the billboard mode of the [QuadMesh]
@export_enum("Disabled", "Enabled", "Y-Billboard") var billboard_mode:int = 0 :
	set(value):
		billboard_mode = value
		mesh.surface_get_material(0).billboard_mode = value

func _ready() -> void:
	var subViewport := SubViewport.new()
	subViewport.name = "SubViewport"
	subViewport.disable_3d = true
	add_child(subViewport, true)
	mesh = QuadMesh.new()
	mesh.size = size
	var mat := StandardMaterial3D.new()
	mat.albedo_texture = $SubViewport.get_texture()
	mat.billboard_mode = billboard_mode
	mat.shading_mode = mat.SHADING_MODE_UNSHADED
	mesh.surface_set_material(0, mat)
	if Engine.is_editor_hint(): return
	for child in get_children():
		if child is Control:
			remove_child(child)
			$SubViewport.add_child(child)

##Gets all of the [SubViewport]s child nodes
##[codeblock]
##for child in $Control3D.getNodes():
##    child.value = 8
##[/codeblock]
func get_control_nodes(include_internal: bool = false) -> Array[Node]:
	return $SubViewport.get_children(include_internal)

func clearViewport():
	for child in get_control_nodes():
		child.queue_free()

func addControlToViewport():
		for child in get_children():
			if child is Control:
				var new = child.duplicate()
				remove_child(new)
				$SubViewport.add_child(new)

func refreshViewport():
	clearViewport()
	addControlToViewport()

func _notification(what):
	if Engine.is_editor_hint(): return
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		refreshViewport()
