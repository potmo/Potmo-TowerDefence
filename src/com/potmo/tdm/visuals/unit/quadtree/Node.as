package com.potmo.tdm.visuals.unit.quadtree
{
	import com.potmo.tdm.visuals.unit.Unit;
	import com.potmo.util.image.BitmapUtil;
	import com.potmo.util.math.StrictMath;

	import flash.display.BitmapData;

	public class Node
	{
		private static const TOP_LEFT:int = 0;
		private static const TOP_RIGHT:int = 1;
		private static const BOTTOM_LEFT:int = 2;
		private static const BOTTOM_RIGHT:int = 3;

		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		private var _depth:int; // the current depth of this node
		private var _maxDepth:int; // the maximum number of times we can subdivide the node from the root level
		private var _maxChildren:int; // the max number of children we have in one node
		private var _children:Vector.<Unit>; // the children that are in this node. Typically if this is a leaf node
		private var _nodes:Vector.<Node>; // all the subnodes
		private var _stuckChildren:Vector.<Unit>; // theese are children that are in multiple subnodes
		private var _parent:Node; // the parent node


		public function Node( x:Number, y:Number, width:Number, height:Number, depth:int, maxDepth:int, maxChildren:int, parent:Node )
		{
			this._x = x;
			this._y = y;
			this._width = width;
			this._height = height;
			this._depth = depth;
			this._maxDepth = maxDepth;
			this._maxChildren = maxChildren;
			this._parent = parent;

			this._children = new Vector.<Unit>();
			this._nodes = new Vector.<Node>();
			this._stuckChildren = new Vector.<Unit>();

		}


		/**
		 * @returns true if removed else false
		 */
		public function remove( unit:Unit ):Boolean
		{
			var index:int;

			//check if it is in the stuck first
			index = _stuckChildren.indexOf( unit );

			if ( index != -1 )
			{
				// yes it was.
				_stuckChildren.splice( index, 1 );
				return true;
			}

			// check if I'm a leaf. Otherwise I might have the children
			if ( _nodes.length == 0 )
			{
				index = _children.indexOf( unit );

				if ( index != -1 )
				{
					_children.splice( index, 1 );

					// remove unused nodes
					fix();
					return true;
				}
			}
			else
			{

				// okay we come this far so it might be in a subnode
				// find the node it is in
				index = findSubnodeIndex( unit.getOldX(), unit.getOldY() );

				if ( index != -1 )
				{
					_nodes[ index ].remove( unit );
					return true;
				}

			}

			// could not find it
			return false;

		}


		private function fix():void
		{
			// if the combined numer of children in the subnodes 
			// is empty then we should combine the nodes
			if ( getNumberOfSubnodeChildren() == 0 )
			{
				combineSubnodes();

				if ( _parent )
				{
					_parent.fix();
				}
			}
		}


		private function combineSubnodes():void
		{

			if ( _nodes )
			{
				// copy and clear the nodes
				var copyNodes:Vector.<Node> = _nodes.concat();
				_nodes.length = 0;

				var copyNodesLength:int = copyNodes.length;

				for ( var i:int = 0; i < copyNodesLength; i++ )
				{
					var node:Node = copyNodes[ i ];
					node.combineSubnodes();
					var unit:Unit;

					var nodeChildrenLength:int = node._children.length;

					for ( var j:int = 0; j < nodeChildrenLength; j++ )
					{
						unit = node._children[ j ];
						this.insert( unit );
					}

					var nodeStuckChildrenLength:int = node._stuckChildren.length;

					for ( var k:int = 0; k < nodeStuckChildrenLength; k++ )
					{
						unit = node._stuckChildren[ k ];
						this.insert( unit );
					}
				}
			}

		}


		private function getNumberOfSubnodeChildren():int
		{
			var num:int = _children.length;

			if ( _nodes && _nodes.length != 0 )
			{
				var nodeLength:int = _nodes.length;

				for ( var i:int = 0; i < nodeLength; i++ )
				{
					num += _nodes[ i ].getNumberOfSubnodeChildren();
				}
			}
			else
			{
				// this is a leaf
				return _children.length + _stuckChildren.length;
			}

			return num;
		}


		public function insert( unit:Unit ):Boolean
		{

			if ( _nodes.length != 0 )
			{
				// this should be put in a subnode
				var index:int = findSubnodeIndex( unit.getOldX(), unit.getOldY() );

				if ( index == -1 )
				{
					return false;
				}

				var node:Node = _nodes[ index ];

				//if ( unit.getOldX() - unit.getRadius() >= node.x && unit.getOldX() - unit.getRadius() <= node.x + node.width && unit.getOldY() >= node.y && unit.getOldY() + unit.getRadius() * 2 <= node.y + node.height )
				//if ( unit.getOldX() >= node.x && unit.getOldX() + unit.getRadius() * 2 <= node.x + node.width && unit.getOldY() >= node.y && unit.getOldY() + unit.getRadius() * 2 <= node.y + node.height )
				if ( StrictMath.rectContainsRect( node._x, node._y, node._width, node._height, unit.getOldX() - unit.getRadius(), unit.getOldY() - unit.getRadius(), unit.getRadius() * 2, unit.getRadius() * 2 ) )
				{
					// put in subnode
					return _nodes[ index ].insert( unit );
				}
				else
				{
					// could not be put in a subnode so put it in the stuck nodes
					_stuckChildren.push( unit );
					return true;
				}

				// should never come here
				return false;

			}
			else
			{

				// this should be in myself, I'm a leaf. Not a subnode
				_children.push( unit );

				var len:uint = _children.length;

				// check if we should subdivide
				if ( _depth <= _maxDepth && len > this._maxChildren )
				{
					// subdivide
					this.subdivide();

					// put all old children in newly created subnodes
					var oldChildren:Vector.<Unit> = _children.concat(); // clone
					_children.length = 0;

					for ( var i:int = 0; i < len; i++ )
					{
						var inserted:Boolean = insert( oldChildren[ i ] );

						if ( inserted )
						{
							return true;
						}
					}
				}
				else
				{
					return true;
				}
			}

			// should never come here
			return false;

		}


		public function getChildren():Vector.<Unit>
		{
			return _children.concat( _stuckChildren );
		}


		public function retrieveFromPosition( x:Number, y:Number ):Vector.<Unit>
		{
			var out:Vector.<Unit> = new Vector.<Unit>();

			if ( _nodes.length != 0 )
			{
				var index:int = findSubnodeIndex( x, y );

				if ( index != -1 )
				{
					out = out.concat( _nodes[ index ].retrieveFromPosition( x, y ) );
				}
			}

			out = out.concat( _stuckChildren );
			out = out.concat( _children );

			return out;
		}


		public function retrieveFromRect( x:Number, y:Number, width:Number, height:Number ):Vector.<Unit>
		{

			// check if the bounding box is containg all the node
			if ( StrictMath.rectContainsRect( x, y, width, height, this._x, this._y, this._width, this._height ) )
			{
				// just return all the children
				return getAllChildrenRecursive();
			}

			var out:Vector.<Unit> = new Vector.<Unit>();

			// check if it intersects the rect (does not have to be all of the rect)
			if ( StrictMath.rectIntersectsRect( x, y, width, height, this._x, this._y, this._width, this._height ) )
			{
				// First add my children
				out = out.concat( getChildren() );

				// then add the subnodes if we should
				var nodeLength:int = _nodes.length;

				for ( var i:int = 0; i < nodeLength; i++ )
				{

					out = out.concat( _nodes[ i ].retrieveFromRect( x, y, width, height ) );
				}
			}

			return out;

		}


		private function getAllChildrenRecursive():Vector.<Unit>
		{
			var out:Vector.<Unit> = new Vector.<Unit>();
			out = out.concat( getChildren() );

			var nodeLength:int = _nodes.length;

			for ( var i:int = 0; i < nodeLength; i++ )
			{
				out = out.concat( _nodes[ i ].getAllChildrenRecursive() );
			}
			return out;
		}


		private function subdivide():void
		{
			var depth:int = this._depth + 1;

			var bx:Number = this._x;
			var by:Number = this._y;

			//floor the values
			var b_w_h:Number = this._width / 2;
			var b_h_h:Number = this._height / 2;
			var bx_b_w_h:Number = bx + b_w_h;
			var by_b_h_h:Number = by + b_h_h;

			this._nodes = new Vector.<Node>( 4, false );

			//top left
			this._nodes[ TOP_LEFT ] = new Node( bx, by, b_w_h, b_h_h, depth, _maxDepth, _maxChildren, this );

			//top right
			this._nodes[ TOP_RIGHT ] = new Node( bx_b_w_h, by, b_w_h, b_h_h, depth, _maxDepth, _maxChildren, this );

			//bottom left
			this._nodes[ BOTTOM_LEFT ] = new Node( bx, by_b_h_h, b_w_h, b_h_h, depth, _maxDepth, _maxChildren, this );

			//bottom right
			this._nodes[ BOTTOM_RIGHT ] = new Node( bx_b_w_h, by_b_h_h, b_w_h, b_h_h, depth, _maxDepth, _maxChildren, this );

		}


		private function findSubnodeIndex( x:Number, y:Number ):int
		{
			if ( !StrictMath.rectContainsPoint( this._x, this._y, this._width, this._height, x, y ) )
			{
				return -1;
			}

			var left:Boolean = ( x > this._x + _width / 2 ) ? false : true;
			var top:Boolean = ( y > this._y + _height / 2 ) ? false : true;

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
			BitmapUtil.drawRectangle( _x * scale, _y * scale, _width * scale, _height * scale, 0xFF333333, canvas );

			if ( _nodes.length > 0 )
			{
				for each ( var node:Node in _nodes )
				{
					node.draw( canvas, scale );
				}
			}

			var unit:Unit;
			var totChildren:int = 0;

			for each ( unit in _children )
			{
				BitmapUtil.drawCirlce( unit.getX() * 1, unit.getY() * 1, unit.getRadius() * 1, 0xFF0000FF, canvas );
				totChildren++;
			}

			for each ( unit in _stuckChildren )
			{
				BitmapUtil.drawCirlce( unit.getX() * 1, unit.getY() * 1, unit.getRadius() * 1, 0xFFFF0000, canvas );
				totChildren++;
			}

			BitmapUtil.drawQuickTextOnBitmapData( canvas, totChildren.toString(), _x + _width / 2, _y + _height / 2 + 10, 0xFFFF00FF, 15 );

			BitmapUtil.drawQuickTextOnBitmapData( canvas, _depth.toString(), _x + _width / 2, _y + _height / 2, 0xFFFFFFFF, 15 );

		}


		public function searchHarderAndRemove( unit:Unit ):Boolean
		{
			var child:Unit;
			var num:int;
			var index:int;
			index = _stuckChildren.indexOf( unit );

			if ( index != -1 )
			{
				_stuckChildren.splice( index, 1 );
				return true;
			}

			index = _children.indexOf( unit );

			if ( index != -1 )
			{
				_children.splice( index, 1 );
				return true;
			}

			num = _nodes.length;

			for ( var i:int = 0; i < num; i++ )
			{
				var removed:Boolean = _nodes[ i ].searchHarderAndRemove( unit );

				if ( removed )
				{
					return true;
				}
			}

			return false;
		}
	}
}
