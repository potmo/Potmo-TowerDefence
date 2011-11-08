package com.potmo.tdm.visuals.maps
{
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.player.PlayerColor;
	import com.potmo.tdm.visuals.units.UnitBase;
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


		public function MapBase( bitmap:BitmapData )
		{
			super();
			var textureParts:Vector.<Texture>;
			textureParts = splitBitmapIntoTextures( bitmap );

			var image:Image;
			var o:int = 0;

			for each ( var texture:Texture in textureParts )
			{
				image = new Image( texture );

				addChild( image );
				image.x = o;
				o += image.width;
			}

			this.initialize();
			this.setCheckpoints();
			this.drawCheckPoints();

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
			throw new Error( "Override!" );
		}


		/**
		 * Get a list of all the building locations
		 */
		public function getPlayer1BuildingPositions():Vector.<Point>
		{
			throw new Error( "Override!" );
		}


		/**
		 * Get the next checkpoint to walk to
		 */
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

			var a:PathCheckpoint = checkpoints[ start ];
			var b:PathCheckpoint;

			var c:int = checkpoints.length;
			var t:Number;
			var dSquared:Number;
			var p:Point = new Point();
			var bestDist:Number = Number.MAX_VALUE;
			var bestNextCheckpoint:PathCheckpoint;

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

	}
}
