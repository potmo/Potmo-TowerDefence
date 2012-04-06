package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.unit.state.UnitState;
	import com.potmo.tdm.visuals.unit.state.UnitStateBase;
	import com.potmo.tdm.visuals.unit.state.UnitStateEnum;
	import com.potmo.util.math.StrictMath;

	public class MovingToPositionState extends UnitStateBase implements UnitState
	{
		private var _unit:MovingToPositionUnit;
		private var _posX:int;
		private var _posY:int;


		final public function MovingToPositionState()
		{
			super( UnitStateEnum.MOVING_TO_POSITION );
		}


		public function enter( unit:MovingToPositionUnit, posX:int, posY:int, gameLogics:GameLogics ):void
		{
			_unit = unit;

			_posX = posX;
			_posY = posY;

			_unit.setFrameFromName( "WALK" );
		}


		public function visit( gameLogics:GameLogics ):void
		{

			// calculate force towards position
			var dirX:Number = _posX - _unit.getX();
			var dirY:Number = _posY - _unit.getY();

			// if flag is too close then exit
			var distanceToFlag:Number = StrictMath.get2DLength( dirX, dirY );

			if ( distanceToFlag <= 2 )
			{
				// we are close enough so we can end this
				_unit.handleMovingToPositionStateFinished( this, gameLogics );
				return;
			}

			//continue calculate force towards flag
			var toPositionForce:Force = new Force( dirX, dirY );
			toPositionForce.normalize();

			// calculate forces from other units that pushes the unit
			var unitCollisionForce:Force;
			unitCollisionForce = gameLogics.getMap().getUnitCollisionForce( gameLogics, _unit );

			// sum up the forces and add them to units velocity
			toPositionForce.add( unitCollisionForce );

			var movingSpeed:Number = _unit.getSettings().movingSpeed;
			toPositionForce.normalize();
			toPositionForce.scale( movingSpeed );

			_unit.setVelX( _unit.getVelX() * 0.3 + toPositionForce.x );
			_unit.setVelY( _unit.getVelY() * 0.3 + toPositionForce.y );

			_unit.setX( _unit.getX() + _unit.getVelX() );
			_unit.setY( _unit.getY() + _unit.getVelY() );

		}


		public function clear():void
		{
			_unit = null;
		}


		public function exit( gameLogics:GameLogics ):void
		{
			//nada
		}
	}
}
