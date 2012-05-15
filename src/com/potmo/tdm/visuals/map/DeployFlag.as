package com.potmo.tdm.visuals.map
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;

	public class DeployFlag extends MapItem
	{

		private static const SEQUENCE_NAME:String = "deployflag";


		public function DeployFlag( spriteAtlas:SpriteAtlas )
		{
			super( spriteAtlas.getSequenceByName( SEQUENCE_NAME ) );
		}

	}
}
