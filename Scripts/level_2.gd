extends Node2D

@onready var killbox: Area2D = $Killbox2
@onready var background: CanvasLayer = $Background2
@onready var terrain: TileMapLayer = $TileMapLayer2
@onready var pushbox_1: Area2D = $Pushbox1
@onready var pushbox_2: Area2D = $Pushbox2
@onready var gem_6: Area2D = $Gem6
@onready var gem_7: Area2D = $Gem7
@onready var gem_8: Area2D = $Gem8
@onready var gem_9: Area2D = $Gem9
@onready var gem_10: Area2D = $Gem10
@onready var buff_1_2: Area2D = $Buff1_2
@onready var portal_2: Area2D = $Portal2

func activate() -> void:
	show()
	killbox.monitoring = true
	background.show()
	terrain.enabled = true
	pushbox_1.set_deferred("monitoring", true)
	pushbox_1.set_deferred("monitorable", true)
	pushbox_2.set_deferred("monitoring", true)
	pushbox_2.set_deferred("monitorable", true)
	gem_6.set_deferred("monitoring", true)
	gem_6.set_deferred("monitorable", true)
	gem_6.show()
	gem_7.set_deferred("monitoring", true)
	gem_7.set_deferred("monitorable", true)
	gem_7.show()
	gem_8.set_deferred("monitoring", true)
	gem_8.set_deferred("monitorable", true)
	gem_8.show()
	gem_9.set_deferred("monitoring", true)
	gem_9.set_deferred("monitorable", true)
	gem_9.show()
	gem_10.set_deferred("monitoring", true)
	gem_10.set_deferred("monitorable", true)
	gem_10.show()
	buff_1_2.set_deferred("monitoring", true)
	buff_1_2.set_deferred("monitorable", true)
	buff_1_2.show()
	portal_2.set_deferred("monitoring", false)
	portal_2.set_deferred("monitorable", false)
	portal_2.particles.emitting = false
	portal_2.hide()

func deactivate() -> void:
	hide()
	killbox.monitoring = false
	background.hide()
	terrain.enabled = false
	pushbox_1.set_deferred("monitoring", false)
	pushbox_1.set_deferred("monitorable", false)
	pushbox_2.set_deferred("monitoring", false)
	pushbox_2.set_deferred("monitorable", false)
	gem_6.set_deferred("monitoring", false)
	gem_6.set_deferred("monitorable", false)
	gem_6.hide()
	gem_7.set_deferred("monitoring", false)
	gem_7.set_deferred("monitorable", false)
	gem_7.hide()
	gem_8.set_deferred("monitoring", false)
	gem_8.set_deferred("monitorable", false)
	gem_8.hide()
	gem_9.set_deferred("monitoring", false)
	gem_9.set_deferred("monitorable", false)
	gem_9.hide()
	gem_10.set_deferred("monitoring", false)
	gem_10.set_deferred("monitorable", false)
	gem_10.hide()
	buff_1_2.set_deferred("monitoring", false)
	buff_1_2.set_deferred("monitorable", false)
	buff_1_2.hide()
	portal_2.set_deferred("monitoring", false)
	portal_2.set_deferred("monitorable", false)
	portal_2.particles.emitting = false
	portal_2.hide()

func show_portal() -> void:
	
	portal_2.set_deferred("monitoring", true)
	portal_2.set_deferred("monitorable", true)
	portal_2.particles.emitting = true
	portal_2.show()
