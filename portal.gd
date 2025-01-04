extends Area3D


@export var connect_portal: Area3D
var teleported_to: bool = false
var offset = Vector3(0 , 0 , 3)


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Bob" && not teleported_to:
		var destination = connect_portal.global_transform.origin
		connect_portal.teleported_to = true
		body.global_transform.origin = destination
		


func _on_body_exited(body: Node3D) -> void:
	teleported_to = false
