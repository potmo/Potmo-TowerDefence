package com.potmo.tdm.visuals.building
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.GameView;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.building.minefinder.MineDirections;
	import com.potmo.tdm.visuals.building.minefinder.MineFinder;
	import com.potmo.tdm.visuals.building.variant.ConstructionSite;
	import com.potmo.tdm.visuals.building.variant.Mine;
	import com.potmo.tdm.visuals.map.MapBase;
	import com.potmo.tdm.visuals.map.MapMovingDirection;
	import com.potmo.util.math.StrictMath;

	import flash.geom.Point;

	public class BuildingManager
	{
		private var _buildings:Vector.<Building> = new Vector.<Building>();
		private var _buildingFactory:BuildingFactory;
		private var _mineFinder:MineFinder;


		public function BuildingManager( buildingFactory:BuildingFactory )
		{
			this._buildingFactory = buildingFactory;
		}


		public function update( gameLogics:GameLogics ):void
		{
			var length:int = _buildings.length;

			for ( var i:int = 0; i < length; i++ )
			{
				_buildings[ i ].update( gameLogics );
			}

		}


		/**
		 * Make a building to another type
		 * This is typically done when transforming a constructionsite to a tower
		 * or when demolishing a tower making it a construction site
		 */
		public function swapBuilding( building:Building, newBuilding:Building, gameLogics:GameLogics ):Building
		{
			var map:MapBase = gameLogics.getMap();

			var owner:Player = building.getOwningPlayer();

			var index:int = _buildings.indexOf( building );

			if ( index == -1 )
			{
				throw new Error( "Building does not exist" );
			}

			// remove the old
			_buildings.splice( index, 1 );

			var gameView:GameView = gameLogics.getGameView();
			gameView.removeBuilding( building );

			// add the new
			_buildings.push( newBuilding );
			gameView.addBuilding( newBuilding );

			//TODO: Initial deploy flag position should be calculated better than this 
			newBuilding.setDeployFlag( newBuilding.getX(), newBuilding.getY() + 10, gameLogics );

			_buildingFactory.returnBuilding( building, gameLogics );

			return newBuilding;
		}


		public function buildBuildingOfTypeOnConstructionSite( type:BuildingType, constructionSite:ConstructionSite, gameLogics:GameLogics ):void
		{

			var newBuilding:Building = constructionSite.buildBuildingOfType( type, _buildingFactory, gameLogics );
			swapBuilding( constructionSite, newBuilding, gameLogics );
		}


		public function upgradeBuilding( building:Building, gameLogics:GameLogics ):void
		{

			//TODO: Upgrade all the units as well when updgrading building
			var newBuilding:Building = building.getUpgrade( _buildingFactory );

			if ( !newBuilding )
			{
				throw new Error( "Building: " + building + " can not be upgraded" );
			}
			swapBuilding( building, newBuilding, gameLogics );

		}


		public function demolishBuilding( building:Building, gameLogics:GameLogics ):void
		{
			// make all the units attack first
			building.killAllUnits( gameLogics );

			var constructionSite:ConstructionSite = _buildingFactory.getConstructionSite( building.getOwningPlayer(), building.getX(), building.getY(), building.getConstructionSiteId(), gameLogics );
			// swap the building to a contruction site again
			swapBuilding( building, constructionSite, gameLogics );
		}


		/**
		 * @return the last used positionId
		 */
		private function createDefaultConstructionSites( playerRed:Player, playerBlue:Player, gameLogics:GameLogics ):Vector.<ConstructionSite>
		{
			var gameView:GameView = gameLogics.getGameView();
			var map:MapBase = gameLogics.getMap();

			var buildingSpots:Vector.<Point> = new Vector.<Point>();

			var spot:Point;
			var building:Building;
			var positionId:ConstructionSiteId = new ConstructionSiteId( 0 );

			var constructionSites:Vector.<ConstructionSite> = new Vector.<ConstructionSite>();

			buildingSpots = map.getPlayer0BuildingPositions();

			for each ( spot in buildingSpots )
			{
				building = _buildingFactory.getConstructionSite( playerRed, spot.x, spot.y, positionId, gameLogics );
				positionId = positionId.getNext();
				_buildings.push( building );
				gameView.addBuilding( building );
				constructionSites.push( building );
			}

			buildingSpots = map.getPlayer1BuildingPositions();

			for each ( spot in buildingSpots )
			{
				building = _buildingFactory.getConstructionSite( playerBlue, spot.x, spot.y, positionId, gameLogics );
				positionId = positionId.getNext();
				_buildings.push( building );
				gameView.addBuilding( building );
				constructionSites.push( building );
			}

			return constructionSites;
		}


		private function createDefaultMines( constutionSites:Vector.<ConstructionSite>, playerNeutral:Player, gameLogics:GameLogics ):Vector.<Mine>
		{
			var gameView:GameView = gameLogics.getGameView();
			var map:MapBase = gameLogics.getMap();

			var minePositions:Vector.<Point> = new Vector.<Point>();

			var spot:Point;
			var building:Building;

			// get positions for the mines
			minePositions = map.getMinePositions();

			var mines:Vector.<Mine> = new Vector.<Mine>();

			// create mines
			for each ( spot in minePositions )
			{
				var positionId:ConstructionSiteId = new ConstructionSiteId( uint.MAX_VALUE );
				building = _buildingFactory.getMine( playerNeutral, spot.x, spot.y, positionId, gameLogics );
				_buildings.push( building );
				gameView.addBuilding( building );
				mines.push( building );
			}

			return mines;
		}


		/**
		 * Only call this function when there is only constructionsites built
		 */
		private function setupMineFinder( constructionSites:Vector.<ConstructionSite>, mines:Vector.<Mine>, map:MapBase ):void
		{
			// Only call this function when there is only constructionsites built
			_mineFinder = new MineFinder( constructionSites, mines, map );
		}


		/**
		 * Get the building under (map)position or return null
		 */
		public function getBuildingUnderPosition( x:Number, y:Number ):Building
		{

			var length:int = _buildings.length;

			for ( var i:int = 0; i < length; i++ )
			{
				if ( _buildings[ i ].isUnderPosition( x, y ) )
				{
					return _buildings[ i ];
				}
			}

			return null;
		}


		/**
		 * Get closest mine under map position or return null
		 */
		public function getDirectionToClosestMine( building:Building ):MineDirections
		{

			return _mineFinder.getDirectionToClosestMine( building );
		}


		public function handleMinesResourcesExhausted( mine:Mine ):void
		{
			_mineFinder.handleClosedMine( mine );
		}


		public function setDeployFlag( x:Number, y:Number, building:Building, gameLogics:GameLogics ):void
		{
			building.setDeployFlag( x, y, gameLogics );

		}


		public function createDefaultBuildings( playerRed:Player, playerBlue:Player, playerNeutral:Player, gameLogics:GameLogics ):void
		{
			var constructionSites:Vector.<ConstructionSite> = createDefaultConstructionSites( playerRed, playerBlue, gameLogics );
			var mines:Vector.<Mine> = createDefaultMines( constructionSites, playerNeutral, gameLogics );

			setupMineFinder( constructionSites, mines, gameLogics.getMap() );

		}

	}
}
