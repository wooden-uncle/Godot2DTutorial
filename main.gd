extends Node

@export var mob_scene: PackedScene
var score

const GAME_VERSION = '0.1.0'

func _ready():
    print('main ready')
    $HUD.show_version(GAME_VERSION)

func game_over():
    $ScoreTimer.stop()
    $MobTimer.stop()
    $HUD.show_game_over()
    $Music.stop()
    $DeathSound.play()
    print('game over called')

func new_game():
    score = 0
    $Player.start($StartPosition.position)
    $StartTimer.start()
    $HUD.update_score(score)
    $HUD.show_message("Get Ready")
    get_tree().call_group("mobs", "queue_free")
    $Music.play()
    print('new game called')

func _on_score_timer_timeout():
    score += 1
    $HUD.update_score(score)
    print('score ', score)

func _on_start_timer_timeout():
    print('start timer')
    $MobTimer.start()
    $ScoreTimer.start()

func _on_mob_timer_timeout():
    print('mod timer')
    # Create a new instance of the Mob scene.
    var mob = mob_scene.instantiate()

    # Choose a random location on Path2D.
    var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
    mob_spawn_location.progress_ratio = randf()

    # Set the mob's direction perpendicular to the path direction.
    var direction = mob_spawn_location.rotation + PI / 2

    # Set the mob's position to a random location.
    mob.position = mob_spawn_location.position

    # Add some randomness to the direction.
    direction += randf_range(-PI / 4, PI / 4)
    mob.rotation = direction

    # Choose the velocity for the mob.
    var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
    mob.linear_velocity = velocity.rotated(direction)

    # Spawn the mob by adding it to the Main scene.
    add_child(mob)
    