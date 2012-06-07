package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.variant.Mine;
	import com.potmo.tdm.visuals.map.MapMovingDirection;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.unit.state.UnitState;
	import com.potmo.tdm.visuals.unit.state.UnitStateBase;
	import com.potmo.tdm.visuals.unit.state.UnitStateEnum;
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	public class EnteringHomeState extends UnitStateBase implements UnitState
	{
		private var _unit:MiningUnit;
		private var _trailX:Number;
		private var _trailY:Number;
		private var _direction:MapMovingDirection;
		private var _mine:Mine;

		private var _pickedUp:int;


		final public function EnteringHomeState()
		{
			super( UnitStateEnum.ENTERING_MINE );
		}


		public function enter( unit:MiningUnit, pickedUp:int, gameLogics:GameLogics ):void
		{
			_unit = unit;
			_pickedUp = pickedUp;
		}


		public function visit( gameLogics:GameLogics ):void
		{
			// get direction
			var dirX:Number = _unit.getHomeBuilding().getX() - _unit.getX();
			var dirY:Number = _unit.getHomeBuilding().getY() - _unit.getY();

			// normalize
			var dist:Number = StrictMath.get2DLength( dirX, dirY );

			if ( dist <= _unit.getHomeBuilding().getRadius() )
			{

				_unit.getOwningPlayer().makeTransaction( _pickedUp );
				_pickedUp = 0;

				_unit.handleEnteringHomeStateFinished( gameLogics );
				return;
			}

			// normalize
			dirX /= dist;
			dirY /= dist;

			// calculate forces from other units that pushes the unit
			var movingForce:Force;
			movingForce = gameLogics.getMap().getUnitCollisionForce( gameLogics, _unit );
			movingForce.scale( 2.0 );

			movingForce.addComponents( dirX, dirY );

			//scale so we do not walk faster than we can
			var movingSpeed:Number = _unit.getSettings().getMovingSpeed();
			movingForce.normalize();
			movingForce.scale( movingSpeed );

			_unit.setVelX( _unit.getVelX() * 0.4 + movingForce.x );
			_unit.setVelY( _unit.getVelY() * 0.4 + movingForce.y );

			_unit.setX( _unit.getX() + _unit.getVelX() );
			_unit.setY( _unit.getY() + _unit.getVelY() );

		}


		public function exit( gameLogics:GameLogics ):void
		{
		}


		public function clear():void
		{
			_unit = null;
			_pickedUp = 0;
		}
	}
}
