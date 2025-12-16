extends Node

class_name ProjectileFactory

static func create_instance(name: String, spawner: Entity, damage: float, target: Entity) -> Projectile:
	match name:
		ProjectileTypes.dagger:
			var projectile: Projectile = load("res://scenes/objects/er_dagger.tscn").instantiate()
			var pos: Vector3 = spawner.collision_shape.global_position
			projectile.position = Vector3(pos.x, pos.y + 0.25, pos.z)
			projectile.origin = spawner
			projectile.is_friendly = true
			projectile.scale.x = projectile.scale.x if spawner.scale.x > 0 else -projectile.scale.x
			projectile.damage = damage
			projectile.target = target
			spawner.active_projectile = projectile
			return projectile
		
		ProjectileTypes.arrow:
			var projectile: Projectile = load("res://scenes/objects/sal_arrow.tscn").instantiate()
			var pos: Vector3 = spawner.collision_shape.global_position
			projectile.position = Vector3(pos.x, pos.y + 0.25, pos.z)
			projectile.origin = spawner
			projectile.is_friendly = true
			projectile.scale.x = projectile.scale.x if spawner.scale.x > 0 else -projectile.scale.x
			projectile.damage = damage
			projectile.target = target
			spawner.active_projectile = projectile
			return projectile
		
		ProjectileTypes.rose:
			var projectile: Projectile = load("res://scenes/objects/rose_dagger.tscn").instantiate()
			var pos: Vector3 = spawner.collision_shape.global_position
			projectile.position = Vector3(pos.x, pos.y + 0.5, pos.z)
			projectile.origin = spawner
			projectile.is_friendly = false
			projectile.scale.x = projectile.scale.x if spawner.scale.x > 0 else -projectile.scale.x
			projectile.damage = damage
			projectile.target = target
			spawner.active_projectile = projectile
			return projectile
		
		_:
			assert(false, "invalid name passed to ProjectileFactory")
			return null
