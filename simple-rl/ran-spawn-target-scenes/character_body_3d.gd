
extends CharacterBody3D

const SPEED = 5.0
var spawn_y = 0.851

@export var ai_controller_3d: Node3D
@export var target: Area3D


@onready var agent_point_2: Node3D = $"../AgentPoint2"
@onready var agent_point_1: Node3D = $"../AgentPoint1"

@export var target_point_1: Node3D
@export var target_point_2: Node3D

@export var max_episode_steps: int = 120*60
@export var timeout_penalty: float = 0.25

var step_count: int = 0


func _ready() -> void:
	randomize()
	reset_scene()

func get_random_point(p1: Node3D, p2: Node3D) -> Vector3:
	randomize()
	var x_value: float = randf_range(p1.position.x, p2.position.x)
	var y_value: float = 0.851
	var z_value: float = randf_range(p1.position.z, p2.position.z)
	
	return Vector3(x_value, y_value, z_value)

func _physics_process(delta: float) -> void:
	step_count += 1
	
	if step_count >= max_episode_steps:
		ai_controller_3d.reward -= timeout_penalty
		reset_scene()
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = ai_controller_3d.move.x
	velocity.z = ai_controller_3d.move.y

	move_and_slide()

func reset_scene() -> void:
	step_count = 0
	velocity = Vector3.ZERO
	position = get_random_point(agent_point_1, agent_point_2)
	target.position = get_random_point(target_point_1, target_point_2)
	ai_controller_3d.reset()

	
func _on_target_body_entered(_body: Node3D) -> void:
	reset_scene()
	ai_controller_3d.reward += 1.0

func _on_wall_body_entered(_body: Node3D) -> void:
	ai_controller_3d.reward -= 1.0
	reset_scene()
	ai_controller_3d.reset()
