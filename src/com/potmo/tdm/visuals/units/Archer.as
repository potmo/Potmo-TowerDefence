package com.potmo.tdm.visuals.units
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.asset.unit.Archer_Asset;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;
	import com.potmo.tdm.visuals.units.projectiles.Projectile;
	import com.potmo.tdm.visuals.units.projectiles.ProjectileType;
	import com.potmo.tdm.visuals.units.settings.ArcherSetting;

	import flash.geom.Point;

	public class Archer extends FightingUnitBase
	{
		private static const ASSET:TextureAnimationCacheObject = new TextureAnimationCacheObject( new Archer_Asset() );
		private static const SETTING:ArcherSetting = new ArcherSetting();


		public function Archer()
		{
			super( ASSET, UnitType.ARCHER, SETTING );
		}


		override protected function onEngageTargetUnit( gameLogics:GameLogics ):void
		{
			var projectileTarget:Point = calculateUnitPosWhenProjectileHit( targetedUnit );
			gameLogics.shootProjectile( ProjectileType.ARROW, x, y, projectileTarget.x, projectileTarget.y );
		}


		protected function calculateUnitPosWhenProjectileHit( unit:UnitBase ):Point
		{
			var time:int = Projectile.getTimeToHitTarget( x, y, unit.x, unit.y );
			var bearing:Point = new Point( unit.x + unit.getVelx() * time, unit.y + unit.getVely() * time );
			return bearing;
		}


		override public function update( gameLogics:GameLogics ):void
		{
			super.update( gameLogics );
		}

	}
}
