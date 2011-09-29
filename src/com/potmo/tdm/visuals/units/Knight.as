package com.potmo.tdm.visuals.units
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.asset.unit.Knight_Asset;
	import com.potmo.tdm.player.Player;
	import com.potmo.util.image.BitmapAnimationCacheObject;
	import com.potmo.util.image.BitmapUtil;
	import com.potmo.util.math.StrictMath;

	import flash.display.BitmapData;

	public class Knight extends UnitBase
	{

		private static const asset:BitmapAnimationCacheObject = new BitmapAnimationCacheObject( new Knight_Asset() );


		public function Knight()
		{
			super( asset );

		}


		override public function update( gameLogics:GameLogics ):void
		{
			super.update( gameLogics );

		}


		override protected function changeState( state:UnitState ):void
		{
			super.changeState( state );

			switch ( state )
			{
				case UnitState.CHARGING:
				case UnitState.DEPLOYING:
					setFrameFromName( "WALKING" );
					break;

				case UnitState.GUARDING:
				case UnitState.NONE:
					setFrameFromName( "LOOP_WAIT" );
					break;

				case UnitState.ENGAGING_ATTACK:
				case UnitState.ENGAGING_DEFEND:
					setFrameFromName( "ENGAGE_FIGHT" );
					break;

				case UnitState.ATTACKING:
				case UnitState.DEFENDING:
					setFrameFromName( "FIGHT" );
					break;

			}
		}
	}
}
