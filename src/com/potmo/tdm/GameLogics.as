package com.potmo.tdm
{
	import com.potmo.tdm.player.OrderManager;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.player.PlayerColor;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.building.BuildingFactory;
	import com.potmo.tdm.visuals.building.BuildingManager;
	import com.potmo.tdm.visuals.hud.DeployFlagHud;
	import com.potmo.tdm.visuals.hud.HudBase;
	import com.potmo.tdm.visuals.map.DeployFlag;
	import com.potmo.tdm.visuals.map.MapBase;
	import com.potmo.tdm.visuals.map.MapZero;
	import com.potmo.tdm.visuals.unit.IUnit;
	import com.potmo.tdm.visuals.unit.UnitBase;
	import com.potmo.tdm.visuals.unit.UnitFactory;
	import com.potmo.tdm.visuals.unit.UnitManager;
	import com.potmo.tdm.visuals.unit.projectile.Projectile;
	import com.potmo.tdm.visuals.unit.projectile.ProjectileFactory;
	import com.potmo.tdm.visuals.unit.projectile.ProjectileType;
	import com.potmo.tdm.visuals.unit.state.UnitStateFactory;
	import com.potmo.util.logger.Logger;

	public final class GameLogics
	{

		//TODO: Add the real players
		private var playerRed:Player = new Player( 0, "RedPlayer", PlayerColor.RED, true );
		private var playerBlue:Player = new Player( 1, "BluePlayer", PlayerColor.BLUE, false );

		private var projectiles:Vector.<Projectile> = new Vector.<Projectile>();

		private var map:MapBase;
		private var hud:HudBase;

		private var gameView:GameView;
		private var orderManager:OrderManager;

		private var unitStateFactory:UnitStateFactory;
		private var unitFactory:UnitFactory;
		private var buildingFactory:BuildingFactory;
		private var projectileFactory:ProjectileFactory;

		private var unitManager:UnitManager;
		private var buildingManager:BuildingManager;


		public function GameLogics( view:GameView, orderManager:OrderManager )
		{
			this.gameView = view;
			this.orderManager = orderManager;
			this.initialize();
		}


		private function initialize():void
		{
			map = new MapZero();

			gameView.addMap( map );

			unitStateFactory = new UnitStateFactory();
			unitFactory = new UnitFactory();
			buildingFactory = new BuildingFactory();
			projectileFactory = new ProjectileFactory();

			unitManager = new UnitManager( unitFactory, unitStateFactory, map );
			buildingManager = new BuildingManager( buildingFactory );

			buildingManager.createDefaultConstructionSites( playerRed, playerBlue, this );

		}


		public function update():void
		{

			var building:BuildingBase;
			var projectile:Projectile;

			buildingManager.update( this );

			for each ( projectile in projectiles )
			{
				projectile.update( this );

			}

			unitManager.update( this );

		}


		/*
		   TODO: Comment in this function in GameLogics and fix it
		   public function getNextCheckpointForUnit( unit:UnitBase ):PathCheckpoint
		   {
		   return map.getNextCheckpoint( unit );
		   }
		 */

		public function onMapClicked( x:int, y:int ):void
		{

			removeHud();

			// check if a building was clicked
			var clickedBuilding:BuildingBase = buildingManager.getBuildingUnderPosition( x, y );

			//send to the clicked building that it was clicked if any
			//TODO: Comment this in if you dont want to be able to alter other players buildings
			if ( clickedBuilding ) //&& clickedBuilding.getOwningPlayer().isMe() )
			{
				Logger.log( "building clicked" );
				clickedBuilding.handleClick( x, y, this );

			}

			// send to all other building that they where not clicked
		/*
		   var building:BuildingBase;

		   for each ( building in buildings )
		   {
		   if ( building != clickedBuilding && building.getOwningPlayer().isMe() )
		   {
		   building.handleClickOutside( x, y, this );
		   }
		   }*/

		}


		/**
		 * Make a building to another type
		 * This is typically done when transforming a constructionsite to a tower
		 * or when demolishing a tower making it a construction site
		 */
		/*public function swapBuildingType( building:BuildingBase, type:BuildingType ):BuildingBase
		   {

		   var owner:Player = building.getOwningPlayer();
		   var newBuilding:BuildingBase = buildingFactory.getBuilding( type, owner );

		   var index:int = buildings.indexOf( building );

		   if ( index == -1 )
		   {
		   throw new Error( "Building does not exist" );
		   }

		   // remove the old
		   buildings.splice( index, 1 );
		   gameView.removeBuilding( building );

		   // add the new
		   buildings.push( newBuilding );
		   gameView.addBuilding( newBuilding );

		   newBuilding.x = building.x;
		   newBuilding.y = building.y;

		   var closestPointOnPath:Point = map.getPointOnPathClosestToPoint( newBuilding.x, newBuilding.y );

		   newBuilding.setDeployFlag( closestPointOnPath.x, closestPointOnPath.y, this );

		   buildingFactory.returnBuilding( building );

		   return newBuilding;
		   }*/

		/*public function upgradeBuilding( building:BuildingBase ):void
		   {
		   var currentType:BuildingType = building.getType();
		   var upgradeType:BuildingType = BuildingType.getUpgrade( currentType );

		   //TODO: Upgrade all the units as well when updgrading building
		   swapBuildingType( building, upgradeType );

		   }*/

		/*	public function demolishBuilding( building:BuildingBase ):void
		   {
		   // make all the units attack first
		   building.killAllUnits( this );

		   // swap the building to a contruction site again
		   swapBuildingType( building, BuildingType.CONSTRUCTION_SITE );
		   }*/

		/*	public function addUnit( type:UnitType, building:BuildingBase ):UnitBase
		   {
		   var owner:Player = building.getOwningPlayer();
		   var unit:UnitBase = unitFactory.getUnit( type, owner );

		   units.push( unit );
		   building.deployUnit( unit, this );
		   gameView.addUnit( unit );

		   return unit;
		   }*/

		/*public function removeUnit( unit:UnitBase ):void
		   {
		   var index:int = units.indexOf( unit );
		   units.splice( index, 1 );
		   gameView.removeUnit( unit );
		   unitFactory.returnUnit( unit, this );
		   }*/

		public function shootProjectile( type:ProjectileType, fromX:int, fromY:int, toX:int, toY:int ):void
		{
			var projectile:Projectile = projectileFactory.getProjectile( type );
			projectiles.push( projectile );
			gameView.addProjectile( projectile );
			projectile.launch( fromX, fromY, toX, toY );

		/*var marker:MapItem = new Marker();
		   marker.x = toX;
		   marker.y = toY;
		   gameView.addMapItem( marker );*/
		}


		public function projectileReachedTarget( projectile:Projectile ):void
		{
			var hitRadius:int = projectile.getHitRadius();
			var hitX:int = projectile.getTargetX();
			var hitY:int = projectile.getTargetY();
			var damage:int = projectile.getDamage();

			var unit:IUnit = unitManager.getClosestUnitToPointWithinRange( hitX, hitY, hitRadius );

			if ( unit )
			{
				unit.damage( damage, this );
				removeProjectile( projectile );
			}

			//TODO: Projectiles that miss should be stuck in the ground for a while

		}


		public function removeProjectile( projectile:Projectile ):void
		{
			var index:int = projectiles.indexOf( projectile );
			projectiles.splice( index, 1 );
			gameView.removeProjectile( projectile );
			projectileFactory.returnProjectile( projectile );
		}


		/*private function createDefaultConstructionSites():void
		   {
		   var buildingSpots:Vector.<Point> = new Vector.<Point>();

		   var spot:Point;
		   var building:BuildingBase;

		   buildingSpots = map.getPlayer0BuildingPositions();

		   for each ( spot in buildingSpots )
		   {
		   building = buildingFactory.getBuilding( BuildingType.CONSTRUCTION_SITE, playerRed );
		   building.x = spot.x;
		   building.y = spot.y;
		   buildings.push( building );
		   gameView.addBuilding( building );
		   }

		   buildingSpots = map.getPlayer1BuildingPositions();

		   for each ( spot in buildingSpots )
		   {
		   building = buildingFactory.getBuilding( BuildingType.CONSTRUCTION_SITE, playerBlue );
		   building.x = spot.x;
		   building.y = spot.y;
		   buildings.push( building );
		   gameView.addBuilding( building );
		   }

		   }*/

		public function setHud( hud:HudBase ):void
		{
			gameView.setHud( hud );
			this.hud = hud;
		}


		public function removeHud():void
		{
			gameView.removeHud();
			this.hud = null;
		}


		public function showDeployFlag( building:BuildingBase ):void
		{

			var deployFlag:DeployFlag = new DeployFlag();
			var hud:DeployFlagHud = new DeployFlagHud( deployFlag, building, gameView );
			gameView.addMapItem( deployFlag );
			gameView.setHud( hud );
		}


		public function setDeployFlag( x:int, y:int, building:BuildingBase ):void
		{
			building.setDeployFlag( x, y, this );
		}


		/**
		 * Get the building under (map)position or return null
		 */
		/*	private function getBuildingUnderPosition( x:int, y:int ):BuildingBase
		   {
		   var building:BuildingBase

		   for each ( building in buildings )
		   {
		   if ( building.isUnderPosition( x, y ) )
		   {
		   return building;
		   }
		   }

		   return null;
		   }*/

		/**
		 * Finds the unit that is closest to the point and within the range from the point
		 * @returns the closest unit or null
		 */
		/*public function getClosestUnitToPointWithinRange( x:Number, y:Number, range:Number ):UnitBase
		   {
		   // sqraure
		   range *= range;

		   var dist:Number;
		   var closestUnitDist:Number = Number.MAX_VALUE;
		   var closestUnit:UnitBase;

		   for each ( var unit:UnitBase in units )
		   {
		   dist = StrictMath.distSquared( unit.x, unit.y, x, y );

		   if ( dist <= range )
		   {
		   if ( dist < closestUnitDist )
		   {
		   closestUnit = unit;
		   }
		   }
		   }

		   return closestUnit;
		   }*/

		/**
		 * Find units that is in range and that are in the other team
		 * Return the closest
		 * @returns the best unit to attack or null if none
		 */
		/*public function getEnemyUnitCloseEnough( unit:UnitBase, inRange:int ):UnitBase
		   {
		   //square inRange
		   inRange *= inRange;

		   // okay firstly we want to target a unit that is not already targeted by another unit
		   // if we can not find that we will target the first best
		   var bestTargeted:UnitBase;
		   var bestUntargeted:UnitBase;
		   var bestTargetedDist:int = int.MAX_VALUE;
		   var bestUntargetedDist:int = int.MAX_VALUE;

		   var dist:Number;

		   for each ( var other:UnitBase in units )
		   {
		   // check for owner
		   if ( other.getOwningPlayer().getColor() != unit.getOwningPlayer().getColor() )
		   {
		   dist = StrictMath.distSquared( unit.x, unit.y, other.x, other.y );

		   // check if it is in range
		   if ( dist <= inRange )
		   {
		   if ( other.isTargetedByAnyUnit() )
		   {
		   // targeted must be double as close
		   if ( dist * 4 <= inRange )
		   {
		   if ( dist < bestTargetedDist )
		   {
		   bestTargeted = other;
		   bestTargetedDist = dist;
		   }
		   }
		   }
		   else
		   {
		   if ( dist < bestUntargetedDist )
		   {
		   bestUntargeted = other;
		   bestUntargetedDist = dist;
		   }
		   }

		   }
		   }

		   }

		   if ( bestUntargeted )
		   {
		   return bestUntargeted;
		   }
		   else if ( bestTargeted )
		   {
		   return bestTargeted;

		   }
		   else
		   {
		   return null;
		   }

		   }
		 */

		public function getBuildingManager():BuildingManager
		{
			return buildingManager;
		}


		public function getGameView():GameView
		{
			return gameView;
		}


		public function getUnitManager():UnitManager
		{
			return unitManager;
		}


		public function getMap():MapBase
		{
			return map;
		}
	}
}
