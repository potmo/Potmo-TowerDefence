package com.potmo.tdm.visuals.map.forcemap
{

	public interface IMapTile
	{
		function get x():int;
		function get y():int;
		function getType():MapTileType;
		function setType( type:MapTileType ):void;
		/**
		 * A unique hashnumber representing the x and y coordinates
		 */
		function getHash():uint;
	}
}
