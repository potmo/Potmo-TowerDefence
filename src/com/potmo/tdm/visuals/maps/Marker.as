package com.potmo.tdm.visuals.maps
{
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;

	import flash.display.MovieClip;

	public class Marker extends MapItem
	{
		private static var ASSET:TextureAnimationCacheObject;


		public function Marker()
		{

			if ( !ASSET )
			{
				var CLIP:flash.display.MovieClip = new flash.display.MovieClip();
				CLIP.graphics.lineStyle( 1, 0xFFFFFF, 1 );
				CLIP.graphics.drawCircle( 0, 0, 3 );
				ASSET = new TextureAnimationCacheObject( CLIP );
			}
			super( ASSET );
		}
	}
}
