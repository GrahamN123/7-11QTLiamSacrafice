extends Node2D

@onready var message_label = $CanvasLayer/Message
@onready var car = $Car

func _ready():
	var stations = get_tree().get_nodes_in_group("stations")
	# assign friendly names in order found
	if stations.size() >= 1:
		stations[0].set("station_name", "7/11")
	if stations.size() >= 2:
		stations[1].set("station_name", "QuikTrip")
	for station in stations:
		station.connect("reached_station", Callable(self, "_on_reached_station"))
	message_label.text = "Drive to 7/11 or QuikTrip. Use arrow keys to steer."

func _on_reached_station(name):
	message_label.text = "You made it to %s!" % name
	yield(get_tree().create_timer(1.5), "timeout")
	get_tree().change_scene_to_file("res://Main.tscn")
