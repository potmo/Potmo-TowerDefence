package com.potmo.tdm.visuals.building.variant.settings
{
	import com.potmo.tdm.visuals.building.BuildingType;

	public class BuildingSettingsManager
	{

		private var _numSettings:int;
		private var _settings:Vector.<BuildingSettings>;


		public function BuildingSettingsManager()
		{

			var archerySettings:ArcherySettings = new ArcherySettings();
			var campSettings:CampSettings = new CampSettings();
			var minersHutSettings:MinersHutSettings = new MinersHutSettings();

			_settings = new <BuildingSettings>[ archerySettings, campSettings, minersHutSettings ];
			_numSettings = _settings.length;

		}


		public function getSettingsForType( type:BuildingType ):BuildingSettings
		{
			for ( var i:int = 0; i < _numSettings; i++ )
			{
				var setting:BuildingSettings = _settings[ i ];

				if ( setting.getBuildingType() == type )
				{
					return setting;
				}
			}

			throw new Error( "No building settings found for type: " + type );
		}
	}
}
