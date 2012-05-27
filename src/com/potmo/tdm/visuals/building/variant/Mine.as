package com.potmo.tdm.visuals.building.variant
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.Building;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.building.BuildingFactory;
	import com.potmo.tdm.visuals.building.BuildingType;
	import com.potmo.util.math.StrictMath;

	import flash.geom.Point;

	public class Mine extends BuildingBase implements Building
	{

		private static const SEQUENCE_NAME:String = "mine";
		private var _resources:int;


		public function Mine( spriteAtlas:SpriteAtlas )
		{
			super( BuildingType.MINE, spriteAtlas.getSequenceByName( SEQUENCE_NAME ) );
		}


		public function getUpgrade( buildingFactory:BuildingFactory ):Building
		{
			return null;
		}


		public function update( gameLogics:GameLogics ):void
		{
			// we don't have to do anything while there are no miners inside
		}


		public function init( gameLogics:GameLogics ):void
		{
			_resources = 5000;
		}


		public function reset( gameLogics:GameLogics ):void
		{
			_resources = 0;
		}


		public function handleClick( x:int, y:int, gameLogics:GameLogics ):void
		{
		}


		public function handleClickOutside( x:int, y:int, gameLogics:GameLogics ):void
		{
		}


		public function extract( amount:int, gameLogics:GameLogics ):int
		{
			var pickedUp:int = StrictMath.min( amount, _resources );
			_resources -= pickedUp;

			//TODO: Call building manager when mine is exhausted

			if ( _resources <= 0 )
			{
				gameLogics.getBuildingManager().handleMinesResourcesExhausted( this );
			}

			return pickedUp;
		}


		public function getResoucesLeft():int
		{
			return _resources;
		}

	}
}
