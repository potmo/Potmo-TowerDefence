package com.potmo.tdm.visuals.unit
{
	import com.potmo.util.image.BitmapUtil;
	import com.potmo.util.math.StrictMath;

	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Spatial search structure for DisplayObject objects
	 *	var tree:QuadTree = new QuadTree(0, 0, stage.stageWidth, stage.stageHeight);
	 *	tree.insert(s1);
	 *	tree.insert(s2);
	 *
	 *	trace(tree.search(new Rectangle(10, 10, 61, 61)));
	 *
	 * @author Yannick (nl.yannickl88.util fount at http://pastebin.com/LF0MXPjt)
	 */
	public class UnitQuadTree
	{
		// minimum size of a subdivsion
		public static const MINSIZE:int = 10;

		private var _parent:UnitQuadTree;
		private var _x:int;
		private var _y:int;
		private var _width:int;
		private var _height:int;

		private var _objects:Vector.<IUnit>;
		private var _subdivisions:Vector.<UnitQuadTree>;


		//TODO: QuadTree objects should not be DisplayObject but some kind of interface that is better.
		// Maybe dirty objects should be stored in a list and updated at command instead of when unit moves through a function

		/**
		 * Constructor
		 *
		 * @param	int x
		 * @param	int y
		 * @param	int width
		 * @param	int height
		 * @param	QuadTree parent
		 */
		public function UnitQuadTree( x:int, y:int, width:int, height:int, parent:UnitQuadTree = null )
		{
			_parent = parent;
			_x = x;
			_y = y;
			_width = width;
			_height = height;
			_objects = new Vector.<IUnit>();
			_subdivisions = null;
		}


		/**
		 * Get the amount of nodes which fall in this section (note: also those in sub regions)
		 */
		public function get size():int
		{
			var total:int = 0;

			if ( _subdivisions != null )
			{
				total += _subdivisions[ 0 ].size + _subdivisions[ 1 ].size + _subdivisions[ 2 ].size + _subdivisions[ 3 ].size;
			}
			else
			{
				total += _objects.length;
			}

			return total;
		}


		/**
		 * get the width of this region
		 */
		public function get width():int
		{
			return _width;
		}


		/**
		 * get the height of this region
		 */
		public function get height():int
		{
			return _height;
		}


		/**
		 * get the x value of this region
		 */
		public function get x():int
		{
			return _x;
		}


		/**
		 * get the y value of this region
		 */
		public function get y():int
		{
			return _y;
		}


		/**
		 * Insert a DisplayObject into the tree
		 *
		 * @param	DisplayObject i
		 */
		public function insert( i:IUnit ):void
		{
			if ( _subdivisions == null )
			{
				if ( _objects.length > 0 && width > UnitQuadTree.MINSIZE * 2 && height > UnitQuadTree.MINSIZE * 2 )
				{
					_subdivide();
					_getSub( i.getX(), i.getY() ).insert( i );
				}
				else
				{
					_objects.push( i );
				}
			}
			else
			{
				_getSub( i.getX(), i.getY() ).insert( i );
			}
		}


		/**
		 * remove a DisplayObject from the tree
		 *
		 * @param	DisplayObject i
		 */
		public function remove( i:IUnit ):void
		{
			if ( _objects != null )
			{
				for ( var j:int = 0; j < _objects.length; j++ )
				{
					if ( _objects[ j ] == i )
					{
						_objects.splice( j, 1 );
						_fix();
						return;
					}
				}
			}
		}


		/**
		 * Notify the tree of an update of a node
		 *
		 * NOTE: this will just remove the node and reinsert it.
		 * @param	DisplayObject i
		 */
		/*	public function move( i:IUnit, x:int, y:int ):void
		   {
		   var s:UnitQuadTree = _getLeaf( i.x, i.y );
		   var s2:UnitQuadTree = _getLeaf( x, y );

		   if ( s != s2 )
		   {
		   s.remove( i );

		   i.x = x;
		   i.y = y;
		   insert( i );
		   }
		   else
		   {
		   i.x = x;
		   i.y = y;
		   }
		   }*/

		public function cleanPosition( unit:IUnit ):void
		{

			var leafbefore:UnitQuadTree = _getLeaf( unit.getOldX(), unit.getOldY() );
			var leafafter:UnitQuadTree = _getLeaf( unit.getX(), unit.getY() );

			if ( leafbefore != leafafter )
			{
				leafbefore.remove( unit );
				leafafter.insert( unit );
			}

			unit.setPositionAsClean();

		}


		/**
		 * Search for all nodes in a given rectangle
		 *
		 * NOTE: elements which lie on the right and below border will not be returned
		 *
		 * @param	Rectabgle r
		 * @return  Vector.<DisplayObject>
		 */
		public function search( boundx:Number, boundy:Number, boundw:Number, boundh:Number ):Vector.<IUnit>
		{

			if ( StrictMath.rectContainsRect( boundx, boundy, boundw, boundh, x, y, width, height ) )
			{
				return _getAll();
			}
			else if ( StrictMath.rectIntersectsRect( boundx, boundy, boundw, boundh, x, y, width, height ) )
			{
				var objects:Vector.<IUnit> = new Vector.<IUnit>();

				if ( _subdivisions != null )
				{
					objects = objects.concat( _subdivisions[ 0 ].search( boundx, boundy, boundw, boundh ), _subdivisions[ 1 ].search( boundx, boundy, boundw, boundh ), _subdivisions[ 2 ].search( boundx, boundy, boundw, boundh ), _subdivisions[ 3 ].search( boundx, boundy, boundw, boundh ) );
				}
				else
				{
					for each ( var o:IUnit in _objects )
					{
						var size:Number = o.getRadius() * 2;

						if ( size == 0 )
						{

							if ( StrictMath.rectContainsPoint( boundx, boundy, boundw, boundh, o.getX(), o.getY() ) )
							{
								objects.push( o );
							}
						}
						else
						{

							if ( StrictMath.rectIntersectsRect( boundx, boundy, boundw, boundh, o.getX(), o.getY(), size, size ) )
							{
								objects.push( o );
							}
						}
					}
				}

				return objects;
			}

			return new Vector.<IUnit>();
		}


		public function draw( canvas:BitmapData, scale:Number ):void
		{
			if ( _subdivisions != null )
			{
				_subdivisions[ 0 ].draw( canvas, scale );
				_subdivisions[ 1 ].draw( canvas, scale );
				_subdivisions[ 2 ].draw( canvas, scale );
				_subdivisions[ 3 ].draw( canvas, scale );
			}

			/*g.lineStyle( 1, 0x0078a0, 0.2 );
			   g.drawRect( x, y, width, height );
			 */
			BitmapUtil.drawRectangle( x * scale, y * scale, width * scale, height * scale, 0xFFFF0000, canvas );

			// draw all objects
			for each ( var unit:IUnit in _objects )
			{
				BitmapUtil.drawCirlce( unit.getX() * scale, unit.getY(), unit.getRadius() * scale, 0xFF0000FF, canvas );
			}
		}


		/**
		 * Find the section to which the DisplayObject belongs
		 *
		 * @param	DisplayObject i
		 * @return  QuadTree
		 */
		private function _find( i:IUnit ):UnitQuadTree
		{
			if ( _objects != null && _objects.indexOf( i ) >= 0 )
			{
				return this;
			}
			else if ( _subdivisions != null )
			{
				var s:UnitQuadTree = null;

				s = _subdivisions[ 0 ]._find( i );

				if ( s != null )
				{
					return s;
				}

				s = _subdivisions[ 1 ]._find( i );

				if ( s != null )
				{
					return s;
				}

				s = _subdivisions[ 2 ]._find( i );

				if ( s != null )
				{
					return s;
				}

				s = _subdivisions[ 3 ]._find( i );

				if ( s != null )
				{
					return s;
				}
			}

			return null;
		}


		/**
		 * Get all DisplayObject objects which fall into this region (and its subregions)
		 *
		 * @return	Vector.<DisplayObject>
		 */
		private function _getAll():Vector.<IUnit>
		{
			var objects:Vector.<IUnit> = new Vector.<IUnit>();

			if ( _subdivisions != null )
			{
				objects = objects.concat( _subdivisions[ 0 ]._getAll(), _subdivisions[ 1 ]._getAll(), _subdivisions[ 2 ]._getAll(), _subdivisions[ 3 ]._getAll() );
			}
			else
			{
				objects = objects.concat( _objects );
			}

			return objects;
		}


		/**
		 * Fix the tree by removing empty regions
		 */
		private function _fix():void
		{
			if ( _parent != null )
			{
				if ( _parent.size <= 1 )
				{
					_parent._fix();
					return;
				}
			}

			if ( size <= 1 )
			{
				var o:Vector.<IUnit> = new Vector.<IUnit>();
				o = o.concat( _getAll() );

				if ( _objects != null )
				{
					_objects.length = 0;
				}

				_objects = o;
				_subdivisions = null;
			}
		}


		/**
		 * Get a region based on x, y coordinate
		 *
		 * @param	int x
		 * @param	int y
		 * @return	QuadTree
		 */
		private function _getSub( x:int, y:int ):UnitQuadTree
		{
			if ( _subdivisions == null )
			{
				return null;
			}

			var i:int = -1;

			if ( x <= this.x + width / 2 )
			{
				i = 0;
			}
			else
			{
				i = 2;
			}

			if ( y <= this.y + height / 2 )
			{
				i += 0;
			}
			else
			{
				i += 1;
			}

			return _subdivisions[ i ];
		}


		/**
		 * Get a leaf region based on x, y coordinate
		 *
		 * @param	int x
		 * @param	int y
		 * @return	QuadTree
		 */
		private function _getLeaf( x:int, y:int ):UnitQuadTree
		{
			if ( _subdivisions == null )
			{
				return this;
			}
			else
			{
				return _getSub( x, y )._getLeaf( x, y );
			}
		}


		/**
		 * Subdevide this region into four new regions
		 */
		private function _subdivide():void
		{
			_subdivisions = new Vector.<UnitQuadTree>();
			_subdivisions.push( new UnitQuadTree( x, y, width / 2, height / 2, this ), new UnitQuadTree( x, y + height / 2, width / 2, height / 2, this ), new UnitQuadTree( x + width / 2, y, width / 2, height / 2, this ), new UnitQuadTree( x + width / 2, y + height / 2, width / 2, height / 2, this ) );

			for ( var i:int = 0; i < _objects.length; i++ )
			{
				var j:IUnit = _objects[ i ];
				_getSub( j.getX(), j.getY() ).insert( j );
			}

			_objects = null;
		}
	}

}
