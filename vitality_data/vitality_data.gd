class_name VitalityData extends Resource

@export_category("Vitality Stats")
@export var max_health:int = 100
@export var min_health:int
@export var invincibility_time:float

signal health_changed(health:int)
signal health_increased()
signal health_decreased()
signal died()
signal invincibility_started()
signal invincibility_stopped()
signal max_health_changed(max_health:int)
signal min_health_changed(min_health:int)

var current_health:int :
	set(val):
		var old_health = current_health
		current_health = clamp(val, min_health, max_health)

		match sign(current_health - old_health):
			1:
				health_increased.emit()
			-1:
				health_decreased.emit()
			0:
				print("Health unchanged.")
			_:
				print("Something went wrong in calculating health.")

		health_changed.emit(current_health)
		if current_health <= min_health:
			died.emit()
		emit_changed()

var is_hurt:bool = false :
	set(val):
		if val == is_hurt:
			pass
		is_hurt = val

		match is_hurt:
			true:
				invincibility_started.emit()
			false:
				invincibility_stopped.emit()
			_:
				print("Fatal is_hurt error, turned out to be neither true or false")
		emit_changed()

func _init() -> void:
	if max_health == min_health:
		print("WARNING: MAXIMUM HEALTH IS EQUAL TO MINIMUM HEALTH")
	current_health = max_health

func set_max_health(new_value:int) -> void:
	max_health = new_value
	max_health_changed.emit(max_health)

func set_min_health(new_value:int) -> void:
	min_health = new_value
	min_health_changed.emit(min_health)

func set_invincibility_time(new_value:float) -> void:
	invincibility_time = new_value
