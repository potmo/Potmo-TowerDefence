package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.unit.state.UnitState;
	import com.potmo.tdm.visuals.unit.state.UnitStateBase;
	import com.potmo.tdm.visuals.unit.state.UnitStateEnum;
	import com.potmo.util.math.StrictMath;

	public class DeployState extends UnitStateBase implements UnitState
	{
		private var _unit:DeployingUnit;


		final public function DeployState()
		{
			super( UnitStateEnum.DEPLOYING );
		}


		public function enter( unit:DeployingUnit, deployX:int, deployY:int, gameLogics:GameLogics ):void
		{
			_unit = unit;

			_unit.setX( deployX );
			_unit.setY( deployY );

		}


		public function visit( gameLogics:GameLogics ):void
		{

			_unit.handleDeployStateFinished( this, gameLogics );

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
