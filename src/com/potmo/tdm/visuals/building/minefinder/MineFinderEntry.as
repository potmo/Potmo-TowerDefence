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

	internal class MineFinderEntry
	{

		private static const CLOSEST_DIST_FROM_ENDPOINT:Number = 50;

		private var _steps:int;
		private var _direction:MapMovingDirection;


		public function MineFinderEntry( direction:MapMovingDirection )
		{
			_direction = direction;
			_steps = 0;
		}


		internal function calculateSteps( constructionSite:ConstructionSite, mine:Mine, map:MapBase ):void
		{
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

			var bestDistance:Number = Number.MAX_VALUE;

			// step while far enough from endpoint
			for ( var i:int = 0; i < 10000; i++ )
			{

				if ( StrictMath.distSquared( x, y, endpointAX, endpointAY ) <= CLOSEST_DIST_FROM_ENDPOINT )
				{
					Logger.log( "Close to p0 endpoint" );
					return;
				}
				else if ( StrictMath.distSquared( x, y, endpointBX, endpointBY ) <= CLOSEST_DIST_FROM_ENDPOINT )
				{
					Logger.log( "Close to p1 endpoint" );
					return;
				}

				mapForce = map.getMapPathForce( x, y, _direction );
				areaForce = map.getMapUnwalkableAreaForce( x, y, _direction );

				mapForce.add( areaForce );

				x += mapForce.x * 10;
				y += mapForce.y * 10;

				var distToMine:Number = StrictMath.distSquared( x, y, mineX, mineY );

				if ( distToMine < bestDistance )
				{
					bestDistance = distToMine;
					_steps = i;
				}

			}

			Logger.info( "Iterated too many times" );
			return;

		}


		internal static function closestDistanceComparator( a:MineFinderEntry, b:MineFinderEntry ):int
		{
			var d:int = b._steps - a._steps;

			if ( d == 0 )
			{
				return 0;
			}
			else
			{
				return d / StrictMath.abs( d );
			}
		}


		internal function getSteps():int
		{
			return _steps;
		}


		internal function getDirection():MapMovingDirection
		{
			return _direction;
		}

	}
}
