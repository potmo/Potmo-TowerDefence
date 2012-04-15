package com.potmo.tdm.visuals.building
{
	import com.potmo.p2d.atlas.animation.SpriteAtlasSequence;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.display.BasicRenderItem;
	import com.potmo.tdm.display.ZSortableRenderable;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.unit.Unit;
	import com.potmo.tdm.visuals.unit.UnitBase;

	public class BuildingBase extends BasicRenderItem implements ZSortableRenderable
	{
		protected static const MAX_UNITS:uint = 3;

		private var uniqueId:uint;
		private var type:BuildingType;
		private var buildingId:uint;
		protected var owningPlayer:Player;
		//		protected var deployPerimiter:int = 100; // the length from the center it is possible to place the deployment flag
		protected var _deployFlagX:int;
		protected var _deployFlagY:int;

		protected var units:Vector.<Unit> = new Vector.<Unit>();


		public function BuildingBase( graphicsSequence:SpriteAtlasSequence )
		{
			super( graphicsSequence );

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


		public function deployUnit( unit:Unit, gameLogics:GameLogics ):void
		{
			units.push( unit );
			unit.setHomeBuilding( this );
			unit.deploy( x, y, gameLogics );
			unit.moveToFlag( gameLogics );
		}


		public function setDeployFlag( x:int, y:int, gameLogics:GameLogics ):void
		{
			_deployFlagX = x;
			_deployFlagY = y;

			for each ( var unit:UnitBase in units )
			{
				unit.moveToFlag( gameLogics );
			}
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


		public function onUnitRemoved( unit:Unit ):void
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
			return this.containsPoint( x, y );
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


		public function getZDepth():int
		{
			return y;
		}

	}
}
