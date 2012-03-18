package com.potmo.tdm.visuals.unit.projectile
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;

	public class Arrow extends Projectile
	{

		private static const SEQUENCE_NAME:String = "arrow";


		public function Arrow( spriteAtlas:SpriteAtlas )
		{
			super( spriteAtlas.getSequenceByName( SEQUENCE_NAME ), ProjectileType.ARROW );
		}

	}
}
