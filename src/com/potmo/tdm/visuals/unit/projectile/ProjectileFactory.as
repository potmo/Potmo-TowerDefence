package com.potmo.tdm.visuals.unit.projectile
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;

	public class ProjectileFactory
	{
		private var arrowPool:Vector.<Projectile> = new Vector.<Projectile>();
		private var _spriteAtlas:SpriteAtlas;


		public function ProjectileFactory( spriteAtlas:SpriteAtlas )
		{
			this._spriteAtlas = spriteAtlas;
		}


		public function getProjectile( type:ProjectileType ):Projectile
		{
			var projectile:Projectile;
			var pool:Vector.<Projectile> = getPool( type );

			projectile = getProjectileFromPool( type, pool );
			return projectile;
		}


		private function getPool( type:ProjectileType ):Vector.<Projectile>
		{
			switch ( type )
			{
				case ProjectileType.ARROW:
				{
					return arrowPool;
				}
				default:
				{
					throw new Error( "There are no pool for type: " + type );
				}
			}
		}


		private function getProjectileFromPool( type:ProjectileType, pool:Vector.<Projectile> ):Projectile
		{
			if ( pool.length == 0 )
			{
				populateList( pool, type, 10 );
			}

			return pool.pop();

		}


		public function returnProjectile( projectile:Projectile ):void
		{
			var pool:Vector.<Projectile> = getPool( projectile.getType() );
			projectile.reset();
			pool.push( projectile );

		}


		private function populateList( pool:Vector.<Projectile>, type:ProjectileType, count:int ):void
		{
			var clazz:Class = type.getClass();
			var projectile:Projectile;

			while ( count > 0 )
			{
				projectile = new clazz( _spriteAtlas );
				pool.push( projectile );
				count--;
			}
		}
	}
}
