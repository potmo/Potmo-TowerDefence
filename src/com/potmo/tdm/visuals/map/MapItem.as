package com.potmo.tdm.visuals.map
{
	import com.potmo.p2d.atlas.animation.SpriteAtlasSequence;
	import com.potmo.p2d.renderer.Renderable;
	import com.potmo.tdm.display.BasicRenderItem;
	import com.potmo.tdm.display.ZSortableRenderable;
	import com.potmo.util.text.TextUtil;

	public class MapItem extends BasicRenderItem implements ZSortableRenderable
	{

		public function MapItem( graphicsSequence:SpriteAtlasSequence )
		{
			super( graphicsSequence );

		}


		public function goToFrame( frame:int ):void
		{
			currentFrame = graphicsSequence.getNthFrame( frame );
		}


		public function getZDepth():int
		{
			return y;
		}

	}
}
