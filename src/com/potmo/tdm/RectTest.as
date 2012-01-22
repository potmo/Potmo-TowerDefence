package com.potmo.tdm
{
	import com.potmo.util.image.BitmapUtil;
	import com.potmo.util.math.StrictMath;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	[SWF( backgroundColor = "0xCCCCCC", frameRate = "30", width = "960", height = "640" )]
	public class RectTest extends Sprite
	{
		private var canvas:BitmapData;
		private var rectA:Rectangle;
		private var rectB:Rectangle;


		public function RectTest()
		{
			canvas = new BitmapData( 500, 500, false );
			addChild( new Bitmap( canvas ) );

			rectA = new Rectangle( 100, 100, 100, 100 );
			rectB = new Rectangle( 50, 50, 50, 50 );

			addEventListener( Event.ENTER_FRAME, onEnterFrame );

		}


		private function onEnterFrame( event:Event ):void
		{
			rectB.x = mouseX;
			rectB.y = mouseY;
			var color:uint;
			var intersects:Boolean = StrictMath.rectIntersectsRect( rectA.x, rectA.y, rectA.width, rectA.height, rectB.x, rectB.y, rectB.width, rectB.height );
			var contains:Boolean = StrictMath.rectContainsRect( rectA.x, rectA.y, rectA.width, rectA.height, rectB.x, rectB.y, rectB.width, rectB.height );
			var pointContains:Boolean = StrictMath.rectContainsPoint( rectA.x, rectA.y, rectA.width, rectA.height, rectB.x, rectB.y );

			if ( contains )
			{
				color = 0xFF00FF00;
			}
			else
			{
				color = 0xFFFF0000;
			}

			BitmapUtil.fill( canvas, 0xFFFFFFFF );
			BitmapUtil.drawRectangle( rectA.x, rectA.y, rectA.width, rectA.height, 0xFF0000FF, canvas );

			BitmapUtil.drawRectangle( rectB.x, rectB.y, rectB.width, rectB.height, color, canvas );
		}
	}
}
