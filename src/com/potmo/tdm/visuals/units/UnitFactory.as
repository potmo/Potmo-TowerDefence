package com.potmo.tdm.visuals.units
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.player.Player;

	public final class UnitFactory
	{
		private var knightPool:Vector.<UnitBase> = new Vector.<UnitBase>();
		private var archerPool:Vector.<UnitBase> = new Vector.<UnitBase>();


		public function UnitFactory()
		{
			populatePool( knightPool, UnitType.KNIGHT, 10 );
			populatePool( archerPool, UnitType.ARCHER, 10 );
		}


		public function getUnit( type:UnitType, player:Player ):UnitBase
		{
			var unit:UnitBase;
			var pool:Vector.<UnitBase> = getPool( type );

			unit = getUnitFromPool( pool, type );
			unit.setOwningPlayer( player );
			return unit;
		}


		public function returnUnit( unit:UnitBase, gameLogics:GameLogics ):void
		{
			unit.reset( gameLogics );
			getPool( unit.getType() ).push( unit );
		}


		private function getPool( type:UnitType ):Vector.<UnitBase>
		{
			switch ( type )
			{
				case UnitType.KNIGHT:
					return knightPool;
				case UnitType.ARCHER:
					return archerPool;
				default:
					throw new Error( "Not possible to find pool of type: " + type );
			}
		}


		private function getUnitFromPool( pool:Vector.<UnitBase>, type:UnitType ):UnitBase
		{
			if ( pool.length == 0 )
			{
				populatePool( pool, type, 5 );
			}
			return pool.pop();
		}


		private function populatePool( pool:Vector.<UnitBase>, type:UnitType, units:uint ):void
		{
			var unit:UnitBase;
			var clazz:Class = type.getClass();

			while ( units > 0 )
			{
				unit = new clazz();
				pool.push( unit );
				units--;
			}
		}

	}
}
