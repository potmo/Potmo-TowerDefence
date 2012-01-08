package com.potmo.tdm.visuals.map.tilemap.forcefieldmap.unit
{
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.ForceFieldUnit;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.IForceFieldMap;
	import com.potmo.util.color.RGBColor;
	import com.potmo.util.math.StrictMath;

	import flash.display.BitmapData;

	public class UnitForceFieldMap implements IForceFieldMap
	{
		private var units:Vector.<ForceFieldUnit>;


		public function UnitForceFieldMap( units:Vector.<ForceFieldUnit> )
		{
			this.units = units;
		}


		public function getForce( x:Number, y:Number ):Force
		{
			var force:Force = new Force();

			for each ( var unit:ForceFieldUnit in units )
			{
				if ( unit.isInsideInfluenceArea( x, y ) )
				{
					force.add( unit.getForceInfluencalForce( x, y ) );
				}
			}
			return force;
		}


		public function draw( canvas:BitmapData, horizontalTileSize:int, verticalTileSize:int ):void
		{

			canvas.lock();

			for ( var x:int = 0; x < canvas.width; x++ )
			{
				for ( var y:int = 0; y < canvas.width; y++ )
				{
					var f:Force = this.getForce( x / horizontalTileSize, y / verticalTileSize );

					// note this is using platform dependent Math but does not matter since its just display
					var rad:Number = StrictMath.atan2( f.x, f.y );
					var r:int = ( StrictMath.cos( rad ) * 127.0 + 128.0 ) * StrictMath.min( f.length, 1 );
					var g:int = ( StrictMath.cos( rad + 2.0943951 ) * 127.0 + 128.0 ) * StrictMath.min( f.length, 1 );
					var b:int = ( StrictMath.cos( rad + 4.1887902 ) * 127.0 + 128.0 ) * StrictMath.min( f.length, 1 );

					canvas.setPixel( x, y, RGBColor.uintFromRGB( r, g, b ) );
				}
			}
			canvas.unlock();
		}

	}
}
