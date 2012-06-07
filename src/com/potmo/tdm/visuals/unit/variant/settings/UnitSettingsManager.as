package com.potmo.tdm.visuals.unit.variant.settings
{
	import com.potmo.tdm.visuals.unit.UnitType;

	public class UnitSettingsManager
	{

		private var _numSettings:int;
		private var _settings:Vector.<UnitSettings>;


		public function UnitSettingsManager()
		{

			var knight:KnightSettings = new KnightSettings();
			var miner:MinerSettings = new MinerSettings();

			_settings = new <UnitSettings>[ knight, miner ];
			_numSettings = _settings.length;
		}


		public function getSettingsForType( type:UnitType ):UnitSettings
		{
			for ( var i:int = 0; i < _numSettings; i++ )
			{
				var setting:UnitSettings = _settings[ i ];

				if ( setting.getUnitType() == type )
				{
					return setting;
				}
			}

			throw new Error( "No unit settings found for type: " + type );
		}
	}
}
