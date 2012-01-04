package com.potmo.tdm.visuals.map.forcemap.forcefieldmap
{
	import com.potmo.tdm.visuals.map.forcemap.forcefieldmap.composer.IForceComposer;
	import com.potmo.util.image.BitmapUtil;
	import com.potmo.util.math.StrictMath;

	import flash.display.BitmapData;

	public class ForceFieldUnit
	{

		private var _x:Number;
		private var _y:Number;
		private var _velx:Number;
		private var _vely:Number;
		private var _speedFactor:Number;

		private static const INFLUENCE_RADIUS:Number = 0.5;
		private static const INFLUENCE_RADIUS_HALF:Number = INFLUENCE_RADIUS / 2;


		public function ForceFieldUnit()
		{

			//FIXME: Do not hardcode random initial positions for FlowFieldUnits
			_x = 1 + Math.random() * ( 20 - 2 );
			_y = 1 + Math.random() * ( 20 - 2 );
			_velx = 0;
			_vely = 0;
			//_speedFactor = ( Math.random() * 10 + 0.5 ) * 0.03;
			_speedFactor = 0.6;
		}


		public function draw( canvas:BitmapData, horizontalTileSize:int, verticalTileSize:int ):void
		{
			// draw unit
			BitmapUtil.drawCirlce( _x * horizontalTileSize, _y * verticalTileSize, INFLUENCE_RADIUS_HALF * horizontalTileSize, 0xFFFFFF, canvas );
			//draw velocity
			//BitmapUtil.efla( _x * horizontalTileSize, _y * verticalTileSize, _x * horizontalTileSize + _velx * 100, _y * verticalTileSize + _vely * 100, 0xFFFFFF, canvas );
			//draw force influence area
			//BitmapUtil.drawCirlce( _x * horizontalTileSize, _y * verticalTileSize, INFLUENCE_RADIUS * horizontalTileSize, 0xAAAAAA, canvas );
		}


		public function update( forceCalculator:IForceComposer ):void
		{
			var force:Force = forceCalculator.getFlowForce( _x, _y );
			_velx = _velx * 0.1 + force.x * 0.1 * _speedFactor;
			_vely = _vely * 0.1 + force.y * 0.1 * _speedFactor;
			_x += _velx;
			_y += _vely;

		/*x = Math.max( 0, Math.min( horizontalTileSize * ForceFieldMap.HORIZONTAL_TILES, x ) );
		   y = Math.max( 0, Math.min( verticalTileSize * ForceFieldMap.VERTICAL_TILES, y ) );*/
		}


		public function isInsideInfluenceArea( x:Number, y:Number ):Boolean
		{
			//early exit check
			if ( x > _x - INFLUENCE_RADIUS && _x + INFLUENCE_RADIUS > x )
			{
				if ( y > _y - INFLUENCE_RADIUS && _y + INFLUENCE_RADIUS > y )
				{
					return StrictMath.isCloseEnough( x, y, _x, _y, INFLUENCE_RADIUS );
				}
			}
			return false;

		}


		public function getForceInfluencalForce( x:Number, y:Number ):Force
		{

			/*var p0:Point = new Point( x, y );
			   var p1:Point = new Point( this._x, this._y );

			   var diff:Point = p1.subtract( p0 );
			   diff.normalize( 1.0 );

			   var dist:Number = Point.distance( p0, p1 );
			 */

			var dx:Number = _x - x;
			var dy:Number = _y - y;

			if ( dx == 0 && dy == 0 )
			{
				return new Force( 0, 0 );
			}

			// get length
			var dist:Number = StrictMath.get2DLength( dx, dy );

			// normalize
			dx /= dist;
			dy /= dist;

			var force:Number = -( 1.0 - dist / INFLUENCE_RADIUS );
			force *= 5;

			return new Force( dx * force, dy * force );
		}


		public function getX():Number
		{
			return this._x;
		}


		public function getY():Number
		{
			return this._y;
		}
	}
}
