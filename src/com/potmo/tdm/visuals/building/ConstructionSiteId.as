package com.potmo.tdm.visuals.building
{

	public class ConstructionSiteId
	{
		private var _id:uint;


		public function ConstructionSiteId( id:uint )
		{
			_id = id;
		}


		public function getId():uint
		{
			return _id;
		}


		public function getNext():ConstructionSiteId
		{
			return new ConstructionSiteId( _id + 1 );
		}
	}
}
