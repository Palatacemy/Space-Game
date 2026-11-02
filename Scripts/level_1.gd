extends Node2D

@onready var killbox: Area2D = $Killbox1
@onready var background: CanvasLayer = $Background1
@onready var terrain: TileMapLayer = $TileMapLayer1
@onready var gem_1: Area2D = $Gem1
@onready var gem_2: Area2D = $Gem2
@onready var gem_3: Area2D = $Gem3
@onready var gem_4: Area2D = $Gem4
@onready var gem_5: Area2D = $Gem5
@onready var buff_1_1: Area2D = $Buff1_1
@onready var buff_2_1: Area2D = $Buff2_1
@onready var portal_1: Area2D = $Portal1

func activate() -> void:
	show()
	killbox.set_deferred("monitoring", true)
	background.show()
	terrain.enabled = true
	gem_1.set_deferred("monitoring", true)
	gem_1.set_deferred("monitorable", true)
	gem_1.show()
	gem_2.set_deferred("monitoring", true)
	gem_2.set_deferred("monitorable", true)
	gem_2.show()
	gem_3.set_deferred("monitoring", true)
	gem_3.set_deferred("monitorable", true)
	gem_3.show()
	gem_4.set_deferred("monitoring", true)
	gem_4.set_deferred("monitorable", true)
	gem_4.show()
	gem_5.set_deferred("monitoring", true)
	gem_5.set_deferred("monitorable", true)
	gem_5.show()
	buff_1_1.set_deferred("monitoring", true)
	buff_1_1.set_deferred("monitorable", true)
	buff_1_1.show()
	buff_2_1.set_deferred("monitoring", true)
	buff_2_1.set_deferred("monitorable", true)
	buff_2_1.show()
	portal_1.set_deferred("monitoring", false)
	portal_1.set_deferred("monitoring", false)
	portal_1.particles.emitting = false
	portal_1.hide()

func deactivate() -> void:
	hide()
	killbox.set_deferred("monitoring", false)
	background.hide()
	terrain.enabled = false
	gem_1.set_deferred("monitoring", false)
	gem_1.set_deferred("monitorable", false)
	gem_1.hide()
	gem_2.set_deferred("monitoring", false)
	gem_2.set_deferred("monitorable", false)
	gem_2.hide()
	gem_3.set_deferred("monitoring", false)
	gem_3.set_deferred("monitorable", false)
	gem_3.hide()
	gem_4.set_deferred("monitoring", false)
	gem_4.set_deferred("monitorable", false)
	gem_4.hide()
	gem_5.set_deferred("monitoring", false)
	gem_5.set_deferred("monitorable", false)
	gem_5.hide()
	buff_1_1.set_deferred("monitoring", false)
	buff_1_1.set_deferred("monitorable", false)
	buff_1_1.hide()
	buff_2_1.set_deferred("monitoring", false)
	buff_2_1.set_deferred("monitorable", false)
	buff_2_1.hide()
	portal_1.set_deferred("monitoring", false)
	portal_1.set_deferred("monitorable", false)
	portal_1.particles.emitting = false
	portal_1.hide()

func show_portal() -> void:
	portal_1.set_deferred("monitoring", true)
	portal_1.set_deferred("monitorable", true)
	portal_1.particles.emitting = true
	portal_1.show()
