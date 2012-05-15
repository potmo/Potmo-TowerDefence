package com.potmo.tdm.visuals.building.minefinder
{
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.building.variant.ConstructionSite;
	import com.potmo.tdm.visuals.building.variant.Mine;
	import com.potmo.tdm.visuals.map.MapBase;
	import com.potmo.tdm.visuals.map.MapMovingDirection;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	public class MineDirections
	{

		private static const CLOSEST_DIST_FROM_ENDPOINT:Number = StrictMath.sqr( 30 );
		private static const MIN_DIST_TO_ACCESS_MINE:Number = StrictMath.sqr( 200 );

		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _steps:int = 0;
		private var _direction:MapMovingDirection;
		private var _mine:Mine;
		private var _bestDistance:Number;


		public function MineDirections( direction:MapMovingDirection )
		{
			_direction = direction;
		}


		internal function calculateSteps( constructionSite:ConstructionSite, mine:Mine, map:MapBase ):void
		{

			_mine = mine;

			// start at construction site
			var constructionSiteX:Number = constructionSite.getX();
			var constructionSiteY:Number = constructionSite.getY();

			var mineX:Number = mine.getX();
			var mineY:Number = mine.getY();

			var endpointAX:Number = map.getPlayer0EndPoint().x;
			var endpointAY:Number = map.getPlayer0EndPoint().y;

			var endpointBX:Number = map.getPlayer1EndPoint().x;
			var endpointBY:Number = map.getPlayer1EndPoint().y;

			var x:Number = constructionSiteX;
			var y:Number = constructionSiteY;

			var mapForce:Force;
			var areaForce:Force;

			_bestDistance = Number.MAX_VALUE;
			_steps = int.MAX_VALUE;

			// step while far enough from endpoint
			for ( var i:int = 0; i < 10000; i++ )
			{

				var reachedEnd1:Boolean = StrictMath.distSquared( x, y, endpointAX, endpointAY ) <= CLOSEST_DIST_FROM_ENDPOINT;
				var reachedEnd2:Boolean = StrictMath.distSquared( x, y, endpointBX, endpointBY ) <= CLOSEST_DIST_FROM_ENDPOINT;

				if ( reachedEnd1 || reachedEnd2 )
				{
					if ( _steps == int.MAX_VALUE )
					{
						Logger.error( "Did not find any mine at all" );
					}
					else
					{
						Logger.info( "Found mine after: " + _steps );
					}
					return;
				}

				mapForce = map.getMapPathForce( x, y, _direction );
				areaForce = map.getMapUnwalkableAreaForce( x, y, _direction );

				mapForce.add( areaForce );
				mapForce.normalize();

				x += mapForce.x * 15;
				y += mapForce.y * 15;

				var distToMine:Number = StrictMath.distSquared( x, y, mineX, mineY );

				if ( ( distToMine < _bestDistance ) && ( distToMine <= MIN_DIST_TO_ACCESS_MINE ) )
				{
					_bestDistance = distToMine;
					_steps = i;
					_x = x;
					_y = y;
				}

			}

			Logger.error( "Iterated too many times" );
			return;

		}


		internal static function closestDistanceComparator( a:MineDirections, b:MineDirections ):int
		{
			var d:int = a._steps - b._steps;

			if ( d == 0 )
			{
				return 0;
			}
			else
			{
				return d / StrictMath.abs( d );
			}
		}


		public function getSteps():int
		{
			return _steps;
		}


		public function getDistanceFromTrailToMine():Number
		{
			return _bestDistance;
		}


		public function getDirection():MapMovingDirection
		{
			return _direction;
		}


		public function getX():Number
		{
			return _x;
		}


		public function getY():Number
		{
			return _y;
		}


		public function getMine():Mine
		{
			return _mine;
		}
	}
}
