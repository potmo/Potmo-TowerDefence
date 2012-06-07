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

	public class EnteringMineState extends UnitStateBase implements UnitState
	{
		private var _unit:MiningUnit;
		private var _trailX:Number;
		private var _trailY:Number;
		private var _direction:MapMovingDirection;
		private var _mine:Mine;


		final public function EnteringMineState()
		{
			super( UnitStateEnum.ENTERING_MINE );
		}


		public function enter( unit:MiningUnit, trailX:Number, trailY:Number, direction:MapMovingDirection, mine:Mine, gameLogics:GameLogics ):void
		{
			_unit = unit;

			// just remember this until we exit the mine and should go back to the trail again
			_trailX = trailX;
			_trailY = trailY;
			_direction = direction;
			_mine = mine;
		}


		public function visit( gameLogics:GameLogics ):void
		{
			// get direction
			var dirX:Number = _mine.getX() - _unit.getX();
			var dirY:Number = _mine.getY() - _unit.getY();

			// normalize
			var dist:Number = StrictMath.get2DLength( dirX, dirY );

			if ( dist <= _mine.getRadius() )
			{
				enterMine( gameLogics );
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


		private function enterMine( gameLogics:GameLogics ):void
		{
			_unit.handleEnteringMineStateFinished( _trailX, _trailY, _direction, _mine, gameLogics );

		}


		public function exit( gameLogics:GameLogics ):void
		{
		}


		public function clear():void
		{
			_unit = null;
			_trailX = 0;
			_trailY = 0;
			_direction = null;
			_mine = null;
		}
	}
}
