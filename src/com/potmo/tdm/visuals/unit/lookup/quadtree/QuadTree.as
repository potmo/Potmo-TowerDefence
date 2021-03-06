package com.potmo.tdm.visuals.unit.lookup.quadtree
{
	import com.potmo.tdm.visuals.unit.Unit;

	import flash.display.BitmapData;

	// from Mike Chambers JS QuadTree
	//https://github.com/mikechambers/ExamplesByMesh/blob/master/JavaScript/QuadTree/src/QuadTree.js

	//TODO: This is far too slow. Needs to optimize
	public class QuadTree
	{
		private var root:Node;


		public function QuadTree( x:Number, y:Number, width:Number, height:Number, maxDepth:int, maxChildren:int )
		{
			// create the root node			
			root = new Node( x, y, width, height, 0, maxDepth, maxChildren, null );
		}


		public function insert( unit:Unit ):void
		{
			root.insert( unit );
		}


		public function remove( unit:Unit ):void
		{
			root.remove( unit );
			unit.setPositionAsClean();
		}


		public function retriveFromPosition( x:Number, y:Number ):Vector.<Unit>
		{
			return root.retrieveFromPosition( x, y );
		}


		public function retriveFromRect( x:Number, y:Number, width:Number, height:Number ):Vector.<Unit>
		{
			return root.retrieveFromRect( x, y, width, height );
		}


		public function draw( canvas:BitmapData, scale:Number ):void
		{
			root.draw( canvas, scale );

		}


		public function cleanPosition( unit:Unit ):void
		{
			// we should remove from the old node and then update new to old and then add
			var removed:Boolean = root.remove( unit );

			if ( !removed )
			{
				removed = root.searchHarderAndRemove( unit );

				if ( !removed )
				{
					throw new Error( "Could not remove" );
				}
			}
			unit.setPositionAsClean();

			var inserted:Boolean = root.insert( unit );

			if ( !inserted )
			{
				throw new Error( "Could not insert" );
			}

		}
	}
}
