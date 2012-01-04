package com.potmo.tdm.visuals.map.forcemap.forcefieldmap
{
	import com.potmo.util.math.StrictMath;

	public class Force
	{
		public var x:Number;
		public var y:Number;
		private var _length:Number;
		private var _lengthDirty:Boolean = true;


		public function Force( x:Number = 0, y:Number = 0 )
		{
			this.x = x;
			this.y = y;
			_lengthDirty = true;
		}


		public function get length():Number
		{
			if ( _lengthDirty )
			{
				_length = StrictMath.get2DLength( x, y );
				_lengthDirty = false;
			}
			return _length;
		}


		public function add( force:Force ):void
		{
			this.x += force.x;
			this.y += force.y;
			_lengthDirty = true;
		}


		public function clone():Force
		{
			return new Force( x, y );
		}


		public function normalize():void
		{
			var l:Number = this.length;

			this.x /= l;
			this.y /= l;

			_lengthDirty = true;
		}


		public function scale( scalar:Number ):void
		{
			this.x *= scalar;
			this.y *= scalar;

			_lengthDirty = true;
		}


		public function toUint():uint
		{
			// this only works with forces with magnitudes less than 1
			if ( length > 1 )
			{
				throw new Error( "can only convert unit forces with magnitues less or equal to 1: " + length );
			}

			// we have totally 4 294 967 295 (0xFFFFFFFF) in a uint
			// the upper half goes to x coordinate 
			// 0xFFFF0000 mask
			// the lower half goes to y coordinate
			// 0x0000FFFF mask
			// one part can hold 65 535 (0xFFFF) and half of that is 32 767.5 (trunced gives 32767 (0x7FFF))
			// if a value 322767 or less its a negative number otherwise its a positive number

			const QUARTER:uint = 0x7FFF;
			var iX:uint = QUARTER + QUARTER * x; // convert the x value
			var iY:uint = QUARTER + QUARTER * y; // convert the y value

			// shift x value 16 bits to left and mask in y value
			var result:uint = iX << 16 & iY;

			return result;
		}


		public static function fromUint( value:uint ):Force
		{
			const QUARTER:uint = 0x7FFF;
			var iX:uint = value >> 16;
			var iY:uint = value & QUARTER;

			iX -= QUARTER;
			iY -= QUARTER;

			var x:Number = iX / QUARTER;
			var y:Number = iY / QUARTER;

			var force:Force = new Force( x, y );
			return force;
		}


		public function addComponents( x:Number, y:Number ):void
		{
			this.x += x;
			this.y += y;
			_lengthDirty = true;
		}


		public function subtractComponents( x:Number, y:Number ):void
		{
			this.x -= x;
			this.y -= y;
			_lengthDirty = true;
		}

	}
}
