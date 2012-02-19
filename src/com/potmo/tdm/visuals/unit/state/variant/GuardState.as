package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.unit.state.IUnitState;
	import com.potmo.tdm.visuals.unit.state.UnitStateBase;
	import com.potmo.tdm.visuals.unit.state.UnitStateEnum;

	public class GuardState extends UnitStateBase implements IUnitState
	{
		private var _unit:IGuardingUnit;


		final public function GuardState()
		{
			super( UnitStateEnum.GUARDING );
		}


		public function init( unit:IGuardingUnit, gameLogics:GameLogics ):void
		{
			// just save the unit for later use
			_unit = unit;
			_unit.setFrameFromName( "LOOP_WAIT" );
		}


		public function visit( gameLogics:GameLogics ):void
		{
			// calculate forces from other units that pushes the unit
			var unitCollisionForce:Force;
			unitCollisionForce = gameLogics.getMap().getUnitCollisionForce( gameLogics, _unit );

			_unit.setVelX( _unit.getVelX() + unitCollisionForce.x );
			_unit.setVelY( _unit.getVelY() + unitCollisionForce.y );

			//TODO: Guarding units should look for enemies and target them
		}


		public function clear():void
		{
			_unit = null;
		}
	}
}
