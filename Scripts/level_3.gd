extends Node2D

@onready var killbox: Area2D = $Killbox3
@onready var background: CanvasLayer = $Background3
@onready var terrain: TileMapLayer = $TileMapLayer3

#@onready

func activate() -> void:
	show()
	killbox.monitoring = true
	background.show()
	terrain.enabled = true

func deactivate() -> void:
	hide()
	killbox.monitoring = false
	background.hide()
	terrain.enabled = false

func show_portal() -> void:
	pass
