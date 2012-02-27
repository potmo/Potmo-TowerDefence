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
	import com.potmo.tdm.visuals.unit.state.variant.FootAttackState;
	import com.potmo.tdm.visuals.unit.state.variant.ChargeState;
	import com.potmo.tdm.visuals.unit.state.variant.DeployState;
	import com.potmo.tdm.visuals.unit.state.variant.GuardState;
	import com.potmo.tdm.visuals.unit.state.variant.IFootAttackingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.IChargingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.IDeployingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.IGuardingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.INoneingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.NoneState;

	public class Knight extends UnitBase implements IUnitVariant, INoneingUnit, IDeployingUnit, IGuardingUnit, IChargingUnit, IFootAttackingUnit
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
			currentState = unitStateFactory.getNoneState( null, this, gameLogics );

		}


		override public function handleBeingKilled( gameLogics:GameLogics ):void
		{
			//TODO: Should go to die state instead of none state
			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			currentState = unitStateFactory.getNoneState( currentState, this, gameLogics );
		}


		override public function handleBeingHurt( damage:int, gameLogics:GameLogics ):void
		{
			//TODO: Do some animation
		}


		override public function handleBeingHealed( aid:int, gameLogics:GameLogics ):void
		{
			// TODO Auto-generated method stub
		}


		override public function handleBeeingCommandedToCharge( gameLogics:GameLogics ):void
		{
			// set charge state
			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			currentState = unitStateFactory.getChargeState( currentState, this, gameLogics );
		}


		override public function handleBeingDeployed( x:int, y:int, gameLogics:GameLogics ):void
		{
			// set deploy state
			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			currentState = unitStateFactory.getDeployState( currentState, this, x, y, gameLogics );
		}


		public function handleGuardStateFinished( state:GuardState, gameLogics:GameLogics ):void
		{
			//TODO: Get the targeted unit from the state and have a hunt
		}


		public function handleNoneStateFinished( state:NoneState, gameLogics:GameLogics ):void
		{
			// do nothing it always does
		}


		public function handleDeployStateFinished( state:DeployState, gameLogics:GameLogics ):void
		{
			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			currentState = unitStateFactory.getGuardState( state, this, gameLogics );
		}


		public function handleChargeStateFinished( state:ChargeState, enemy:IUnit, gameLogics:GameLogics ):void
		{

			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			currentState = unitStateFactory.getAttackState( state, this, enemy, gameLogics );

		}


		public function handleFootAttackStateFinished( state:FootAttackState, gameLogics:GameLogics ):void
		{
			// okay back on the road again
			charge( gameLogics );
		}

	}
}
