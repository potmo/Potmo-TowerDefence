package com.potmo.tdm.visuals.map.tilemap.forcefieldmap.unit
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.unit.Unit;
	import com.potmo.tdm.visuals.unit.UnitManager;
	import com.potmo.util.math.StrictMath;

	public class UnitCollisionForceCalculator
	{

		public function UnitCollisionForceCalculator()
		{
		}


		public function getUnitCollisionForce( gameLogics:GameLogics, unit:Unit ):Force
		{
			//TODO: This should use QuadTree instead
			var unitManager:UnitManager = gameLogics.getUnitManager();
			var units:Vector.<Unit> = unitManager.getUnitsIntersectingCircle( unit.getX(), unit.getY(), unit.getRadius() );

			return calculateForce( unit, units );
		}


		private function calculateForce( unit:Unit, units:Vector.<Unit> ):Force
		{

			//TODO: Units should be stored in a QuadTree (com.potmo.util.containers.quadtree.QuadTree) for faster access and calculation

			var dx:Number;
			var dy:Number;
			var combinedRadius:Number;

			var count:int = units.length;

			// start with no force to apply
			var output:Force = new Force( 0, 0 );

			// if there are only one or less unit withing the range
			// then its the unit itself and no force should be applied
			if ( count <= 1 )
			{
				return output;
			}

			// loop all other units and add their force to the mix
			var length:int = units.length;

			for ( var i:int = 0; i < length; i++ )
			{
				var otherUnit:Unit = units[ i ]

				// do not check against myself
				if ( unit == otherUnit )
				{
					continue;
				}

				// do not check agains dead units
				if ( otherUnit.isDead() )
				{
					continue;
				}

				dx = unit.getX() - otherUnit.getX();
				dy = unit.getY() - otherUnit.getY();

				// if they are standing right on top of eachother then continue to the next
				if ( dx == 0 && dy == 0 )
				{
					continue;
				}

				combinedRadius = unit.getRadius() + otherUnit.getRadius();

				// get length
				var dist:Number = StrictMath.get2DLength( dx, dy );

				// normalize
				dx /= dist;
				dy /= dist;

				var magnitude:Number = ( 1.0 - dist / combinedRadius );
				output.addComponents( dx * magnitude, dy * magnitude );
			}

			/*output.x = -output.x;
			   output.y = -output.y;*/

			return output;
		}
	}
}
