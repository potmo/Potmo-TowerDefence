package com.potmo.tdm.visuals.hud
{
	import com.potmo.p2d.atlas.animation.SpriteAtlasSequence;
	import com.potmo.tdm.display.BasicRenderItem;

	public class HudButton extends BasicRenderItem
	{
		private var _enabled:Boolean;


		public function HudButton( graphicsSequence:SpriteAtlasSequence )
		{
			super( graphicsSequence );
			enable();
		}


		public function enable():void
		{
			if ( _enabled )
			{
				return;
			}
			_enabled = true;

			this.blueMultiplyer = 1.0;
			this.redMultiplyer = 1.0;
			this.greenMultiplyer = 1.0;
		}


		public function disable():void
		{
			if ( !_enabled )
			{
				return;
			}
			_enabled = false;

			this.blueMultiplyer = 0.5;
			this.redMultiplyer = 0.5;
			this.greenMultiplyer = 0.5;
		}


		public function isEnabled():Boolean
		{
			return _enabled;
		}
	}
}
