package com.potmo.tdm.visuals.building
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.GameView;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.map.MapBase;

	import flash.geom.Point;

	public class BuildingManager
	{
		private var _buildings:Vector.<BuildingBase> = new Vector.<BuildingBase>();
		private var _buildingFactory:BuildingFactory;


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
		public function swapBuildingType( building:BuildingBase, type:BuildingType, gameLogics:GameLogics ):BuildingBase
		{
			var map:MapBase = gameLogics.getMap();

			var owner:Player = building.getOwningPlayer();
			var newBuilding:BuildingBase = _buildingFactory.getBuilding( type, owner );

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

			newBuilding.x = building.x;
			newBuilding.y = building.y;

			//TODO: Initial deploy flag position should be calculated better than this 
			newBuilding.setDeployFlag( newBuilding.x, newBuilding.y + 10, gameLogics );

			_buildingFactory.returnBuilding( building );

			return newBuilding;
		}


		public function upgradeBuilding( building:BuildingBase, gameLogics:GameLogics ):void
		{
			var currentType:BuildingType = building.getType();
			var upgradeType:BuildingType = BuildingType.getUpgrade( currentType );

			//TODO: Upgrade all the units as well when updgrading building
			swapBuildingType( building, upgradeType, gameLogics );

		}


		public function demolishBuilding( building:BuildingBase, gameLogics:GameLogics ):void
		{
			// make all the units attack first
			building.killAllUnits( gameLogics );

			// swap the building to a contruction site again
			swapBuildingType( building, BuildingType.CONSTRUCTION_SITE, gameLogics );
		}


		public function createDefaultConstructionSites( playerRed:Player, playerBlue:Player, gameLogics:GameLogics ):void
		{
			var gameView:GameView = gameLogics.getGameView();
			var map:MapBase = gameLogics.getMap();

			var buildingSpots:Vector.<Point> = new Vector.<Point>();

			var spot:Point;
			var building:BuildingBase;

			buildingSpots = map.getPlayer0BuildingPositions();

			for each ( spot in buildingSpots )
			{
				building = _buildingFactory.getBuilding( BuildingType.CONSTRUCTION_SITE, playerRed );
				building.x = spot.x;
				building.y = spot.y;
				_buildings.push( building );
				gameView.addBuilding( building );
			}

			buildingSpots = map.getPlayer1BuildingPositions();

			for each ( spot in buildingSpots )
			{
				building = _buildingFactory.getBuilding( BuildingType.CONSTRUCTION_SITE, playerBlue );
				building.x = spot.x;
				building.y = spot.y;
				_buildings.push( building );
				gameView.addBuilding( building );
			}

		}


		/**
		 * Get the building under (map)position or return null
		 */
		public function getBuildingUnderPosition( x:int, y:int ):BuildingBase
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
	}
}
