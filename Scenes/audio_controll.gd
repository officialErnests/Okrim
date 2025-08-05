extends AudioStreamPlayer

@export var sfx : bool = false

func _ready() -> void:
    volume_update()
    MainData.settings_changed.connect(settings_updated)

func volume_update() -> void:
    if sfx:
        volume_linear = MainData.sfx_volume / 10
    else:
        volume_linear = MainData.music_volume / 2

func settings_updated() -> void:
    volume_update()
