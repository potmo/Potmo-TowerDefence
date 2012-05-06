package com.potmo.tdm.visuals.building.variant
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.p2d.atlas.animation.SpriteAtlasSequence;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.BuildingBase;

	public class Mine extends BuildingBase
	{

		private static const SEQUENCE_NAME:String = "mine";


		public function Mine( spriteAtlas:SpriteAtlas )
		{
			super( spriteAtlas.getSequenceByName( SEQUENCE_NAME ) );
		}


		override public function update( gameLogics:GameLogics ):void
		{
			// we don't have to do anything while there are no miners inside
		}
	}
}
