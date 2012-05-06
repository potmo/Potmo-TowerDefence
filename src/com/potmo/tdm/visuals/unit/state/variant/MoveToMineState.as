package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.variant.Mine;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.unit.state.UnitState;
	import com.potmo.tdm.visuals.unit.state.UnitStateBase;
	import com.potmo.tdm.visuals.unit.state.UnitStateEnum;

	public class MoveToMineState extends UnitStateBase implements UnitState
	{
		private var _mine:Mine;
		private var _unit:MovingToMineUnit;


		final public function MoveToMineState()
		{
			super( UnitStateEnum.MOVING_TO_MINE );
		}


		public function enter( unit:MovingToMineUnit, gameLogics:GameLogics ):void
		{
			_unit = unit;

			//find the best mine to move to
			var closestMine:Mine = gameLogics.getBuildingManager().getClosestMine( _unit.getX(), _unit.getY() );

			if ( !closestMine )
			{
				//TODO: Exit this state somehow
				return;
			}

			_mine = closestMine;

			//TODO: Find if should go forward on path or backward
		}


		public function visit( gameLogics:GameLogics ):void
		{
			//TODO: Check if unit is close enought to mine so we can get off path and enter mine

			var mapForce:Force = gameLogics.getMap().getMapPathForce( gameLogics, _unit, _unit.getOwningPlayer().getDefaultMovingDirection() );

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


		public function exit( gameLogics:GameLogics ):void
		{

		}


		public function clear():void
		{
			_mine = null;
			_unit = null;
		}
	}
}
