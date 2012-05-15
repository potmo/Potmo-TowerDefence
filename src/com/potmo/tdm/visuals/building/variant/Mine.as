package com.potmo.tdm.visuals.building.variant
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.Building;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.building.BuildingFactory;
	import com.potmo.tdm.visuals.building.BuildingType;

	public class Mine extends BuildingBase implements Building
	{

		private static const SEQUENCE_NAME:String = "mine";


		public function Mine( spriteAtlas:SpriteAtlas )
		{
			super( BuildingType.MINE, spriteAtlas.getSequenceByName( SEQUENCE_NAME ) );
		}


		public function getUpgrade( buildingFactory:BuildingFactory ):Building
		{
			return null;
		}


		public function getRadius():Number
		{
			return 40;
		}


		public function update( gameLogics:GameLogics ):void
		{
			// we don't have to do anything while there are no miners inside
		}


		public function init( gameLogics:GameLogics ):void
		{
		}


		public function reset( gameLogics:GameLogics ):void
		{
		}


		public function handleClick( x:int, y:int, gameLogics:GameLogics ):void
		{
		}


		public function handleClickOutside( x:int, y:int, gameLogics:GameLogics ):void
		{
		}
	}
}
