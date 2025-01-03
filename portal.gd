extends Area3D


@export var connect_portal: Area3D
var offset = Vector3(0 , 0 , 3)


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Bob":
		var destination = connect_portal.global_transform.origin
		body.global_transform.origin = destination + offset
		
