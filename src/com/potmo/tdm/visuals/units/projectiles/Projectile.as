package com.potmo.tdm.visuals.units.projectiles
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.starling.TextureAnimation;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;
	import com.potmo.tdm.visuals.units.UnitBase;
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.MathUtil;
	import com.potmo.util.math.StrictMath;
	import com.potmo.util.spline.qubicHermite.Spline;

	import flash.geom.Point;

	public class Projectile extends TextureAnimation
	{
		public var type:ProjectileType;
		private var _velX:Number;
		private var _velY:Number;
		private var _targetX:Number;
		private var _targetY:Number;
		private var _altitude:Number;

		private var _trajectory:Vector.<Point>;
		private var _trajectoryFrame:int;
		private var _trajectoryFrames:int;

		//TODO: Do not hardcode speed of projectile. Use setting
		private static const SPEED:int = 40;


		public function Projectile( graphics:TextureAnimationCacheObject, type:ProjectileType )
		{
			this.type = type;
			super( graphics );
		}


		/**
		 * Launch the projectile
		 * @param fromX
		 * @param fromY
		 * @param toX
		 * @param toY
		 */
		public function launch( fromX:Number, fromY:Number, toX:Number, toY:Number ):void
		{
			Logger.log( "Launching: " + this + " from " + fromX + "," + fromY + " to " + toX + "," + toY );
			this.x = fromX;
			this.y = fromY;
			_targetX = toX;
			_targetY = toY;

			//TODO: Set speed from projectile type
			_trajectory = getTrajectory( fromX, fromY, toX, toY, SPEED );
			_trajectoryFrame = 0;
			_trajectoryFrames = _trajectory.length;

			if ( _trajectoryFrames >= 2 )
			{
				updateVelocity();
				updateAngle();
			}

		}


		private function updateAngle():void
		{
			this.rotation = -StrictMath.getAngle( _velX, _velY );

		}


		private function updateVelocity():void
		{
			_velX = _trajectory[ _trajectoryFrame + 1 ].x - _trajectory[ _trajectoryFrame ].x;
			_velY = _trajectory[ _trajectoryFrame + 1 ].y - _trajectory[ _trajectoryFrame ].y;
		}


		/**
		 * Get the trajectory from point a to point b with the speed of speed
		 */
		private function getTrajectory( ax:Number, ay:Number, bx:Number, by:Number, speed:Number ):Vector.<Point>
		{

			// get difference
			var dx:Number = bx - ax;
			var dy:Number = by - ay;

			var dist:Number = StrictMath.get2DLength( dx, dy );

			// get halfway
			var hx:Number = ax + dx / 2;
			var hy:Number = ay + dy / 2;

			// get a point slightly above
			var tx:Number = hx;
			var ty:Number = hy - dist / 4;

			// get the handles for curve
			var hx1:Number = 0; //( tx - ax ) / 3;
			var hy1:Number = 0; //ty - ay;
			var hx2:Number = 0; //( bx - tx ) / 3;
			var hy2:Number = 0; //by - ty;

			var n:int = dist / speed;
			var part1:Vector.<Point> = Spline.cubicHermiteSpline( n, ax, ay, tx, ty, hx1, hy1, dx, dy );
			var part2:Vector.<Point> = Spline.cubicHermiteSpline( n, tx, ty, bx, by, dx, dy, hx2, hy2 );
			var points:Vector.<Point> = part1.concat( part2 );

			return points;
		}


		/**
		 * Calculates the time the projectile will take to reach a point from another point in frames
		 */
		public static function getTimeToHitTarget( fromX:Number, fromY:Number, toX:Number, toY:Number ):int
		{
			//TODO: Calculation to hit target should also take type of projectile
			var dx:Number = toX - fromX;
			var dy:Number = toY - fromY;

			var dist:Number = StrictMath.get2DLength( dx, dy );
			var n:int = dist / SPEED;

			return n * 2;
		}


		public function update( gameLogics:GameLogics ):void
		{

			_trajectoryFrame++;

			if ( _trajectoryFrame < _trajectoryFrames - 1 )
			{

				updateVelocity();
				updateAngle();

				var trajectoryPos:Point = _trajectory[ _trajectoryFrame ];
				this.x = trajectoryPos.x;
				this.y = trajectoryPos.y;

			}
			else
			{
				this.x = _targetX;
				this.y = _targetY;
					//TODO: Projectile should hurt units in close enough range
			}

		}


		public function reset():void
		{
			_velX = 0;
			_velY = 0;

			_trajectory = null;
		}
	}
}
