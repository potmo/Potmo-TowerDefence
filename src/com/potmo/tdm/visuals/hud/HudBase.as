package com.potmo.tdm.visuals.hud
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.OrderManager;
	import com.potmo.tdm.visuals.ScreenSize;
	import com.potmo.util.image.BitmapAnimation;
	import com.potmo.util.logger.Logger;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class HudBase extends Sprite
	{
		private static const BUTTON_SPACING:int = 10;
		private static const BUTTON_LEFT_PADDING:int = 20;
		private static const BUTTON_RIGHT_PADDING:int = 20;
		private static const BUTTON_BOTTOM_SPACING:int = 10;

		private var leftButtons:Vector.<BitmapAnimation> = new Vector.<BitmapAnimation>();
		private var rightButtons:Vector.<BitmapAnimation> = new Vector.<BitmapAnimation>();


		public function HudBase()
		{
			super();
		}


		public function update():void
		{
			// override
		}


		protected function addButtonLast( button:BitmapAnimation, toLeft:Boolean = true ):void
		{
			if ( toLeft )
			{
				leftButtons.push( button );
			}
			else
			{
				rightButtons.unshift( button );
			}

			addChild( button );

			updateButtonLayout();
		}


		protected function addButtonFirst( button:BitmapAnimation, toLeft:Boolean = true ):void
		{
			if ( toLeft )
			{
				leftButtons.unshift( button );
			}
			else
			{
				rightButtons.push( button );
			}

			addChild( button );

			updateButtonLayout();
		}


		private function updateButtonLayout():void
		{
			var x:int;
			var y:int;
			var button:BitmapAnimation;

			x = BUTTON_LEFT_PADDING;
			y = ScreenSize.HEIGHT - BUTTON_BOTTOM_SPACING;

			for each ( button in leftButtons )
			{
				button.x = x;
				x += BUTTON_SPACING + button.width;
				button.y = y - button.height;
				Logger.log( "Set left button to: " + button.x + "," + button.y );

			}

			x = ScreenSize.WIDTH - BUTTON_RIGHT_PADDING;

			for each ( button in rightButtons )
			{
				button.x = x - button.width;
				x += -BUTTON_SPACING - button.width;
				button.y = y - button.height;
				Logger.log( "Set right button to: " + button.x + "," + button.y );

			}
		}


		public function handleClick( x:int, y:int, orderManager:OrderManager, gameLogics:GameLogics ):Boolean
		{
			return false; // override
		}
	}
}
