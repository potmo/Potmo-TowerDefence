package com.potmo.tdm.visuals.map
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.player.PlayerColor;
	import com.potmo.tdm.visuals.map.forcemap.TileMap;
	import com.potmo.tdm.visuals.map.forcemap.astar.AStarMap;
	import com.potmo.tdm.visuals.map.forcemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.map.forcemap.forcefieldmap.astar.AStarForceFieldMap;
	import com.potmo.tdm.visuals.map.forcemap.forcefieldmap.unit.UnitCollisionForceCalculator;
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

		protected var checkpoints:Vector.<PathCheckpoint>;
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


		public function MapBase( visualMap:BitmapData, mapDataImage:BitmapData )
		{
			super();

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

			// setup checkpoints and stuff
			//TODO: Remove checkpoints in map
			this.setCheckpoints();
			this.drawCheckPoints();

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


		protected function drawCheckPoints():void
		{
			/*
			   var checkpoint:PathCheckpoint;
			   var lastCheckPoint:PathCheckpoint;

			   bitmapData.lock();

			   for each ( checkpoint in checkpoints )
			   {
			   BitmapUtil.drawCirlce( checkpoint.x, checkpoint.y, 5, 0xFFFFFFFF, bitmapData );

			   if ( lastCheckPoint )
			   {
			   BitmapUtil.drawLine( checkpoint.x, checkpoint.y, lastCheckPoint.x, lastCheckPoint.y, 0xFFFFFFFF, bitmapData );
			   }
			   lastCheckPoint = checkpoint;
			   }
			   bitmapData.unlock();*/

			var checkpoint:PathCheckpoint;
			var quad:Quad;

			for each ( checkpoint in checkpoints )
			{
				quad = new Quad( 10, 10, 0xFFFFFFFF );
				quad.x = checkpoint.x - 5;
				quad.y = checkpoint.y - 5;
				addChild( quad );
			}
		}


		protected function initialize():void
		{
			//override	
		}


		protected function setCheckpoints():void
		{
			throw new Error( "Override and set all the ceckpoints in checkpoints" );
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


		/**
		 * Get the next checkpoint to walk to
		 */
		/*
		   TODO: Comment in this function in Map and fix it

		   public function getNextCheckpoint( unit:UnitBase ):PathCheckpoint
		   {
		   var currentCheckpoint:PathCheckpoint = unit.getCurrentCheckpoint();

		   // if the current checkpoint is -1 then the unit does not know
		   // the next checkpoint and just wants to go to the closest
		   if ( !currentCheckpoint )
		   {
		   Logger.log( "Unit " + unit + " has no current checkpoint" );
		   return getNextCheckpointClosestAheadOfPointOnPathClosestToPoint( unit.x, unit.y, unit.getOwningPlayer() );
		   }

		   // ok we have a checkpoint then get the next
		   var checkpointId:int = currentCheckpoint.id;
		   var checkpointDir:int = 0;

		   if ( unit.getOwningPlayer().getColor() == PlayerColor.RED )
		   {
		   checkpointDir = +1;
		   }
		   else
		   {
		   checkpointDir = -1;
		   }

		   // step to the next checkpoint but dont make it owerflow
		   checkpointId = StrictMath.min( checkpoints.length - 1, StrictMath.max( checkpointId + checkpointDir, 0 ) );

		   return checkpoints[ checkpointId ];
		   }
		 */

		public function getClosestCheckpoint( unit:UnitBase ):PathCheckpoint
		{
			var checkpointDir:int = 0;
			var firstCheckPointId:int = 0;
			var lastCheckpointId:int = 0;

			if ( unit.getOwningPlayer().getColor() == PlayerColor.RED )
			{
				checkpointDir = +1;
				firstCheckPointId = 0;
				lastCheckpointId = checkpoints.length - 1;
			}
			else
			{
				checkpointDir = -1;
				firstCheckPointId = checkpoints.length - 1;
				lastCheckpointId = 0;
			}

			var checkpoint:PathCheckpoint;
			var best:int;
			var bestDist:Number = Number.MAX_VALUE;
			var currDist:Number = 0;

			var l:uint = checkpoints.length;

			var i:int = firstCheckPointId;

			while ( i != lastCheckpointId + checkpointDir )
			{

				checkpoint = checkpoints[ i ];

				// calculate distance. We dont need to square it since we only need to know witch is longest
				currDist = StrictMath.sqr( checkpoint.x - unit.x ) + StrictMath.sqr( checkpoint.y - unit.y );

				if ( currDist < bestDist )
				{
					best = i;
					bestDist = currDist;
				}

				i += checkpointDir;

			}

			return checkpoints[ best ];

		}


		public function getPointOnPathClosestToPoint( x:int, y:int ):Point
		{
			var a:PathCheckpoint = checkpoints[ 0 ];
			var b:PathCheckpoint;

			var c:int = checkpoints.length;
			var t:Number;
			var dSquared:Number;
			var p:Point = new Point();
			var bestPoint:Point;
			var bestDist:Number = Number.MAX_VALUE;

			for ( var i:int = 1; i < c; i++ )
			{
				b = checkpoints[ i ];

				// get the closest point on the line intersecting both checkpoints
				t = StrictMath.getTOnLineClosestToPoint( x, y, a.x, a.y, b.x, b.y );

				t = StrictMath.clamp( t, 0, 1 );

				//check if its even on the line section
				p.x = a.x + t * ( b.x - a.x );
				p.y = a.y + t * ( b.y - a.y );
				dSquared = StrictMath.sqr( p.x - x ) + StrictMath.sqr( p.y - y );

				if ( dSquared < bestDist )
				{
					bestDist = dSquared;
					bestPoint = p.clone();
				}

				a = b;
			}

			return bestPoint;
		}


		public function getNextCheckpointClosestAheadOfPointOnPathClosestToPoint( x:int, y:int, player:Player ):PathCheckpoint
		{

			var dir:int;
			var start:int;
			var end:int;

			if ( player.getColor() == PlayerColor.RED )
			{
				dir = +1;
				start = 0;
				end = checkpoints.length - 1;
			}
			else if ( player.getColor() == PlayerColor.BLUE )
			{
				dir = -1;
				start = checkpoints.length - 1;
				end = 0;
			}

			var c:int = checkpoints.length;
			var t:Number;
			var dSquared:Number;
			var p:Point = new Point();
			var bestDist:Number = Number.MAX_VALUE;
			var bestNextCheckpoint:PathCheckpoint;

			var a:PathCheckpoint = checkpoints[ start ];
			var b:PathCheckpoint;

			for ( var i:int = start + dir; i != end + dir; i += dir )
			{
				b = checkpoints[ i ];

				// get the closest point on the line intersecting both checkpoints
				t = StrictMath.getTOnLineClosestToPoint( x, y, a.x, a.y, b.x, b.y );

				// make t be on the line
				t = StrictMath.clamp( t, 0, 1 );

				// calculate the closest point on the line
				p.x = a.x + t * ( b.x - a.x );
				p.y = a.y + t * ( b.y - a.y );
				dSquared = StrictMath.sqr( p.x - x ) + StrictMath.sqr( p.y - y );

				if ( dSquared < bestDist )
				{
					bestDist = dSquared;
					bestNextCheckpoint = b;
				}

				a = b;
			}

			return bestNextCheckpoint;
		}


		/**
		 * get all the checkpoints that makes the road between the players
		 */
		protected function getPathCheckpoints():Vector.<PathCheckpoint>
		{
			throw new Error( "Override!" );
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

	}
}
