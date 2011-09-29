package com.potmo.tdm
{
	import com.potmo.tdm.visuals.buildings.BuildingType;

	public class Prices
	{

		public function Prices()
		{

		}


		public static function getPriceForBuilding( type:BuildingType ):int
		{
			switch ( type )
			{
				case ( BuildingType.CAMP ):
				{
					return 100;
				}
				case ( BuildingType.KEEP ):
				{
					return 150;
				}
				case ( BuildingType.FORTRESS ):
				{
					return 200;
				}
				case ( BuildingType.CASTLE ):
				{
					return 240;
				}
				case ( BuildingType.CITADELL ):
				{
					return 320;
				}

				case ( BuildingType.ARCHERY ):
				{
					return 100;
				}

				default:
				{
					throw new Error( "It is not possible to get price for building of type: " + type );
				}
			}
		}
	}
}