package com.potmo.tdm.visuals.maps
{
	import com.potmo.tdm.asset.map.DeployFlag_Asset;
	import com.potmo.util.image.BitmapAnimation;
	import com.potmo.util.image.BitmapAnimationCacheObject;

	public class DeployFlag extends MapItem
	{

		private static const DEPLOY_FLAG_GRAPHICS:BitmapAnimationCacheObject = new BitmapAnimationCacheObject( new DeployFlag_Asset() );


		public function DeployFlag()
		{
			super( DEPLOY_FLAG_GRAPHICS );
		}
	}
}