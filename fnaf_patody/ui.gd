extends Control

func update_ui(time_text: String, energy_text: String):
	$TimeLabel.text = time_text
	$EnergyLabel.text = energy_text
