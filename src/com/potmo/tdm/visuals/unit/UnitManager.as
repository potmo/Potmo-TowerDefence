package com.potmo.tdm.visuals.unit
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.GameView;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.map.MapBase;
	import com.potmo.tdm.visuals.unit.quadtree.QuadTree;
	import com.potmo.tdm.visuals.unit.state.UnitStateFactory;
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	import flash.geom.Rectangle;

	public class UnitManager
	{
		private static const MAX_NUMBER_OF_TARGETING_UNITS:int = 2;

		private var _unitLookup:QuadTree;
		private var _units:Vector.<IUnit>;
		private var _unitFactory:UnitFactory;
		private var _unitStateFactory:UnitStateFactory;


		public function UnitManager( unitFactory:UnitFactory, unitStateFactory:UnitStateFactory, map:MapBase )
		{
			this._unitFactory = unitFactory;
			this._unitStateFactory = unitStateFactory;
			this._units = new Vector.<IUnit>();
			this._unitLookup = new QuadTree( 0, 0, map.getMapWidth(), map.getMapHeight(), 10, 3 );
		}


		public function update( gameLogics:GameLogics ):void
		{
			var unitsLength:int = _units.length;

			for ( var i:int = unitsLength - 1; i >= 0; i-- )
			{
				var unit:IUnit = _units[ i ];
				unit.update( gameLogics );

				// update the lookup if the unit moved
				if ( unit.isPositionDirty() )
				{
					_unitLookup.cleanPosition( unit );
				}
			}

		}


		/**
		 * Add a unit to the map and to the game
		 */
		public function addUnit( type:UnitType, building:BuildingBase, gameLogics:GameLogics ):IUnit
		{
			var owner:Player = building.getOwningPlayer();
			var unit:IUnit = _unitFactory.getUnit( type, owner, gameLogics );

			// push it to the array
			_units.push( unit );

			// push it to the lookup
			unit.setPositionAsClean();
			_unitLookup.insert( unit );

			building.deployUnit( unit, gameLogics );

			var gameView:GameView = gameLogics.getGameView();

			gameView.addUnit( unit );

			Logger.log( "Adding unit: " + unit );

			return unit;
		}


		/**
		 * Remove a unit from the map and the game
		 */
		public function removeUnit( unit:IUnit, gameLogics:GameLogics ):void
		{
			var index:int = _units.indexOf( unit );
			_units.splice( index, 1 );
			_unitLookup.remove( unit );
			var gameView:GameView = gameLogics.getGameView();
			gameView.removeUnit( unit );
			_unitFactory.returnUnit( unit, gameLogics );
		}


		/**
		 * Finds the unit that is closest to the point and within the range from the point
		 * @returns the closest unit or null
		 */
		public function getClosestUnitToPointWithinRange( x:Number, y:Number, range:Number ):IUnit
		{

			// get all the close by units
			var unitsToSearch:Vector.<IUnit> = _unitLookup.retriveFromRect( x - range, y - range, range * 2, range * 2 );

			var dist:Number;
			var closestUnitDist:Number = Number.MAX_VALUE;
			var closestUnit:IUnit;

			// square for faster lookup
			range *= range;

			var unitsLength:int = unitsToSearch.length;

			for ( var i:int = 0; i < unitsLength; i++ )
			{
				var unit:IUnit = unitsToSearch[ i ];
				dist = StrictMath.distSquared( unit.getX(), unit.getY(), x, y );

				if ( dist <= range )
				{
					if ( dist < closestUnitDist )
					{
						closestUnit = unit;
					}
				}
			}

			return closestUnit;
		}


		/**
		 * Get a list of units that is intersecting the circle
		 */
		public function getUnitsIntersectingCircle( x:Number, y:Number, radius:Number ):Vector.<IUnit>
		{

			// get all the close by units
			//var unitsToSearch:Vector.<IUnit> = _unitLookup.retriveFromRect( x - radius, y - radius, radius * 2, radius * 2 );
			var unitsToSearch:Vector.<IUnit> = _units;

			var maxDist:Number;
			var output:Vector.<IUnit> = new Vector.<IUnit>();

			var unitsLength:int = unitsToSearch.length;

			for ( var i:int = 0; i < unitsLength; i++ )
			{
				var unit:IUnit = unitsToSearch[ i ];
				//see if unit and circle intersects
				var unitX:Number = unit.getX();
				var unitY:Number = unit.getY();
				maxDist = unit.getRadius() + radius;

				if ( StrictMath.isCloseEnough( x, y, unitX, unitY, maxDist, true ) )
				{
					output.push( unit );
				}

			}

			return output;

		}


		/**
		 * Find units that is in range and that are in the other team
		 * Return the closest
		 * @returns the best unit to attack or null if none
		 */
		public function getClosestEnemyUnitPossibleToAttack( unit:IUnit ):IUnit
		{

			// get the range
			var range:Number = unit.getSettings().targetingRange;

			// get all the close by units
			var unitsToSearch:Vector.<IUnit> = _unitLookup.retriveFromRect( unit.getX() - range, unit.getY() - range, range * 2, range * 2 );

			//square inRange
			range *= range;

			// okay firstly we want to target a unit that is not already targeted by another unit
			// if we can not find that we will target the first best
			//var bestTargeted:IUnit;
			var bestUntargeted:IUnit;
			//var bestTargetedDist:int = int.MAX_VALUE;
			var bestUntargetedDist:int = int.MAX_VALUE;

			var dist:Number;
			var unitsLength:int = unitsToSearch.length;

			for ( var i:int = 0; i < unitsLength; i++ )
			{
				var other:IUnit = unitsToSearch[ i ];

				// do not check agains my self
				if ( other == unit )
				{
					continue;
				}

				// check for owner
				if ( other.getOwningPlayer().getColor() == unit.getOwningPlayer().getColor() )
				{
					//Logger.log( "Unit is on my team: " + other.getOwningPlayer() + " == " + unit.getOwningPlayer() );
					continue;
				}

				// check if dead
				if ( other.isDead() )
				{
					//Logger.log( "Unit is dead" );
					continue;
				}

				// a unit can only be targeted by x number of other units
				/*if ( other.getNumberOfTargetingUnits() >= MAX_NUMBER_OF_TARGETING_UNITS )
				   {
				   //Logger.log( "Unit has too many tageted" );
				   continue;
				   }*/

				dist = StrictMath.distSquared( unit.getX(), unit.getY(), other.getX(), other.getY() );

				if ( dist > range )
				{
					continue;
				}

				// check if it is in range

				/*if ( other.getNumberOfTargetingUnits() > 0 )
				   {
				   // targeted must be double as close
				   if ( dist * 4 <= range )
				   {
				   if ( dist < bestTargetedDist )
				   {
				   bestTargeted = other;
				   bestTargetedDist = dist;
				   }
				   }
				   }
				   else
				   {*/
				if ( dist < bestUntargetedDist )
				{
					bestUntargeted = other;
					bestUntargetedDist = dist;
				}
					//}

			}

			if ( bestUntargeted )
			{
				return bestUntargeted;
			}
			/*else if ( bestTargeted )
			   {
			   return bestTargeted;

			   }*/
			else
			{
				return null;
			}

		}


		public function getUnitStateFactory():UnitStateFactory
		{
			return _unitStateFactory;
		}

	}
}
