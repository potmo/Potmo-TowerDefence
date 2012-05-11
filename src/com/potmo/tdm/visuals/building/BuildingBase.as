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
		//TODO: Do not hardcode this
		protected static const MAX_UNITS:uint = 3;
		protected static const MAX_DISTANCE_TO_DEPLOYFLAG:Number = 200;

		private var _uniqueId:uint;
		private var _type:BuildingType;
		private var _buildingId:uint;
		protected var owningPlayer:Player;
		//		protected var deployPerimiter:int = 100; // the length from the center it is possible to place the deployment flag
		protected var _deployFlagX:int;
		protected var _deployFlagY:int;

		protected var units:Vector.<Unit> = new Vector.<Unit>();
		private var _constructionSiteId:ConstructionSiteId;


		public function BuildingBase( type:BuildingType, graphicsSequence:SpriteAtlasSequence )
		{
			super( graphicsSequence );
			this._type = type;

		}


		public function setConstructionSiteId( id:ConstructionSiteId ):void
		{
			this._constructionSiteId = id;
		}


		public function getConstructionSiteId():ConstructionSiteId
		{
			return this._constructionSiteId;
		}


		public function setType( type:BuildingType ):void
		{
			this._type = type;
		}


		public function getType():BuildingType
		{
			return _type;
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
			unit.setHomeBuilding( this as Building );
			unit.deploy( x, y, gameLogics );
			unit.moveToFlag( gameLogics );
		}


		public function setDeployFlag( x:Number, y:Number, gameLogics:GameLogics ):void
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


		public function handleUnitRemoved( unit:Unit ):void
		{
			var index:int = units.indexOf( unit );

			if ( index == -1 )
			{
				throw new Error( "Unit does not belong to this Building" );
			}
			units.splice( index, 1 );
			unit.setHomeBuilding( null );
		}


		public function isUnderPosition( x:Number, y:Number ):Boolean
		{
			return this.containsPoint( x, y );
		}


		public function getId():uint
		{
			return _buildingId;
		}


		public function getDeployFlagX():Number
		{
			return _deployFlagX;
		}


		public function getDeployFlagY():Number
		{
			return _deployFlagY;
		}


		public function getZDepth():int
		{
			return y;
		}


		public function getDeployFlagMaxDistanceFromBuilding():Number
		{
			return MAX_DISTANCE_TO_DEPLOYFLAG;
		}
	}
}
