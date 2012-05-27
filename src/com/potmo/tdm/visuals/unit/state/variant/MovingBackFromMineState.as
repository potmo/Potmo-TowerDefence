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

	public class MovingBackFromMineState extends UnitStateBase implements UnitState
	{

		private static const MAX_DISTANCE_TO_HOME:Number = StrictMath.sqr( 200 );
		private var _unit:MiningUnit;
		private var _direction:MapMovingDirection;
		private var _pickedUp:int;


		final public function MovingBackFromMineState()
		{
			super( UnitStateEnum.MOVING_TO_MINE );
		}


		public function enter( unit:MiningUnit, direction:MapMovingDirection, pickedUp:int, gameLogics:GameLogics ):void
		{
			_unit = unit;
			_pickedUp = pickedUp;
			// get the opposite to return home
			_direction = MapMovingDirection.getOpposite( direction );

		}


		public function visit( gameLogics:GameLogics ):void
		{

			var distanceToHome:Number = StrictMath.distSquared( _unit.getX(), _unit.getY(), _unit.getHomeBuilding().getX(), _unit.getHomeBuilding().getY() );

			if ( distanceToHome <= MAX_DISTANCE_TO_HOME )
			{
				//exit the state. We are close enough
				handleMovedCloseEnoughToHome( gameLogics );
				return;
			}

			var mapForce:Force = gameLogics.getMap().getMapPathForce( _unit.getX(), _unit.getY(), _direction );

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


		private function handleMovedCloseEnoughToHome( gameLogics:GameLogics ):void
		{
			_unit.handleMovingBackFromHomeStateFinished( _pickedUp, gameLogics );
		}


		public function exit( gameLogics:GameLogics ):void
		{

		}


		public function clear():void
		{
			_unit = null;
			_direction = null;
			_pickedUp = 0;
		}
	}
}
