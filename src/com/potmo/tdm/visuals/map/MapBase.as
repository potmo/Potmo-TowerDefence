package com.potmo.tdm.visuals.map
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.p2d.atlas.animation.SpriteAtlasSequence;
	import com.potmo.p2d.renderer.Renderable;
	import com.potmo.p2d.renderer.Renderer;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.display.BasicRenderItem;
	import com.potmo.tdm.visuals.map.tilemap.TileMap;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.IForceFieldMap;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.unit.UnitCollisionForceCalculator;
	import com.potmo.tdm.visuals.map.tilemap.pathfinding.dijkstra.precalculated.DijkstraPrecalculatedMap;
	import com.potmo.tdm.visuals.map.util.MapImageAnalyzer;
	import com.potmo.tdm.visuals.unit.IUnit;
	import com.potmo.util.math.StrictMath;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class MapBase extends BasicRenderItem
	{

		protected var mapImageAnalyzer:MapImageAnalyzer;
		protected var unitCollisionForceCalculator:UnitCollisionForceCalculator;
		protected var tileMapRepresentation:TileMap;

		protected var player0EndPoint:Point;
		protected var player1EndPoint:Point;
		protected var player0BuildingPositions:Vector.<Point>;
		protected var player1BuildingPositions:Vector.<Point>;
		protected var leftRightPathfinderForceFieldMap:DijkstraPrecalculatedMap;
		protected var rightLeftPathfinderForceFieldMap:DijkstraPrecalculatedMap;
		protected var tileWidth:Number;
		protected var tileHeight:Number;
		private var _mapName:String;

		private var _mapWidth:int;
		private var _mapHeight:int;

		private var _graphicsSequence:SpriteAtlasSequence;


		public function MapBase( spriteAtlas:SpriteAtlas, spriteName:String, mapDataImage:BitmapData, directionLeftRightDataImage:BitmapData, directionRightLeftDataImage:BitmapData, name:String )
		{
			_graphicsSequence = spriteAtlas.getSequenceByName( spriteName );

			super( _graphicsSequence );

			validateDataImageSizes( mapDataImage, directionLeftRightDataImage, directionRightLeftDataImage );

			this._mapName = name;
			// setup a device to analyze an image and get data from it
			mapImageAnalyzer = new MapImageAnalyzer();

			var visualMapSize:Point = _graphicsSequence.getSizeOfFrame( 0 );
			this._mapWidth = visualMapSize.x;
			this._mapHeight = visualMapSize.y;

			// calculate the scale between tile and visual map
			tileWidth = _mapWidth / mapDataImage.width;
			tileHeight = _mapHeight / mapDataImage.height;

			// configure endpoints
			this.setEndPoints( mapDataImage, tileWidth );

			// configure buildingpositions
			this.setBuildingPositions( mapDataImage, tileWidth );

			// create a object that can calculate the forces on a unit
			unitCollisionForceCalculator = new UnitCollisionForceCalculator();

			// create a representation of the map in tiles
			tileMapRepresentation = mapImageAnalyzer.createMap( mapDataImage, tileWidth, tileHeight );

			// create a map containing information on shortest path from
			// all point in the map to the final point
			leftRightPathfinderForceFieldMap = new DijkstraPrecalculatedMap();
			leftRightPathfinderForceFieldMap.setupFromImage( directionLeftRightDataImage );

			rightLeftPathfinderForceFieldMap = new DijkstraPrecalculatedMap();
			rightLeftPathfinderForceFieldMap.setupFromImage( directionRightLeftDataImage );

			// set up the background visuals
			//this.setupBackground( visualMap )

			// tell subclasses to initialize
			this.initialize();

		}


		private function validateDataImageSizes( mapDataImage:BitmapData, directionLeftRightDataImage:BitmapData, directionRightLeftDataImage:BitmapData ):void
		{
			if ( mapDataImage.width != directionLeftRightDataImage.width || mapDataImage.height != directionLeftRightDataImage.height )
			{
				throw new Error( "Image sizes not match. - directionLeftRightDataImage" );
			}

			if ( mapDataImage.width != directionRightLeftDataImage.width || mapDataImage.height != directionRightLeftDataImage.height )
			{
				throw new Error( "Image sizes not match. - directionRightLeftDataImage" );
			}
		}


		/*private function setupBackground( visualMap:BitmapData ):void
		   {
		   var textureParts:Vector.<Texture>;
		   textureParts = splitBitmapIntoTextures( visualMap );

		   var image:Image;
		   var o:int = 0;

		   for each ( var texture:Texture in textureParts )
		   {
		   image = new Image( texture );

		   addChild( image );
		   image.x = o;
		   o += image.width;
		   }
		   }*/

		/*private function splitBitmapIntoTextures( bitmap:BitmapData ):Vector.<Texture>
		   {
		   var img:BitmapData;
		   var texture:Texture;
		   var textures:Vector.<Texture> = new Vector.<Texture>();

		   var max:int = 1024;
		   var o:int = 0;
		   var left:int = bitmap.width;
		   var cut:int;
		   var height:int = bitmap.height;
		   var rect:Rectangle = new Rectangle();
		   var p:Point = new Point();

		   while ( left > 0 )
		   {
		   cut = StrictMath.min( left, max ); // take as mutch as possible but stay within max
		   img = new BitmapData( cut, height, false, 0xFF0000 );
		   rect.setTo( o, 0, cut, height );
		   img.copyPixels( bitmap, rect, p );
		   texture = Texture.fromBitmapData( img, false, false );
		   img.dispose();
		   textures.push( texture );
		   o += cut;
		   left -= cut;
		   }

		   return textures;

		   }*/

		protected function setEndPoints( mapDataImage:BitmapData, scale:Number ):void
		{
			var endpoints:Vector.<Point> = mapImageAnalyzer.getEndPoints( mapDataImage, scale );
			player0EndPoint = endpoints[ 0 ];
			player1EndPoint = endpoints[ 1 ];

		}


		protected function setBuildingPositions( mapDataImage:BitmapData, scale:Number ):void
		{
			var buildingPositions:Vector.<Vector.<Point>> = mapImageAnalyzer.getBuildingPositions( mapDataImage, scale );
			player0BuildingPositions = buildingPositions[ 0 ];
			player1BuildingPositions = buildingPositions[ 1 ];
		}


		protected function initialize():void
		{
			//override	
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


		/**
		 * Get a list of all the building locations
		 */
		public function getPlayer0BuildingPositions():Vector.<Point>
		{
			return player0BuildingPositions;
		}


		/**
		 * Get a list of all the building locations
		 */
		public function getPlayer1BuildingPositions():Vector.<Point>
		{
			return player1BuildingPositions;
		}


		public function getUnitCollisionForce( gameLogics:GameLogics, unit:IUnit ):Force
		{
			return unitCollisionForceCalculator.getUnitCollisionForce( gameLogics, unit );
		}


		/**
		 * Returns the force in the direction of the closest path to the other side
		 */
		public function getMapPathForce( gameLogics:GameLogics, unit:IUnit, movingDirection:MapMovingDirection ):Force
		{
			var map:IForceFieldMap;

			if ( movingDirection == MapMovingDirection.RIGHT )
			{
				map = leftRightPathfinderForceFieldMap;

			}
			else
			{
				map = rightLeftPathfinderForceFieldMap;
			}

			return map.getPathForce( unit.getX() / tileWidth, unit.getY() / tileHeight );
		}


		/**
		 * Returns the force towards the closest walkable place
		 * If the ground under the unit is walkable this will return a zero length force
		 */
		public function getMapUnwalkableAreaForce( gameLogics:GameLogics, unit:IUnit, movingDirection:MapMovingDirection ):Force
		{
			var map:IForceFieldMap;

			if ( movingDirection == MapMovingDirection.RIGHT )
			{
				map = leftRightPathfinderForceFieldMap;

			}
			else
			{
				map = rightLeftPathfinderForceFieldMap;
			}

			return map.getUnwalkableAreaForce( unit.getX() / tileWidth, unit.getY() / tileHeight );
		}


		/**
		 * Get the tile map representation of the map
		 */
		public function getTileMapRepresentation():TileMap
		{
			return tileMapRepresentation;
		}


		public function getMapName():String
		{
			return this._mapName;
		}


		public function getPlayer0EndPoint():Point
		{
			return player0EndPoint;
		}


		public function getPlayer1EndPoint():Point
		{
			return player1EndPoint;
		}

	}
}
