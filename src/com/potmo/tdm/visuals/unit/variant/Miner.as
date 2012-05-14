package com.potmo.tdm.visuals.unit.variant
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.variant.Mine;
	import com.potmo.tdm.visuals.map.MapMovingDirection;
	import com.potmo.tdm.visuals.unit.Unit;
	import com.potmo.tdm.visuals.unit.UnitBase;
	import com.potmo.tdm.visuals.unit.UnitType;
	import com.potmo.tdm.visuals.unit.settings.MinerSetting;
	import com.potmo.tdm.visuals.unit.state.UnitStateFactory;
	import com.potmo.tdm.visuals.unit.state.variant.DeployingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.EnteringMineUnit;
	import com.potmo.tdm.visuals.unit.state.variant.MovingToMineUnit;
	import com.potmo.tdm.visuals.unit.state.variant.MovingToPositionUnit;
	import com.potmo.tdm.visuals.unit.state.variant.NoneingUnit;
	import com.potmo.util.logger.Logger;

	public class Miner extends UnitBase implements Unit, UnitVariant, DeployingUnit, NoneingUnit, MovingToPositionUnit, MovingToMineUnit, EnteringMineUnit
	{
		private static const SEQUENCE_NAME:String = "knight";
		private static const SETTINGS:MinerSetting = new MinerSetting();


		public function Miner( spriteAtlas:SpriteAtlas )
		{
			super( spriteAtlas.getSequenceByName( SEQUENCE_NAME ), UnitType.MINER, SETTINGS );
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

			gameLogics.getUnitManager().removeUnit( this, gameLogics );

		}


		override public function handleBeingHurt( damage:int, gameLogics:GameLogics ):void
		{
		}


		override public function handleBeingHealed( aid:int, gameLogics:GameLogics ):void
		{
		}


		override public function handleBeeingCommandedToCharge( gameLogics:GameLogics ):void
		{
			throw new Error( "Miners don't charge" );
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


		public function handleDeployStateFinished( gameLogics:GameLogics ):void
		{
			// do nothing. We will probably be told to do something else soon
		}


		public function handleNoneStateFinished( gameLogics:GameLogics ):void
		{
			// do nothing it always happens

		}


		public function handleMovingToPositionStateFinished( gameLogics:GameLogics ):void
		{
			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			currentState = unitStateFactory.getMoveToMineState( currentState, this, gameLogics );
		}


		public function handleMovingToMineStateFinished( pointOnTrailX:Number, pointOnTrailY:Number, movingDirection:MapMovingDirection, mine:Mine, gameLogics:GameLogics ):void
		{
			//enter the mine
			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			currentState = unitStateFactory.getEnterMineState( currentState, this, pointOnTrailX, pointOnTrailY, movingDirection, mine, gameLogics );
		}


		public function handleMovingToMineStateFinishedSinceThereIsNotMines( gameLogics:GameLogics ):void
		{
			Logger.info( "Can not find any mines to mine" );
			var unitStateFactory:UnitStateFactory = gameLogics.getUnitManager().getUnitStateFactory();
			currentState = unitStateFactory.getNoneState( currentState, this, gameLogics );
		}

	}
}
