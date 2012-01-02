package com.potmo.tdm.visuals.unit
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.GameView;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.unit.state.IUnitState;
	import com.potmo.tdm.visuals.unit.state.UnitStateEnum;
	import com.potmo.tdm.visuals.unit.state.UnitStateFactory;
	import com.potmo.util.math.StrictMath;

	public class UnitManager
	{
		private var _units:Vector.<IUnit> = new Vector.<IUnit>();
		private var _unitFactory:UnitFactory;
		private var _unitStateFactory:UnitStateFactory;


		public function UnitManager( unitFactory:UnitFactory, unitStateFactory:UnitStateFactory )
		{
			this._unitFactory = unitFactory;
			this._unitStateFactory = unitStateFactory;
		}


		public function update( gameLogics:GameLogics ):void
		{
			for each ( var unit:IUnit in _units )
			{
				unit.update( gameLogics );

			}

		}


		/**
		 * Add a unit to the map and to the game
		 */
		public function addUnit( type:UnitType, building:BuildingBase, gameLogics:GameLogics ):IUnit
		{
			var owner:Player = building.getOwningPlayer();
			var unit:IUnit = _unitFactory.getUnit( type, owner, gameLogics );

			_units.push( unit );
			building.deployUnit( unit, gameLogics );

			var gameView:GameView = gameLogics.getGameView();

			gameView.addUnit( unit );

			return unit;
		}


		/**
		 * Remove a unit from the map and the game
		 */
		public function removeUnit( unit:IUnit, gameLogics:GameLogics ):void
		{
			var index:int = _units.indexOf( unit );
			_units.splice( index, 1 );
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
			// square
			range *= range;

			var dist:Number;
			var closestUnitDist:Number = Number.MAX_VALUE;
			var closestUnit:IUnit;

			for each ( var unit:IUnit in _units )
			{
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

			var maxDist:Number;
			var output:Vector.<IUnit> = new Vector.<IUnit>();

			for each ( var unit:IUnit in _units )
			{
				//see if unit and circle intersects
				var unitX:Number = unit.getX();
				var unitY:Number = unit.getY();
				maxDist = unit.getRadius() + radius;

				if ( StrictMath.isCloseEnough( x, y, unitX, unitY, maxDist ) )
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
		public function getEnemyUnitCloseEnough( unit:IUnit, inRange:int ):IUnit
		{
			//square inRange
			inRange *= inRange;

			// okay firstly we want to target a unit that is not already targeted by another unit
			// if we can not find that we will target the first best
			var bestTargeted:IUnit;
			var bestUntargeted:IUnit;
			var bestTargetedDist:int = int.MAX_VALUE;
			var bestUntargetedDist:int = int.MAX_VALUE;

			var dist:Number;

			for each ( var other:IUnit in _units )
			{
				// check for owner
				if ( other.getOwningPlayer().getColor() != unit.getOwningPlayer().getColor() )
				{
					dist = StrictMath.distSquared( unit.getX(), unit.getY(), other.getX(), other.getY() );

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


		public function getUnitStateFactory():UnitStateFactory
		{
			return _unitStateFactory;
		}

	}
}
