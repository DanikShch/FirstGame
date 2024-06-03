extends CanvasLayer

@onready var coin_text = $Control/PanelContainer/HBoxContainer/CoinText
@onready var wood_text = $Control/PanelContainer/HBoxContainer/WoodText
@onready var stone_text = $Control/PanelContainer/HBoxContainer/StoneText
@onready var gem_text = $Control/PanelContainer/HBoxContainer/GemText

func _process(delta):
	coin_text.text = str(Inventory.coin)
	wood_text.text = str(Inventory.wood)
	stone_text.text = str(Inventory.stone)
	gem_text.text = str(Inventory.gem)
