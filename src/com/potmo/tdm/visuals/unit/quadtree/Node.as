package com.potmo.tdm.visuals.unit.quadtree
{
	import com.potmo.tdm.visuals.unit.IUnit;
	import com.potmo.util.image.BitmapUtil;
	import com.potmo.util.math.StrictMath;

	import flash.display.BitmapData;

	public class Node
	{
		private static const TOP_LEFT:int = 0;
		private static const TOP_RIGHT:int = 1;
		private static const BOTTOM_LEFT:int = 2;
		private static const BOTTOM_RIGHT:int = 3;

		private var x:Number;
		private var y:Number;
		private var width:Number;
		private var height:Number;
		private var depth:int; // the current depth of this node
		private var maxDepth:int; // the maximum number of times we can subdivide the node from the root level
		private var maxChildren:int; // the max number of children we have in one node
		private var children:Vector.<IUnit>; // the children that are in this node. Typically if this is a leaf node
		private var nodes:Vector.<Node>; // all the subnodes
		private var stuckChildren:Vector.<IUnit>; // theese are children that are in multiple subnodes
		private var parent:Node; // the parent node


		public function Node( x:Number, y:Number, width:Number, height:Number, depth:int, maxDepth:int, maxChildren:int, parent:Node )
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			this.depth = depth;
			this.maxDepth = maxDepth;
			this.maxChildren = maxChildren;
			this.parent = parent;

			this.children = new Vector.<IUnit>();
			this.nodes = new Vector.<Node>();
			this.stuckChildren = new Vector.<IUnit>();

		}


		public function remove( unit:IUnit ):void
		{
			var index:int;

			//check if it is in the stuck first
			index = stuckChildren.indexOf( unit );

			if ( index != -1 )
			{
				// yes it was.
				stuckChildren.splice( index, 1 );
				return;
			}

			// check if I'm a leaf. Otherwise I might have the children
			if ( nodes.length == 0 )
			{
				index = children.indexOf( unit );

				if ( index != -1 )
				{
					children.splice( index, 1 );

					// remove unused nodes
					fix();
					return;
				}
			}
			else
			{

				// okay we come this far so it might be in a subnode
				// find the node it is in
				index = findSubnodeIndex( unit.getOldX(), unit.getOldY() );

				if ( index == -1 )
				{
					throw new Error( "can not find index in node when removing" );
				}
				nodes[ index ].remove( unit );
			}

		}


		private function fix():void
		{
			// if the combined numer of children in the subnodes 
			// is empty then we should combine the nodes
			if ( getNumberOfSubnodeChildren() == 0 )
			{
				combineSubnodes();

				if ( parent )
				{
					parent.fix();
				}
			}
		}


		private function combineSubnodes():void
		{

			if ( nodes )
			{
				// copy and clear the nodes
				var copyNodes:Vector.<Node> = nodes.concat();
				nodes.length = 0;

				var copyNodesLength:int = copyNodes.length;

				for ( var i:int = 0; i < copyNodesLength; i++ )
				{
					var node:Node = copyNodes[ i ];
					node.combineSubnodes();
					var unit:IUnit;

					var nodeChildrenLength:int = node.children.length;

					for ( var j:int = 0; j < nodeChildrenLength; j++ )
					{
						unit = node.children[ j ];
						this.insert( unit );
					}

					var nodeStuckChildrenLength:int = node.stuckChildren.length;

					for ( var k:int = 0; k < nodeStuckChildrenLength; k++ )
					{
						unit = node.stuckChildren[ k ];
						this.insert( unit );
					}
				}
			}

		}


		private function getNumberOfSubnodeChildren():int
		{
			var num:int = children.length;

			if ( nodes && nodes.length != 0 )
			{
				var nodeLength:int = nodes.length;

				for ( var i:int = 0; i < nodeLength; i++ )
				{
					num += nodes[ i ].getNumberOfSubnodeChildren();
				}
			}
			else
			{
				// this is a leaf
				return children.length + stuckChildren.length;
			}

			return num;
		}


		public function insert( unit:IUnit ):void
		{

			if ( nodes.length != 0 )
			{
				// this should be put in a subnode
				var index:int = findSubnodeIndex( unit.getOldX(), unit.getOldY() );

				if ( index == -1 )
				{
					throw new Error( "can not find index in node when insterting" );
				}

				var node:Node = nodes[ index ];

				//if ( unit.getOldX() - unit.getRadius() >= node.x && unit.getOldX() - unit.getRadius() <= node.x + node.width && unit.getOldY() >= node.y && unit.getOldY() + unit.getRadius() * 2 <= node.y + node.height )
				//if ( unit.getOldX() >= node.x && unit.getOldX() + unit.getRadius() * 2 <= node.x + node.width && unit.getOldY() >= node.y && unit.getOldY() + unit.getRadius() * 2 <= node.y + node.height )
				if ( StrictMath.rectContainsRect( node.x, node.y, node.width, node.height, unit.getOldX() - unit.getRadius(), unit.getOldY() - unit.getRadius(), unit.getRadius() * 2, unit.getRadius() * 2 ) )
				{
					// put in subnode
					nodes[ index ].insert( unit );
				}
				else
				{
					// could not be put in a subnode so put it in the stuck nodes
					stuckChildren.push( unit );
				}

				return;

			}

			// this should be in myself, I'm a leaf. Not a subnode
			children.push( unit );
			var len:uint = children.length;

			// check if we should subdivide
			if ( depth <= maxDepth && len > this.maxChildren )
			{
				// subdivide
				this.subdivide();

				// put in newly created subnodes
				for ( var i:int = 0; i < len; i++ )
				{
					insert( children[ i ] );
				}

				// clear children
				children.length = 0;
			}

		}


		public function getChildren():Vector.<IUnit>
		{
			return children.concat( stuckChildren );
		}


		public function retrieveFromPosition( x:Number, y:Number ):Vector.<IUnit>
		{
			var out:Vector.<IUnit> = new Vector.<IUnit>();

			if ( nodes.length != 0 )
			{
				var index:int = findSubnodeIndex( x, y );

				if ( index != -1 )
				{
					out = out.concat( nodes[ index ].retrieveFromPosition( x, y ) );
				}
			}

			out = out.concat( stuckChildren );
			out = out.concat( children );

			return out;
		}


		public function retrieveFromRect( x:Number, y:Number, width:Number, height:Number ):Vector.<IUnit>
		{

			// check if the bounding box is containg all the node
			if ( StrictMath.rectContainsRect( x, y, width, height, this.x, this.y, this.width, this.height ) )
			{
				// just return all the children
				return getAllChildrenRecursive();
			}

			var out:Vector.<IUnit> = new Vector.<IUnit>();

			// check if it intersects the rect (does not have to be all of the rect)
			if ( StrictMath.rectIntersectsRect( x, y, width, height, this.x, this.y, this.width, this.height ) )
			{
				// First add my children
				out = out.concat( getChildren() );

				// then add the subnodes if we should
				var nodeLength:int = nodes.length;

				for ( var i:int = 0; i < nodeLength; i++ )
				{

					out = out.concat( nodes[ i ].retrieveFromRect( x, y, width, height ) );
				}
			}

			return out;

		}


		private function getAllChildrenRecursive():Vector.<IUnit>
		{
			var out:Vector.<IUnit> = new Vector.<IUnit>();
			out = out.concat( getChildren() );

			var nodeLength:int = nodes.length;

			for ( var i:int = 0; i < nodeLength; i++ )
			{
				out = out.concat( nodes[ i ].getAllChildrenRecursive() );
			}
			return out;
		}


		private function subdivide():void
		{
			var depth:int = this.depth + 1;

			var bx:Number = this.x;
			var by:Number = this.y;

			//floor the values
			var b_w_h:Number = this.width / 2;
			var b_h_h:Number = this.height / 2;
			var bx_b_w_h:Number = bx + b_w_h;
			var by_b_h_h:Number = by + b_h_h;

			this.nodes = new Vector.<Node>( 4, false );

			//top left
			this.nodes[ TOP_LEFT ] = new Node( bx, by, b_w_h, b_h_h, depth, maxDepth, maxChildren, this );

			//top right
			this.nodes[ TOP_RIGHT ] = new Node( bx_b_w_h, by, b_w_h, b_h_h, depth, maxDepth, maxChildren, this );

			//bottom left
			this.nodes[ BOTTOM_LEFT ] = new Node( bx, by_b_h_h, b_w_h, b_h_h, depth, maxDepth, maxChildren, this );

			//bottom right
			this.nodes[ BOTTOM_RIGHT ] = new Node( bx_b_w_h, by_b_h_h, b_w_h, b_h_h, depth, maxDepth, maxChildren, this );
		}


		private function findSubnodeIndex( x:Number, y:Number ):int
		{
			if ( !StrictMath.rectContainsPoint( this.x, this.y, this.width, this.height, x, y ) )
			{
				return -1;
			}

			var left:Boolean = ( x > this.x + width / 2 ) ? false : true;
			var top:Boolean = ( y > this.y + height / 2 ) ? false : true;

			//top left
			var index:int = TOP_LEFT;

			if ( left )
			{
				//left side
				if ( !top )
				{
					//bottom left
					index = BOTTOM_LEFT;
				}
			}
			else
			{
				//right side
				if ( top )
				{
					//top right
					index = TOP_RIGHT;
				}
				else
				{
					//bottom right
					index = BOTTOM_RIGHT;
				}
			}

			return index;
		}


		public function draw( canvas:BitmapData, scale:Number ):void
		{
			BitmapUtil.drawRectangle( x * scale, y * scale, width * scale, height * scale, 0xFF333333, canvas );

			if ( nodes.length > 0 )
			{
				for each ( var node:Node in nodes )
				{
					node.draw( canvas, scale );
				}
			}

			var unit:IUnit;
			var totChildren:int = 0;

			for each ( unit in children )
			{
				BitmapUtil.drawCirlce( unit.getX() * 1, unit.getY() * 1, unit.getRadius() * 1, 0xFF0000FF, canvas );
				totChildren++;
			}

			for each ( unit in stuckChildren )
			{
				BitmapUtil.drawCirlce( unit.getX() * 1, unit.getY() * 1, unit.getRadius() * 1, 0xFFFF0000, canvas );
				totChildren++;
			}

			BitmapUtil.drawQuickTextOnBitmapData( canvas, totChildren.toString(), x + width / 2, y + height / 2 + 10, 0xFFFF00FF, 15 );

			BitmapUtil.drawQuickTextOnBitmapData( canvas, depth.toString(), x + width / 2, y + height / 2, 0xFFFFFFFF, 15 );

		}

	}
}
