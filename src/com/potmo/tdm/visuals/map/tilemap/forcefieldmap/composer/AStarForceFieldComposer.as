package com.potmo.tdm.visuals.map.tilemap.forcefieldmap.composer
{
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.ForceFieldMap;

	import flash.geom.Vector3D;

	public class AStarForceFieldComposer implements IForceComposer
	{
		private var map:ForceFieldMap;


		public function AStarForceFieldComposer( aStarMap:ForceFieldMap )
		{
			map = aStarMap;
		}


		public function getFlowForce( x:Number, y:Number ):Vector3D
		{
			return map.getForce( x, y );
		}
	}
}
