package com.potmo.tdm.visuals.unit.state
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.unit.UnitBase;

	public class UnitStateBase
	{
		private var _type:UnitStateEnum;


		public final function UnitStateBase( type:UnitStateEnum )
		{
			this._type = type;
		}


		public function getType():UnitStateEnum
		{
			return _type;
		}

	}
}
