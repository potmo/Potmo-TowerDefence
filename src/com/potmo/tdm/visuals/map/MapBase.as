package com.potmo.tdm.visuals.map
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.p2d.atlas.animation.SpriteAtlasSequence;
	import com.potmo.p2d.renderer.Renderable;
	import com.potmo.p2d.renderer.Renderer;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.display.BasicRenderItem;
	import com.potmo.tdm.visuals.map.tilemap.MapTile;
	import com.potmo.tdm.visuals.map.tilemap.TileMap;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.IForceFieldMap;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.unit.UnitCollisionForceCalculator;
	import com.potmo.tdm.visuals.map.tilemap.pathfinding.dijkstra.precalculated.DijkstraPrecalculatedMap;
	import com.potmo.tdm.visuals.map.util.MapImageAnalyzer;
	import com.potmo.tdm.visuals.unit.Unit;
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;

	public class MapBase extends BasicRenderItem
	{

		private var _mapImageAnalyzer:MapImageAnalyzer;
		private var _unitCollisionForceCalculator:UnitCollisionForceCalculator;

		private var _minePositions:Vector.<Point>;
		private var _player0EndPoint:Point;
		private var _player1EndPoint:Point;
		private var _player0BuildingPositions:Vector.<Point>;
		private var _player1BuildingPositions:Vector.<Point>;
		private var _leftRightPathfinderForceFieldMap:DijkstraPrecalculatedMap;
		private var _rightLeftPathfinderForceFieldMap:DijkstraPrecalculatedMap;
		private var _tileWidth:Number;
		private var _tileHeight:Number;
		private var _mapName:String;

		private var _mapWidth:int;
		private var _mapHeight:int;

		private var _graphicsSequence:SpriteAtlasSequence;


		public function MapBase( spriteAtlas:SpriteAtlas, spriteName:String, mapDataImage:BitmapData, dijkstraMap:ByteArray )
		{
			Logger.info( "Creating map: " + spriteName );

			_graphicsSequence = spriteAtlas.getSequenceByName( spriteName );

			super( _graphicsSequence );

			this._mapName = spriteName;
			// setup a device to analyze an image and get data from it
			_mapImageAnalyzer = new MapImageAnalyzer();

			var visualMapSize:Point = _graphicsSequence.getSizeOfFrame( _graphicsSequence.getNthFrame( 0 ) );
			this._mapWidth = visualMapSize.x;
			this._mapHeight = visualMapSize.y;

			// calculate the scale between tile and visual map
			_tileWidth = _mapWidth / mapDataImage.width;
			_tileHeight = _mapHeight / mapDataImage.height;

			// configure endpoints
			this.setEndPoints( mapDataImage, _tileWidth );

			// configure buildingpositions
			this.setBuildingPositions( mapDataImage, _tileWidth );

			// configure mine positons
			this.setMinePositons( mapDataImage, _tileWidth );

			// create a object that can calculate the forces on a unit
			_unitCollisionForceCalculator = new UnitCollisionForceCalculator();

			// create a representation of the map in tiles
			//_tileMapRepresentation = _mapImageAnalyzer.createMap( mapDataImage, _tileWidth, _tileHeight );

			// create a map containing information on shortest path from
			// all point in the map to the final point

			// uncompress since it should be compressed with DEFLATE
			dijkstraMap.uncompress( CompressionAlgorithm.DEFLATE );
			Logger.info( "Byte available: " + dijkstraMap.bytesAvailable );

			_leftRightPathfinderForceFieldMap = new DijkstraPrecalculatedMap();
			var leftRightData:ByteArray = new ByteArray();
			dijkstraMap.readBytes( leftRightData, 0, dijkstraMap.bytesAvailable / 2 ); // read first half
			Logger.info( "leftRight data available: " + leftRightData.bytesAvailable );
			_leftRightPathfinderForceFieldMap.setupFromByteArray( leftRightData );

			_rightLeftPathfinderForceFieldMap = new DijkstraPrecalculatedMap();
			var rightLeftData:ByteArray = new ByteArray();
			dijkstraMap.readBytes( rightLeftData ); // read the rest
			Logger.info( "rightLeft data available: " + rightLeftData.bytesAvailable );
			_rightLeftPathfinderForceFieldMap.setupFromByteArray( rightLeftData );

		}


		protected function setEndPoints( mapDataImage:BitmapData, scale:Number ):void
		{
			var endpoints:Vector.<Point> = _mapImageAnalyzer.getEndPoints( mapDataImage, scale );
			_player0EndPoint = endpoints[ 0 ];
			_player1EndPoint = endpoints[ 1 ];

		}


		protected function setBuildingPositions( mapDataImage:BitmapData, scale:Number ):void
		{
			var buildingPositions:Vector.<Vector.<Point>> = _mapImageAnalyzer.getBuildingPositions( mapDataImage, scale );
			_player0BuildingPositions = buildingPositions[ 0 ];
			_player1BuildingPositions = buildingPositions[ 1 ];
		}


		protected function setMinePositons( mapDataImage:BitmapData, scale:Number ):void
		{
			_minePositions = _mapImageAnalyzer.getMinePositions( mapDataImage, scale );
		}


		/**
		 * Get the size of the map
		 */
		public function getMapWidth():uint
		{
			return this._mapWidth;
		}


		public function getMapHeight():uint
		{
			return this._mapHeight;
		}


		public function getMinePositions():Vector.<Point>
		{
			return _minePositions;
		}


		/**
		 * Get a list of all the building locations
		 */
		public function getPlayer0BuildingPositions():Vector.<Point>
		{
			return _player0BuildingPositions;
		}


		/**
		 * Get a list of all the building locations
		 */
		public function getPlayer1BuildingPositions():Vector.<Point>
		{
			return _player1BuildingPositions;
		}


		public function getUnitCollisionForce( gameLogics:GameLogics, unit:Unit ):Force
		{
			return _unitCollisionForceCalculator.getUnitCollisionForce( gameLogics, unit );
		}


		/**
		 * Returns the force in the direction of the closest path to the other side
		 */
		public function getMapPathForce( x:Number, y:Number, movingDirection:MapMovingDirection ):Force
		{
			var map:IForceFieldMap;

			if ( movingDirection == MapMovingDirection.RIGHT )
			{
				map = _leftRightPathfinderForceFieldMap;

			}
			else
			{
				map = _rightLeftPathfinderForceFieldMap;
			}

			return map.getPathForce( x / _tileWidth, y / _tileHeight );
		}


		/**
		 * Returns the force towards the closest walkable place
		 * If the ground under the unit is walkable this will return a zero length force
		 */
		public function getMapUnwalkableAreaForce( x:Number, y:Number, movingDirection:MapMovingDirection ):Force
		{
			var map:IForceFieldMap;

			if ( movingDirection == MapMovingDirection.RIGHT )
			{
				map = _leftRightPathfinderForceFieldMap;

			}
			else
			{
				map = _rightLeftPathfinderForceFieldMap;
			}

			return map.getUnwalkableAreaForce( x / _tileWidth, y / _tileHeight );
		}


		public function isPositionWalkable( x:Number, y:Number, movingDirection:MapMovingDirection ):Boolean
		{
			// scale to tile scale
			x /= _tileWidth;
			y /= _tileHeight;

			//check tile type
			var map:DijkstraPrecalculatedMap;

			if ( movingDirection == MapMovingDirection.RIGHT )
			{
				map = _leftRightPathfinderForceFieldMap;
			}
			else
			{
				map = _rightLeftPathfinderForceFieldMap;
			}
			return map.getNodeAt( x, y ).getType().isWalkable();

		}


		public function getMapName():String
		{
			return this._mapName;
		}


		public function getPlayer0EndPoint():Point
		{
			return _player0EndPoint;
		}


		public function getPlayer1EndPoint():Point
		{
			return _player1EndPoint;
		}

	}
}
