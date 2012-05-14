package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.minefinder.MineDirections;
	import com.potmo.tdm.visuals.building.variant.Mine;
	import com.potmo.tdm.visuals.map.MapMovingDirection;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.unit.state.UnitState;
	import com.potmo.tdm.visuals.unit.state.UnitStateBase;
	import com.potmo.tdm.visuals.unit.state.UnitStateEnum;
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	public class MovingToMineState extends UnitStateBase implements UnitState
	{

		private static const MAX_DISTANCE_TO_MINE:Number = StrictMath.sqr( 150 );
		private var _unit:MovingToMineUnit;
		private var _directions:MineDirections;


		final public function MovingToMineState()
		{
			super( UnitStateEnum.MOVING_TO_MINE );
		}


		public function enter( unit:MovingToMineUnit, gameLogics:GameLogics ):void
		{
			_unit = unit;

			//find the best mine to move to
			// TODO: Return best mine as well so we dont have to calculate distance to all mines
			_directions = gameLogics.getBuildingManager().getDirectionToClosestMine( unit.getHomeBuilding() );

			if ( !_directions )
			{

				handleNoMinesToMine( gameLogics );
				return;
			}

		}


		public function visit( gameLogics:GameLogics ):void
		{

			var distanceToMine:Number = StrictMath.distSquared( _unit.getX(), _unit.getY(), _directions.getX(), _directions.getY() );

			if ( distanceToMine <= MAX_DISTANCE_TO_MINE )
			{
				//exit the state. We are close enough
				handleMovedCloseEnoughToMine( _unit.getX(), _unit.getY(), _directions.getDirection(), _directions.getMine(), gameLogics );
				return;
			}

			//TODO: Check if mine still has gold. Otherwise select a new mine

			var mapForce:Force = gameLogics.getMap().getMapPathForce( _unit.getX(), _unit.getY(), _directions.getDirection() );

			// calculate forces from other units that pushes the unit
			var unitCollisionForce:Force;
			unitCollisionForce = gameLogics.getMap().getUnitCollisionForce( gameLogics, _unit );
			unitCollisionForce.scale( 3.0 );
			mapForce.add( unitCollisionForce );

			mapForce.normalize();
			mapForce.scale( _unit.getSettings().movingSpeed );

			// add force from map and unit collistion force
			_unit.setVelX( _unit.getVelX() * 0.2 + mapForce.x );
			_unit.setVelY( _unit.getVelY() * 0.2 + mapForce.y );

			_unit.setX( _unit.getX() + _unit.getVelX() );
			_unit.setY( _unit.getY() + _unit.getVelY() );
		}


		private function handleMovedCloseEnoughToMine( pointOnTrailX:Number, pointOnTrailY:Number, movingDirection:MapMovingDirection, mine:Mine, gameLogics:GameLogics ):void
		{
			_unit.handleMovingToMineStateFinished( pointOnTrailX, pointOnTrailY, movingDirection, mine, gameLogics );
		}


		private function handleNoMinesToMine( gameLogics:GameLogics ):void
		{
			_unit.handleMovingToMineStateFinishedSinceThereIsNotMines( gameLogics );
		}


		public function exit( gameLogics:GameLogics ):void
		{

		}


		public function clear():void
		{
			_unit = null;
			_directions = null;
		}
	}
}
