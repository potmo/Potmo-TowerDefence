package com.potmo.tdm.visuals.map.force
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.unit.IUnit;
	import com.potmo.tdm.visuals.unit.UnitManager;
	import com.potmo.util.math.StrictMath;

	public class UnitCollisionForceCalculator
	{
		private static const FORCE_SCALAR:Number = 5.0;


		public function UnitCollisionForceCalculator()
		{
		}


		public function getUnitCollisionForce( gameLogics:GameLogics, unit:IUnit ):Force
		{
			var unitManager:UnitManager = gameLogics.getUnitManager();
			var units:Vector.<IUnit> = unitManager.getUnitsIntersectingCircle( unit.getX(), unit.getY(), unit.getRadius() );

			return calculateForce( unit, units );
		}


		private function calculateForce( unit:IUnit, units:Vector.<IUnit> ):Force
		{
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
			for each ( var otherUnit:IUnit in units )
			{
				// do not check against myself
				if ( unit == otherUnit )
				{
					continue;
				}

				dx = unit.getX() - otherUnit.getX();
				dy = unit.getY() - otherUnit.getY();

				if ( dx == 0 && dy == 0 )
				{
					return new Force( 0, 0 );
				}

				combinedRadius = unit.getRadius() + otherUnit.getRadius();

				// get length
				var dist:Number = StrictMath.get2DLength( dx, dy );

				// normalize
				dx /= dist;
				dy /= dist;

				var magnitude:Number = -( 1.0 - dist / combinedRadius );
				magnitude *= FORCE_SCALAR;
				output.addComponents( dx * magnitude, dy * magnitude );
			}

			output.x = -output.x;
			output.y = -output.y;

			return output;
		}
	}
}
