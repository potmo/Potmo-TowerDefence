package com.potmo.tdm.visuals.maps
{
	import com.potmo.tdm.asset.map.DeployFlag_Asset;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;

	public class DeployFlag extends MapItem
	{

		private static const asset:TextureAnimationCacheObject = new TextureAnimationCacheObject( new DeployFlag_Asset() );


		public function DeployFlag()
		{
			super( asset );
		}
	}
}
