package com.potmo.tdm.visuals.map.tilemap.forcefieldmap.composer
{
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.pathfinding.PathfinderForceFieldMap;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.unit.UnitForceFieldMap;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.wall.WallForceFieldMap;

	public class TotalForceFieldComposer implements IForceComposer
	{
		private var aStarField:PathfinderForceFieldMap;
		private var wallField:WallForceFieldMap;
		private var unitField:UnitForceFieldMap;


		public function TotalForceFieldComposer( aStarField:PathfinderForceFieldMap, wallField:WallForceFieldMap, unitField:UnitForceFieldMap )
		{
			this.aStarField = aStarField;
			this.wallField = wallField;
			this.unitField = unitField;
		}


		public function getFlowForce( x:Number, y:Number ):Force
		{

			var wallForce:Force = wallField.getPathForce( x, y );

			var aStarForce:Force = aStarField.getForce( x, y );
			var unitForce:Force = unitField.getPathForce( x, y );

			/*if ( wallForce.length >= 1 )
			   {
			   unitForce.scaleBy( 0.1 );
			   aStarForce.scaleBy( 0.2 )
			   }*/

			/*if ( unitForce.length >= 3 )
			   {
			   aStarForce.scaleBy( 0.1 );
			   unitForce.scaleBy( 0.1 );
			   }*/

			/*if ( StrictMath.isCloseEnough( x, y, aStarField.getTargetX(), aStarField.getTargetY(), 4 ) )
			   {
			   aStarForce.scaleBy( 0 );
			   }*/

			wallForce.add( aStarForce );
			wallForce.add( unitForce );
			return wallForce; // all forces
		}
	}
}
