package com.potmo.tdm.visuals.unit.variant
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.unit.Unit;
	import com.potmo.tdm.visuals.unit.UnitBase;
	import com.potmo.tdm.visuals.unit.UnitType;
	import com.potmo.tdm.visuals.unit.settings.KnightSetting;
	import com.potmo.tdm.visuals.unit.state.UnitStateFactory;
	import com.potmo.tdm.visuals.unit.state.variant.ChargeState;
	import com.potmo.tdm.visuals.unit.state.variant.ChargingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.DeployState;
	import com.potmo.tdm.visuals.unit.state.variant.DeployingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.FootAttackState;
	import com.potmo.tdm.visuals.unit.state.variant.FootAttackingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.FootDefendState;
	import com.potmo.tdm.visuals.unit.state.variant.FootDefendingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.GuardState;
	import com.potmo.tdm.visuals.unit.state.variant.GuardingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.MovingToPositionState;
	import com.potmo.tdm.visuals.unit.state.variant.MovingToPositionUnit;
	import com.potmo.tdm.visuals.unit.state.variant.NoneState;
	import com.potmo.tdm.visuals.unit.state.variant.NoneingUnit;

	public class Knight extends UnitBase implements UnitVariant, NoneingUnit, DeployingUnit, GuardingUnit, ChargingUnit, FootAttackingUnit, MovingToPositionUnit, FootDefendingUnit
	{
		//private static const ASSET:TextureAnimationCacheObject = new TextureAnimationCacheObject( new Knight_Asset() );
		private static const SEQUENCE_NAME:String = "knight";
		private static const SETTINGS:KnightSetting = new KnightSetting();


		public function Knight( spriteAtlas:SpriteAtlas )
		{
			super( spriteAtlas.getSequenceByName( SEQUENCE_NAME ), UnitType.KNIGHT, SETTINGS );
		}


		override public function init( gameLogics:GameLogics ):void
		{
			// start by setting no state
			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			currentState = unitStateFactory.getNoneState( currentState, this, gameLogics );

		}


		override public function handleBeingKilled( gameLogics:GameLogics ):void
		{

			//TODO: Should go to die state instead of none state
			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			currentState = unitStateFactory.getNoneState( currentState, this, gameLogics );

			//TODO: Should do some kind of nice animation before removing the unit
			gameLogics.getUnitManager().removeUnit( this, gameLogics );

		}


		override public function handleBeingHurt( damage:int, gameLogics:GameLogics ):void
		{
			//TODO: Do some animation
		}


		override public function handleBeingHealed( aid:int, gameLogics:GameLogics ):void
		{
			//TODO: Do some animation
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


		override public function handleBeeingCommandedToMoveToPosition( x:int, y:int, gameLogics:GameLogics ):void
		{
			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			currentState = unitStateFactory.getMoveToPositionState( currentState, this, x, y, gameLogics );
		}


		public function handleGuardStateFinished( state:GuardState, enemy:Unit, gameLogics:GameLogics ):void
		{

			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			currentState = unitStateFactory.getFootDefendState( state, this, enemy, gameLogics );
		}


		public function handleNoneStateFinished( state:NoneState, gameLogics:GameLogics ):void
		{
			// do nothing it always does
		}


		public function handleDeployStateFinished( state:DeployState, gameLogics:GameLogics ):void
		{
			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			currentState = unitStateFactory.getNoneState( currentState, this, gameLogics );
		}


		public function handleChargeStateFinished( state:ChargeState, enemy:Unit, gameLogics:GameLogics ):void
		{

			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			currentState = unitStateFactory.getFootAttackState( state, this, enemy, gameLogics );

		}


		public function handleFootAttackStateFinished( state:FootAttackState, gameLogics:GameLogics ):void
		{
			// okay back on the road again
			charge( gameLogics );
		}


		public function handleFootDefendStateFinished( state:FootDefendState, gameLogics:GameLogics ):void
		{
			// okay back to the flag again
			moveToFlag( gameLogics );
		}


		public function handleMovingToPositionStateFinished( state:MovingToPositionState, gameLogics:GameLogics ):void
		{
			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			currentState = unitStateFactory.getGuardState( state, this, gameLogics );
		}

	}
}
