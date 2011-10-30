package com.potmo.tdm.visuals.units
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.asset.unit.Knight_Asset;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;
	import com.potmo.tdm.visuals.units.settings.KnightSetting;

	public class Knight extends FightingUnitBase
	{

		private static const ASSET:TextureAnimationCacheObject = new TextureAnimationCacheObject( new Knight_Asset() );
		private static const SETTINGS:KnightSetting = new KnightSetting();

		private var hurtOnAnimation:Boolean = false;


		public function Knight()
		{
			super( ASSET, UnitType.KNIGHT, SETTINGS );

		}


		override public function update( gameLogics:GameLogics ):void
		{
			super.update( gameLogics );
		}


		override protected function onDie( gameLogics:GameLogics ):void
		{
			// just wait until we reach the DEAD frame
			setFrameFromName( "DIE" );
		}


		override protected function onHeal( maxAmount:int, gameLogics:GameLogics ):void
		{
			heal( maxAmount, gameLogics );
		}


		override protected function onEngageTargetUnit( gameLogics:GameLogics ):void
		{
			// just wait until we reach the DAMAGE frame
			setFrameFromName( "FIGHT" );
		}


		override protected function onEnterNamedFrame( frameName:String, gameLogics:GameLogics ):void
		{
			switch ( frameName )
			{
				case ( "DAMAGE" ):
				{
					// now really hurt the target
					hurtTargetedUnit( gameLogics );
					break;
				}
				case ( "DEAD" ):
				{
					die( gameLogics );
					break;
				}
			}
		}


		override protected function onStateSet( state:UnitState, gameLogics:GameLogics ):void
		{

			switch ( state )
			{
				case UnitState.CHARGING:
				case UnitState.DEPLOYING:
					setFrameFromName( "WALK" );
					break;

				case UnitState.GUARDING:
				case UnitState.NONE:
					setFrameFromName( "LOOP_WAIT" );
					break;

				case UnitState.APPROACH_ATTACK:
				case UnitState.APPROACH_DEFEND:
					setFrameFromName( "APPROACH_FIGHT" );
					break;

				case UnitState.ATTACKING:
				case UnitState.DEFENDING:
					setFrameFromName( "LOOP_WAIT" );
					break;

			}
		}

	}
}
