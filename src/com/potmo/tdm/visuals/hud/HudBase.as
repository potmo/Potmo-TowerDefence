package com.potmo.tdm.visuals.hud
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.display.BasicRenderItem;
	import com.potmo.tdm.display.RenderContainer;
	import com.potmo.tdm.player.OrderManager;
	import com.potmo.tdm.visuals.ScreenSize;

	public class HudBase extends RenderContainer
	{
		private static const BUTTON_SPACING:int = 10;
		private static const BUTTON_LEFT_PADDING:int = 120;
		private static const BUTTON_RIGHT_PADDING:int = 20;
		private static const BUTTON_BOTTOM_SPACING:int = 10;

		private var leftButtons:Vector.<HudButton> = new Vector.<HudButton>();
		private var rightButtons:Vector.<HudButton> = new Vector.<HudButton>();
		private var xOffset:int = 0;


		public function HudBase( spriteAtlas:SpriteAtlas )
		{
			super();
		}


		public function update( gameLogics:GameLogics ):void
		{
			// override
		}


		protected function addButtonLast( button:HudButton, toLeft:Boolean = true ):void
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


		protected function addButtonFirst( button:HudButton, toLeft:Boolean = true ):void
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
			var button:HudButton;

			x = xOffset + BUTTON_LEFT_PADDING;
			//y = ScreenSize.HEIGHT - BUTTON_BOTTOM_SPACING;
			y = 0 + BUTTON_BOTTOM_SPACING;

			var i:int = 0;
			var leftButtonNum:int = leftButtons.length;

			for ( i = 0; i < leftButtonNum; i++ )
			{
				button = leftButtons[ i ];
				button.setX( x );
				x += BUTTON_SPACING + button.getWidth();
				button.setY( y );

			}

			x = xOffset + ScreenSize.WIDTH - BUTTON_RIGHT_PADDING;

			var rightButtonNum:int = rightButtons.length;

			for ( i = 0; i < rightButtonNum; i++ )
			{
				button = rightButtons[ i ];
				button.setX( x - button.getWidth() );
				x += -BUTTON_SPACING - button.getWidth();
				button.setY( y );

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


		public function setX( xOffset:int ):void
		{
			this.xOffset = xOffset;
			this.updateButtonLayout();
		}
	}
}
