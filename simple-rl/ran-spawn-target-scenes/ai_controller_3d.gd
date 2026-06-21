extends AIController3D
@export var cube: CharacterBody3D
@export var target: Area3D

var move = Vector2.ZERO

func get_obs() -> Dictionary:
	var obs := [
		cube.position.x,
		cube.position.z,
		target.position.x,
		target.position.z
		
	]
	return {"obs": obs}

func get_reward() -> float:	
	return reward
	
func get_action_space() -> Dictionary:
	return {
		"move" : {
			"size": 2,
			"action_type": "continuous"
		}
		}
	
func set_action(action) -> void:
	move.x = action["move"][0]
	move.y = action["move"][1]
