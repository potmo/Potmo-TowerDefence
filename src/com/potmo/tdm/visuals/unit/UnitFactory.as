package com.potmo.tdm.visuals.unit
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.unit.variant.settings.UnitSettingsManager;
	import com.potmo.tdm.visuals.unit.variant.settings.UnitSettings;

	public final class UnitFactory
	{

		private var knightPool:Vector.<Unit> = new Vector.<Unit>();
		private var minerPool:Vector.<Unit> = new Vector.<Unit>();

		//private var archerPool:Vector.<UnitBase> = new Vector.<UnitBase>();
		private var _spriteAtlas:SpriteAtlas;
		private var _settingsManager:UnitSettingsManager;


		public function UnitFactory( spriteAtlas:SpriteAtlas, settingsManager:UnitSettingsManager )
		{
			this._spriteAtlas = spriteAtlas;
			this._settingsManager = settingsManager;

			populatePool( knightPool, UnitType.KNIGHT, 10 );
			populatePool( minerPool, UnitType.MINER, 10 );
			//populatePool( archerPool, UnitType.ARCHER, 10 );
		}


		public function getUnit( type:UnitType, player:Player, gameLogics:GameLogics ):Unit
		{
			var unit:Unit;
			var pool:Vector.<Unit> = getPool( type );

			unit = getUnitFromPool( pool, type );
			unit.setOwningPlayer( player );
			unit.init( gameLogics );
			unit.spawn( gameLogics );
			return unit;
		}


		public function returnUnit( unit:Unit, gameLogics:GameLogics ):void
		{
			unit.reset( gameLogics );
			getPool( unit.getType() ).push( unit );
		}


		private function getPool( type:UnitType ):Vector.<Unit>
		{
			switch ( type )
			{
				case UnitType.KNIGHT:
					return knightPool;
				//case UnitType.ARCHER:
				//	return archerPool;
				case UnitType.MINER:
					return minerPool;
				default:
					throw new Error( "Not possible to find pool of type: " + type );
			}
		}


		private function getUnitFromPool( pool:Vector.<Unit>, type:UnitType ):Unit
		{
			if ( pool.length == 0 )
			{
				populatePool( pool, type, 5 );
			}
			return pool.pop();
		}


		private function populatePool( pool:Vector.<Unit>, type:UnitType, units:uint ):void
		{
			var unit:Unit;
			var clazz:Class = type.getClass();
			var settings:UnitSettings = _settingsManager.getSettingsForType( type );

			while ( units > 0 )
			{
				unit = new clazz( _spriteAtlas, settings );
				pool.push( unit );
				units--;
			}
		}

	}
}
