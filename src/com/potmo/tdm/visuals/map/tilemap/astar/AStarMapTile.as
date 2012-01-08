package com.potmo.tdm.visuals.map.tilemap.astar
{
	import com.potmo.tdm.visuals.map.tilemap.MapTile;
	import com.potmo.tdm.visuals.map.tilemap.MapTileType;

	public class AStarMapTile extends MapTile
	{
		private var _walkable:Boolean;
		private var walkCost:Number;
		internal var neighbors:Vector.<AStarMapTile>;
		private var checkPoint:Boolean = false;

		private var _g:Number = 0;
		private var _gSetInCalculation:uint = 0;
		private var _h:Number = 0;
		private var _hSetInCalculation:uint = 0;
		private var _f:Number = 0;
		private var _fSetInCalculation:uint = 0;
		private var _parent:AStarMapTile = null;
		private var _parentSetInCalculation:uint = 0;
		private var _inOpen:Boolean;
		private var _inOpenSetInCalculation:uint = 0;
		private var _inClosed:Boolean;
		private var _inClosedSetInCalculation:uint = 0;


		public function AStarMapTile( x:int, y:int, type:MapTileType, walkable:Boolean = true, walkCost:Number = 1.0 )
		{
			super( x, y, type );
			init( walkable, walkCost );
		}


		private function init( walkable:Boolean, walkCost:Number ):void
		{
			this._walkable = walkable;
			this.walkCost = walkCost;
			this.neighbors = new Vector.<AStarMapTile>();
			this.checkPoint = false;
		}


		public function get walkable():Boolean
		{
			return this._walkable;
		}


		public function set walkable( value:Boolean ):void
		{
			if ( _walkable == value )
			{
				return;
			}

			_walkable = value;

		/*
		   //update the neighbors for all this tiles neighbors (to flush this tile if it is unwalkable)
		   var tempNeighbors:Vector.<AStarMapTile> = new Vector.<AStarMapTile>(this.neighbors.length, true);

		   for (var i:int = 0; i < tempNeighbors.length; i++)
		   {
		   tempNeighbors[i] = this.neighbors[i];
		   }

		   for each (var neighbor:AStarMapTile in tempNeighbors )
		   {
		   Map.instance.getMapData().getNeighbors(neighbor);
		   }

		   // if this tiles is now unwalkable it should not have any neighbors conencted to it
		   if (this._walkable){
		   Map.instance.getMapData().getNeighbors(this);
		   }else{
		   this.neighbors = new Vector.<AStarMapTile>();
		   }
		 */

		}


		public function setG( value:Number, calculation:uint ):void
		{
			this._g = value;
			this._gSetInCalculation = calculation;
		}


		public function getG( calculation:uint ):Number
		{
			if ( calculation == this._gSetInCalculation )
			{
				return this._g;
			}
			return 0;
		}


		public function setH( value:Number, calculation:uint ):void
		{
			this._h = value;
			this._hSetInCalculation = calculation;
		}


		public function getH( calculation:uint ):Number
		{
			if ( calculation == this._hSetInCalculation )
			{
				return this._h;
			}
			return 0;
		}


		public function setF( value:Number, calculation:uint ):void
		{
			this._f = value;
			this._fSetInCalculation = calculation;
		}


		public function getF( calculation:uint ):Number
		{
			if ( calculation == this._fSetInCalculation )
			{
				return this._f;
			}
			return 0;
		}


		public function setParent( value:AStarMapTile, calculation:uint ):void
		{
			this._parent = value;
			this._parentSetInCalculation = calculation;
		}


		public function getParent( calculation:uint ):AStarMapTile
		{
			if ( calculation == this._parentSetInCalculation )
			{
				return this._parent;
			}
			return null;
		}


		public function setInOpen( value:Boolean, calculation:uint ):void
		{
			this._inOpen = value;
			this._inOpenSetInCalculation = calculation;
		}


		public function getInOpen( calculation:uint ):Boolean
		{
			if ( calculation == this._inOpenSetInCalculation )
			{
				return this._inOpen;
			}
			return false;
		}


		public function setInClosed( value:Boolean, calculation:uint ):void
		{
			this._inClosed = value;
			this._inClosedSetInCalculation = calculation;
		}


		public function getInClosed( calculation:uint ):Boolean
		{
			if ( calculation == this._inClosedSetInCalculation )
			{
				return this._inClosed;
			}
			return false;
		}


		public static function fromMapTile( tile:MapTile ):AStarMapTile
		{

			var walkable:Boolean = tile.getType().isWalkable();
			var walkingCost:Number = tile.getType().getWalkCost();

			return new AStarMapTile( tile.x, tile.y, tile.getType(), walkable, walkingCost );
		}
	}
}
