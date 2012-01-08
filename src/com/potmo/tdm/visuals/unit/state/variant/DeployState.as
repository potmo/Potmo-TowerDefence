package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.unit.state.IUnitState;
	import com.potmo.tdm.visuals.unit.state.UnitStateBase;
	import com.potmo.tdm.visuals.unit.state.UnitStateEnum;
	import com.potmo.util.math.StrictMath;

	public class DeployState extends UnitStateBase implements IUnitState
	{
		private var _unit:IDeployingUnit;


		final public function DeployState()
		{
			super( UnitStateEnum.DEPLOYING );
		}


		public function init( unit:IDeployingUnit, deployX:int, deployY:int, gameLogics:GameLogics ):void
		{
			_unit = unit;

			_unit.setX( deployX );
			_unit.setY( deployY + 20 );

			_unit.setFrameFromName( "WALK" );
		}


		/**
		 *
		 * @param gameLogics
		 */
		/**
		 *
		 * @param gameLogics
		 */
		public function visit( gameLogics:GameLogics ):void
		{

			// move towards the deploy flag
			var building:BuildingBase = _unit.getHomeBuilding();

			var flagX:int = building.getDeployFlagX();
			var flagY:int = building.getDeployFlagY();

			// calculate force towards flag
			var dirX:Number = flagX - _unit.getX();
			var dirY:Number = flagY - _unit.getY();

			// if flag is too close then exit
			var distanceToFlag:Number = StrictMath.get2DLength( dirX, dirY );

			if ( distanceToFlag <= 2 )
			{
				// we are close enough so we can end this
				_unit.handleDeployStateFinished( this, gameLogics );
				return;
			}

			//continue calculate force towards flag
			var toFlagForce:Force = new Force( dirX, dirY );
			var movingSpeed:Number = _unit.getSettings().movingSpeed;
			toFlagForce.normalize();
			toFlagForce.scale( movingSpeed );

			// calculate forces from other units that pushes the unit
			var unitCollisionForce:Force;
			unitCollisionForce = gameLogics.getMap().getUnitCollisionForce( gameLogics, _unit );

			// sum up the forces and add them to units velocity
			toFlagForce.add( unitCollisionForce );

			_unit.setVelX( _unit.getVelX() + toFlagForce.x );
			_unit.setVelY( _unit.getVelY() + toFlagForce.y );

			//TODO: Unit collision forces should apply in the deploy state

		}


		public function clear():void
		{
			_unit = null;
		}
	}
}
