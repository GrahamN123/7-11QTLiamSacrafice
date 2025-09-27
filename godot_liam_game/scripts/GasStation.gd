extends Area2D

@export var station_name: String = "Station"
signal reached_station(name)

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Car":
		emit_signal("reached_station", station_name)
