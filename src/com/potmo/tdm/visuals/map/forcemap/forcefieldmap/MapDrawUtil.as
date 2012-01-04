package com.potmo.tdm.visuals.map.forcemap.forcefieldmap
{
	import com.potmo.util.color.RGBColor;
	import com.potmo.util.math.StrictMath;

	import flash.display.BitmapData;

	public class MapDrawUtil
	{

		public static function drawForce( canvas:BitmapData, x:uint, y:uint, force:Force ):void
		{
			// note this is using platform dependent Math but does not matter since its just display
			var rad:Number = StrictMath.atan2( force.x, force.y );
			var r:int = ( StrictMath.cos( rad ) * 127.0 + 128.0 ) * StrictMath.min( force.length, 1 );
			var g:int = ( StrictMath.cos( rad + 2.0943951 ) * 127.0 + 128.0 ) * StrictMath.min( force.length, 1 );
			var b:int = ( StrictMath.cos( rad + 4.1887902 ) * 127.0 + 128.0 ) * StrictMath.min( force.length, 1 );

			canvas.setPixel( x, y, RGBColor.uintFromRGB( r, g, b ) );
		}
	}
}
