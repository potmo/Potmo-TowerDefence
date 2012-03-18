package com.potmo.tdm.visuals.hud
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.display.BasicRenderItem;
	import com.potmo.tdm.display.RenderContainer;
	import com.potmo.tdm.player.OrderManager;
	import com.potmo.tdm.visuals.ScreenSize;
	import com.potmo.util.logger.Logger;

	public class HudBase extends RenderContainer
	{
		private static const BUTTON_SPACING:int = 10;
		private static const BUTTON_LEFT_PADDING:int = 120;
		private static const BUTTON_RIGHT_PADDING:int = 20;
		private static const BUTTON_BOTTOM_SPACING:int = 10;

		private var leftButtons:Vector.<BasicRenderItem> = new Vector.<BasicRenderItem>();
		private var rightButtons:Vector.<BasicRenderItem> = new Vector.<BasicRenderItem>();


		public function HudBase( spriteAtlas:SpriteAtlas )
		{
			super();
		}


		public function update( gameLogics:GameLogics ):void
		{
			// override
		}


		protected function addButtonLast( button:BasicRenderItem, toLeft:Boolean = true ):void
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


		protected function addButtonFirst( button:BasicRenderItem, toLeft:Boolean = true ):void
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
			var button:BasicRenderItem;

			x = BUTTON_LEFT_PADDING;
			//y = ScreenSize.HEIGHT - BUTTON_BOTTOM_SPACING;
			y = 0 + BUTTON_BOTTOM_SPACING;

			for each ( button in leftButtons )
			{
				button.setX( x );
				x += BUTTON_SPACING + button.getWidth();
				button.setY( y );
				Logger.log( "Set left button to: " + button.getX() + "," + button.getY() );

			}

			x = ScreenSize.WIDTH - BUTTON_RIGHT_PADDING;

			for each ( button in rightButtons )
			{
				button.setX( x - button.getWidth() );
				x += -BUTTON_SPACING - button.getWidth();
				button.setY( y );
				Logger.log( "Set right button to: " + button.getX() + "," + button.getY() );

			}
		}


		public function handleClick( x:int, y:int, orderManager:OrderManager, gameLogics:GameLogics ):Boolean
		{
			return false; // override
		}


		public function clear():void
		{
			// override
		}
	}
}
