class_name Player
extends Actor


signal energy_updated(energy)
signal died

export var jump_interrupt_factor := 0.6
export var energy_depletion_rate := 0.1
export var energy_per_corn := 5.0
export var max_energy := 100.0

var dead := false
var energy := max_energy setget set_energy, get_energy
var won := false

onready var collect_sound: AudioStreamPlayer = $CollectSound
onready var death_particles: Particles2D = $DeathParticles
onready var death_sound: AudioStreamPlayer = $DeathSound
onready var jump_sound: AudioStreamPlayer = $JumpSound
onready var platform_detector: RayCast2D = $PlatformDetector
onready var sprite: AnimatedSprite = $AnimatedSprite
onready var win_particles: Particles2D = $WinParticles


func _process(delta: float) -> void:
	if dead or won:
		return
	
	self.energy -= energy_depletion_rate
	if self.energy == 0:
		die()


func _physics_process(delta: float) -> void:
	if dead or won:
		return
	
	var direction := get_move_direction()
	
	var is_jump_interrupted: bool = Input.is_action_just_released("jump") and _velocity.y < 0
	
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	
	var snap_vector = Vector2.DOWN if direction.y == 0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(
			_velocity, snap_vector, FLOOR_NORMAL, not platform_detector.is_colliding()
	)
	
	if direction.x != 0:
		sprite.flip_h = direction.x < 0
		
	if direction.y != 0:
		jump_sound.play()
	
	var animation = get_animation()
	if animation != sprite.animation:
		sprite.play(animation)


func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1 if is_on_floor() and Input.is_action_just_pressed("jump") else 0
	)


func calculate_move_velocity(
	linear_velocity: Vector2,
	direction: Vector2,
	speed: Vector2,
	is_jump_interrupted: bool
) -> Vector2:
	var velocity := linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y *= jump_interrupt_factor
	return velocity


func get_animation() -> String:
	var animation = "idle"
	if not is_on_floor() and _velocity.y != 0:
		animation = "jump"
	elif _velocity.x != 0:
		animation = "walk"
	return animation


func set_energy(value: float) -> void:
	energy = clamp(value, 0, max_energy)
	emit_signal("energy_updated", energy)


func get_energy() -> float:
	return energy


func _on_CornDetector_area_entered(area: Area2D) -> void:
	self.energy += energy_per_corn
	collect_sound.play()


func _on_EnemyDetector_body_entered(body: Node) -> void:
	die()


func win() -> void:
	won = true
	win_particles.emitting = true


func die() -> void:
	if won:
		return
	
	dead = true
	death_particles.emitting = true
	death_sound.play()
	sprite.visible = false
	
	yield(death_sound, "finished")
	
	PlayerStats.deaths += 1
	emit_signal("died")


func reset() -> void:
	dead = false
	sprite.visible = true
	energy = max_energy
