package com.potmo.tdm.visuals.map.forcemap.forcefieldmap.composer
{
	import com.potmo.tdm.visuals.map.forcemap.forcefieldmap.Force;

	/**
	 * Composes many force sources into one source
	 */
	public interface IForceComposer
	{
		/**
		 * Get the forces acting upon position x,y
		 */
		function getFlowForce( x:Number, y:Number ):Force;
	}
}
