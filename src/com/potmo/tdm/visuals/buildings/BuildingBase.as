package com.potmo.tdm.visuals.buildings
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.starling.TextureAnimation;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;
	import com.potmo.tdm.visuals.units.UnitBase;
	import com.potmo.util.math.StrictMath;

	public class BuildingBase extends TextureAnimation
	{
		protected static const MAX_UNITS:uint = 15;

		private var uniqueId:uint;
		private var type:BuildingType;
		private var buildingId:uint;
		protected var owningPlayer:Player;
		//		protected var deployPerimiter:int = 100; // the length from the center it is possible to place the deployment flag
		protected var _deployFlagX:int;
		protected var _deployFlagY:int;

		protected var units:Vector.<UnitBase> = new Vector.<UnitBase>();


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


		public function deployUnit( unit:UnitBase ):void
		{
			units.push( unit );
			unit.x = this.x;
			unit.y = this.y + 50;
			//TODO: Set deploy area from variables
			unit.setDeployFlag( _deployFlagX + getPathOffsetXForNthUnit( units.length - 1 ), _deployFlagY + getPathOffsetYForNthUnit( units.length - 1 ) );
		}


		public function setDeployFlag( x:int, y:int ):void
		{
			_deployFlagX = x;
			_deployFlagY = y;
			var i:int = 0;

			for each ( var unit:UnitBase in units )
			{
				//unit.setDeployFlag( _deployFlagX + unitDeployOffset[ 0 ][ i ], _deployFlagY + unitDeployOffset[ 1 ][ i ] );
				unit.setDeployFlag( _deployFlagX + getPathOffsetXForNthUnit( i ), _deployFlagY + getPathOffsetYForNthUnit( i ) );
				i++;
			}
		}


		private function getPathOffsetXForNthUnit( index:int ):int
		{
			var ang:Number = index * 120.0 + 60 * StrictMath.floor( index / 3 );
			ang = StrictMath.degrees2rads( ang );
			var d:Number = StrictMath.cos( ang ) * ( 15 + index * 2 );
			return d;
		}


		private function getPathOffsetYForNthUnit( index:int ):int
		{
			var ang:Number = index * 120.0 + 60 * StrictMath.floor( index / 3 );
			ang = StrictMath.degrees2rads( ang );
			var d:Number = StrictMath.sin( ang ) * ( 15 + index * 2 );
			return d;
		}


		public function chargeWithAllUnits( gameLogics:GameLogics ):void
		{
			var i:int = 0;

			for each ( var unit:UnitBase in units )
			{
				unit.chargeTowardsEnemy();
				unit.setPathOffset( getPathOffsetXForNthUnit( i ), getPathOffsetYForNthUnit( i ) );
				i++;
			}

			// clear units
			units.splice( 0, units.length );
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
