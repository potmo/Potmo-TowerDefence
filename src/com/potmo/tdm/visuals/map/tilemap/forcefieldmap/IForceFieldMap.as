package com.potmo.tdm.visuals.map.tilemap.forcefieldmap
{

	public interface IForceFieldMap
	{
		function getPathForce( x:Number, y:Number ):Force;

		function getUnwalkableAreaForce( x:Number, y:Number ):Force;

	}
}
