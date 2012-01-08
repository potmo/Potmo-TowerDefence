package com.potmo.tdm.visuals.map
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.player.PlayerColor;
	import com.potmo.tdm.visuals.map.tilemap.TileMap;
	import com.potmo.tdm.visuals.map.tilemap.astar.AStarMap;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.astar.AStarForceFieldMap;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.unit.UnitCollisionForceCalculator;
	import com.potmo.tdm.visuals.map.util.MapImageAnalyzer;
	import com.potmo.tdm.visuals.unit.IUnit;
	import com.potmo.tdm.visuals.unit.UnitBase;
	import com.potmo.tdm.visuals.unit.state.variant.IDeployingUnit;
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;

	public class MapBase extends DisplayObjectContainer
	{

		protected var mapImageAnalyzer:MapImageAnalyzer;
		protected var unitCollisionForceCalculator:UnitCollisionForceCalculator;
		protected var tileMapRepresentation:TileMap;
		protected var aStarMapRepresentation:AStarMap;

		protected var player0EndPoint:Point;
		protected var player1EndPoint:Point;
		protected var player0BuildingPositions:Vector.<Point>;
		protected var player1BuildingPositions:Vector.<Point>;
		protected var player0AStarForceFieldMap:AStarForceFieldMap;
		protected var player1AStarForceFieldMap:AStarForceFieldMap;
		protected var tileWidth:Number;
		protected var tileHeight:Number;
		private var mapName:String;


		public function MapBase( visualMap:BitmapData, mapDataImage:BitmapData, name:String )
		{
			super();

			this.mapName = name;
			// setup a device to analyze an image and get data from it
			mapImageAnalyzer = new MapImageAnalyzer();

			// calculate the scale between tile and visual map
			tileWidth = visualMap.width / mapDataImage.width;
			tileHeight = visualMap.height / mapDataImage.height;

			// configure endpoints
			this.setEndPoints( mapDataImage, visualMap, tileWidth );

			// configure buildingpositions
			this.setBuildingPositions( mapDataImage, visualMap, tileWidth );

			// create a object that can calculate the forces on a unit
			unitCollisionForceCalculator = new UnitCollisionForceCalculator();

			// create a representation of the map in tiles
			tileMapRepresentation = mapImageAnalyzer.createMap( mapDataImage, tileWidth, tileHeight );

			// create a representation for the aStar
			// this will help to calculate shortest routes from one point to another
			aStarMapRepresentation = new AStarMap();
			aStarMapRepresentation.loadFromMap( tileMapRepresentation );

			// create a force AStar fieldmap for the players
			// this will make it possible to know the shortest route from anywhere to the endpoint			
			player0AStarForceFieldMap = new AStarForceFieldMap();
			player0AStarForceFieldMap.setupFromAStarMap( aStarMapRepresentation, player0EndPoint.x / tileWidth, player0EndPoint.y / tileHeight, false );

			player1AStarForceFieldMap = new AStarForceFieldMap();
			player1AStarForceFieldMap.setupFromAStarMap( aStarMapRepresentation, player1EndPoint.x / tileWidth, player1EndPoint.y / tileHeight, false );
			//TODO: All force fields should be stored in a image for later loading so we do not have to generate it each time we start a map

			// set up the background visuals
			this.setupBackground( visualMap )

			// tell subclasses to initialize
			this.initialize();

		}


		private function setupBackground( visualMap:BitmapData ):void
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
		}


		private function splitBitmapIntoTextures( bitmap:BitmapData ):Vector.<Texture>
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

		}


		protected function setEndPoints( mapDataImage:BitmapData, visualMap:BitmapData, scale:Number ):void
		{
			var endpoints:Vector.<Point> = mapImageAnalyzer.getEndPoints( mapDataImage, scale );
			player0EndPoint = endpoints[ 0 ];
			player1EndPoint = endpoints[ 1 ];

		}


		protected function setBuildingPositions( mapDataImage:BitmapData, visualMap:BitmapData, scale:Number ):void
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
		public function getMapSize():uint
		{
			return this.width;
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


		public function getMapPathForce( gameLogics:GameLogics, unit:IUnit ):Force
		{
			if ( unit.getOwningPlayer().getColor() == PlayerColor.RED )
			{
				return player0AStarForceFieldMap.getForce( unit.getX() / tileWidth, unit.getY() / tileHeight );
			}
			else
			{
				return player1AStarForceFieldMap.getForce( unit.getX() / tileWidth, unit.getY() / tileHeight );
			}
		}


		/**
		 * Get the tile map representation of the map
		 */
		public function getTileMapRepresentation():TileMap
		{
			return tileMapRepresentation;
		}


		/**
		 * Get the AStar tile map representation of the map
		 */
		public function getAStarMapRepresentation():AStarMap
		{
			return aStarMapRepresentation;
		}


		public function getPlayer0AStarForceFieldMapRepresentation():AStarForceFieldMap
		{
			return player0AStarForceFieldMap;
		}


		public function getPlayer1AStarForceFieldMapRepresentation():AStarForceFieldMap
		{
			return player1AStarForceFieldMap;
		}


		public function getMapName():String
		{
			return this.mapName;
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
