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

		private static const CLOSEST_DIST_FROM_ENDPOINT:Number = 50;

		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _steps:int = 0;
		private var _direction:MapMovingDirection;
		private var _mine:Mine;


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
					_x = x;
					_y = y;
				}

			}

			Logger.info( "Iterated too many times" );
			return;

		}


		internal static function closestDistanceComparator( a:MineDirections, b:MineDirections ):int
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


		public function getSteps():int
		{
			return _steps;
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
