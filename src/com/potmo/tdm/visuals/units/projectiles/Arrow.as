package com.potmo.tdm.visuals.units.projectiles
{
	import com.potmo.tdm.asset.projectile.Arrow_Asset;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;

	public class Arrow extends Projectile
	{
		private static const ASSET:TextureAnimationCacheObject = new TextureAnimationCacheObject( new Arrow_Asset() );


		public function Arrow()
		{
			super( ASSET, ProjectileType.ARROW );
		}
	}
}
