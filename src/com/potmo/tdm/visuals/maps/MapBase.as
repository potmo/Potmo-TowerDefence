package com.potmo.tdm.visuals.maps
{
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.player.PlayerColor;
	import com.potmo.tdm.visuals.units.UnitBase;
	import com.potmo.util.image.BitmapUtil;
	import com.potmo.util.math.StrictMath;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class MapBase extends Bitmap
	{

		protected var checkpoints:Vector.<PathCheckpoint>;


		public function MapBase( graphics:BitmapData )
		{
			super( graphics );
			this.initialize();
			this.setCheckpoints();
			this.drawCheckPoints();
			this.cacheAsBitmap = true;
		}


		protected function drawCheckPoints():void
		{
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
			bitmapData.unlock();
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
			var checkpoint:PathCheckpoint;
			var best:int;
			var bestDist:Number = Number.MAX_VALUE;
			var currDist:Number = 0;

			var l:uint = checkpoints.length;

			for ( var i:int = 0; i < l; i++ )
			{

				checkpoint = checkpoints[ i ];

				// calculate distance. We dont need to square it since we only need to know witch is longest
				currDist = StrictMath.sqr( checkpoint.x - unit.x ) + StrictMath.sqr( checkpoint.y - unit.y );

				if ( currDist < bestDist )
				{
					best = i;
					bestDist = currDist;
				}

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

			for ( var i:int = start + dir; i != end; i += dir )
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