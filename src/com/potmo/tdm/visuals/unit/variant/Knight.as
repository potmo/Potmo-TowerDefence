package com.potmo.tdm.visuals.unit.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.asset.unit.Knight_Asset;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;
	import com.potmo.tdm.visuals.unit.IUnit;
	import com.potmo.tdm.visuals.unit.UnitBase;
	import com.potmo.tdm.visuals.unit.UnitType;
	import com.potmo.tdm.visuals.unit.settings.KnightSetting;
	import com.potmo.tdm.visuals.unit.state.UnitStateFactory;
	import com.potmo.tdm.visuals.unit.state.variant.AttackState;
	import com.potmo.tdm.visuals.unit.state.variant.ChargeState;
	import com.potmo.tdm.visuals.unit.state.variant.DeployState;
	import com.potmo.tdm.visuals.unit.state.variant.GuardState;
	import com.potmo.tdm.visuals.unit.state.variant.IAttackingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.IChargingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.IDeployingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.IGuardingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.INoneingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.NoneState;

	public class Knight extends UnitBase implements IUnitVariant, INoneingUnit, IDeployingUnit, IGuardingUnit, IChargingUnit, IAttackingUnit
	{
		private static const ASSET:TextureAnimationCacheObject = new TextureAnimationCacheObject( new Knight_Asset() );
		private static const SETTINGS:KnightSetting = new KnightSetting();


		public function Knight()
		{
			super( ASSET, UnitType.KNIGHT, SETTINGS );
		}


		override public function init( gameLogics:GameLogics ):void
		{
			// start by setting no state
			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			var noneState:NoneState = unitStateFactory.getNoneState();
			noneState.init( this, gameLogics );
			setState( noneState, gameLogics );
		}


		override public function handleBeingKilled( gameLogics:GameLogics ):void
		{
			// TODO Auto-generated method stub
		}


		override public function handleBeingHurt( damage:int, gameLogics:GameLogics ):void
		{
			// TODO Auto-generated method stub
		}


		override public function handleBeingHealed( aid:int, gameLogics:GameLogics ):void
		{
			// TODO Auto-generated method stub
		}


		override public function handleBeeingCommandedToCharge( gameLogics:GameLogics ):void
		{
			// set charge state
			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			var chargeState:ChargeState = unitStateFactory.getChargeState();
			chargeState.init( this, gameLogics );
			setState( chargeState, gameLogics );
		}


		override public function handleBeingDeployed( x:int, y:int, gameLogics:GameLogics ):void
		{
			// set deploy state
			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			var deployState:DeployState = unitStateFactory.getDeployState();
			deployState.init( this, x, y, gameLogics );
			setState( deployState, gameLogics );
		}


		public function handleGuardStateFinished( state:GuardState, gameLogics:GameLogics ):void
		{
			//TODO: Get the targeted unit from the state and have a hunt
		}


		public function handleNoneStateFinished( state:NoneState, gameLogics:GameLogics ):void
		{
			// do nothing
		}


		public function handleDeployStateFinished( state:DeployState, gameLogics:GameLogics ):void
		{
			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			var guardState:GuardState = unitStateFactory.getGuardState();
			guardState.init( this, gameLogics );
			setState( guardState, gameLogics );
		}


		public function handleChargeStateFinished( state:ChargeState, gameLogics:GameLogics ):void
		{
			// get the enemy
			var enemy:IUnit = state.getEnemy();

			// change state
			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			var attackState:AttackState = unitStateFactory.getAttackState();
			attackState.init( this, enemy, gameLogics );
			setState( attackState, gameLogics );

		}


		public function handleAttackStateFinished( state:AttackState, gameLogics:GameLogics ):void
		{
			// TODO Auto-generated method stub
		}

	}
}
