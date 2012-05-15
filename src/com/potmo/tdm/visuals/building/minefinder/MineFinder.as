package com.potmo.tdm.visuals.building.minefinder
{
	import com.potmo.tdm.visuals.building.Building;
	import com.potmo.tdm.visuals.building.variant.ConstructionSite;
	import com.potmo.tdm.visuals.building.variant.Mine;
	import com.potmo.tdm.visuals.map.MapBase;
	import com.potmo.tdm.visuals.map.MapMovingDirection;
	import com.potmo.tdm.visuals.unit.Unit;
	import com.potmo.util.logger.Logger;

	import flash.geom.Point;

	public class MineFinder
	{

		private static const MINE_CLOSE_DISTANCE:int = 200;
		private var entries:Vector.<Vector.<MineDirections>>;


		public function MineFinder( constructionSites:Vector.<ConstructionSite>, mines:Vector.<Mine>, map:MapBase )
		{

			entries = new Vector.<Vector.<MineDirections>>( constructionSites.length, true );

			// calculate the direction from each construction site to each mine
			// then sort the list in ascending order with closest first.
			for each ( var constructionSite:ConstructionSite in constructionSites )
			{
				var constructionSiteId:int = constructionSite.getConstructionSiteId().getId();
				entries[ constructionSiteId ] = new Vector.<MineDirections>();

				for each ( var mine:Mine in mines )
				{
					var entry:MineDirections = calculateBestDirectionFromConstructionSiteToMine( constructionSite, mine, map );
					entries[ constructionSiteId ].push( entry );

				}

				entries[ constructionSiteId ].sort( MineDirections.closestDistanceComparator );
			}
		}


		private function calculateBestDirectionFromConstructionSiteToMine( constructionSite:ConstructionSite, mine:Mine, map:MapBase ):MineDirections
		{
			var left:MineDirections = new MineDirections( MapMovingDirection.LEFT );
			var right:MineDirections = new MineDirections( MapMovingDirection.RIGHT );

			//TODO: It would probably be possible to just do one pass with path calculation and get all the mines directly. That would save performance
			// emulate for left
			left.calculateSteps( constructionSite, mine, map );
			right.calculateSteps( constructionSite, mine, map );

			var best:MineDirections;

			if ( left.getDistanceFromTrailToMine() == right.getDistanceFromTrailToMine() )
			{
				Logger.error( "None if the directions found any mine" );
			}
			else if ( left.getDistanceFromTrailToMine() < right.getDistanceFromTrailToMine() )
			{
				best = left;
			}
			else
			{
				best = right;
			}

			Logger.info( "site: " + constructionSite.getConstructionSiteId().getId() + " point on path: " + best.getX() + ", " + best.getY() + " mine: " + best.getMine().getX() + ", " + best.getMine().getY() + " dir: " + best.getDirection() );

			return best;

		}


		public function getDirectionToClosestMine( building:Building ):MineDirections
		{
			var closestEntries:Vector.<MineDirections> = entries[ building.getConstructionSiteId().getId() ];

			if ( closestEntries.length == 0 )
			{
				Logger.warn( "Can not find any more mines" );
				// there are not any mines left
				return null;
			}

			return closestEntries[ 0 ];

		}


		public function handleClosedMine( mine:Mine ):void
		{
			//TODO: implement report closed mine
		}

	}
}
