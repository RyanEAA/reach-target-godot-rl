extends AIController3D
@onready var dog: CharacterBody3D = $".."
@onready var target: Area3D = $"../../Target"


var move = Vector2.ZERO

func get_obs() -> Dictionary:
	var obs := [
		dog.position.x,
		dog.position.z,
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
