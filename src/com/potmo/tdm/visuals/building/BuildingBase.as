package com.potmo.tdm.visuals.building
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.starling.TextureAnimation;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;
	import com.potmo.tdm.visuals.unit.IUnit;
	import com.potmo.tdm.visuals.unit.UnitBase;
	import com.potmo.util.math.StrictMath;

	public class BuildingBase extends TextureAnimation
	{
		protected static const MAX_UNITS:uint = 3;

		private var uniqueId:uint;
		private var type:BuildingType;
		private var buildingId:uint;
		protected var owningPlayer:Player;
		//		protected var deployPerimiter:int = 100; // the length from the center it is possible to place the deployment flag
		protected var _deployFlagX:int;
		protected var _deployFlagY:int;

		protected var units:Vector.<IUnit> = new Vector.<IUnit>();


		public function BuildingBase( graphics:TextureAnimationCacheObject )
		{
			super( graphics );

		}


		public function setUniqueId( id:uint ):void
		{
			this.uniqueId = id;
		}


		public function getUniqueId():uint
		{
			return this.uniqueId;
		}


		public function setType( type:BuildingType ):void
		{
			this.type = type;
		}


		public function getType():BuildingType
		{
			return type;
		}


		public function setOwningPlayer( player:Player ):void
		{
			this.owningPlayer = player;
		}


		public function getOwningPlayer():Player
		{
			return owningPlayer;
		}


		public function deployUnit( unit:IUnit, gameLogics:GameLogics ):void
		{
			units.push( unit );
			unit.setHomeBuilding( this );
			unit.deploy( x, y, gameLogics );
		}


		public function setDeployFlag( x:int, y:int, gameLogics:GameLogics ):void
		{
			_deployFlagX = x;
			_deployFlagY = y;

			//TODO: Send to all units that they should move
		}


		public function chargeWithAllUnits( gameLogics:GameLogics ):void
		{
			var i:int = 0;

			for each ( var unit:UnitBase in units )
			{
				unit.charge( gameLogics );
				unit.setHomeBuilding( null );
				i++;
			}

			// clear units
			units.splice( 0, units.length );
		}


		public function killAllUnits( gameLogics:GameLogics ):void
		{
			var i:int = 0;

			for each ( var unit:UnitBase in units )
			{
				unit.kill( gameLogics );
				i++;
			}

			// units will be removed from units when they die
		}


		public function onUnitDied( unit:UnitBase ):void
		{
			var index:int = units.indexOf( unit );

			if ( index == -1 )
			{
				throw new Error( "Unit does not belong to this Building" );
			}
			units.splice( index, 1 );
			unit.setHomeBuilding( null );
		}


		public function handleClick( x:int, y:int, logics:GameLogics ):void
		{
			// override
		}


		public function handleClickOutside( x:int, y:int, logics:GameLogics ):void
		{
			// override
		}


		public function update( gameLogics:GameLogics ):void
		{
			// override
		}


		public function isUnderPosition( x:int, y:int ):Boolean
		{
			return getBounds( parent ).contains( x, y );
		}


		public function getId():uint
		{
			return buildingId;
		}


		public function getDeployFlagX():int
		{
			return _deployFlagX;
		}


		public function getDeployFlagY():int
		{
			return _deployFlagY;
		}

	}
}
