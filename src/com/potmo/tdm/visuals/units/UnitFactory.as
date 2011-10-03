package com.potmo.tdm.visuals.units
{
	import com.potmo.tdm.player.Player;

	public final class UnitFactory
	{
		private var knightPool:Vector.<UnitBase> = new Vector.<UnitBase>();
		private var archerPool:Vector.<UnitBase> = new Vector.<UnitBase>();


		public function UnitFactory()
		{
			populatePool( knightPool, Knight, UnitType.KNIGHT, 10 );
			populatePool( archerPool, Archer, UnitType.ARCHER, 10 );
		}


		public function getUnit( type:UnitType, player:Player ):UnitBase
		{
			var unit:UnitBase;
			var clazz:Class;
			var pool:Vector.<UnitBase> = getPool( type );

			switch ( type )
			{
				case UnitType.KNIGHT:
					clazz = Knight;
					break;
				case UnitType.ARCHER:
					clazz = Archer;
					break;
				default:
					throw new Error( "Not possible to create unit of type: " + type );
			}

			unit = getUnitFromPool( pool, clazz, type );
			unit.setOwningPlayer( player );
			return unit;
		}


		public function returnUnit( unit:UnitBase ):void
		{
			unit.reset();
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


		private function getUnitFromPool( pool:Vector.<UnitBase>, clazz:Class, type:UnitType ):UnitBase
		{
			if ( pool.length == 0 )
			{
				populatePool( pool, clazz, type, 5 );
			}
			return pool.pop();
		}


		private function populatePool( pool:Vector.<UnitBase>, clazz:Class, type:UnitType, units:uint ):void
		{
			var unit:UnitBase;

			while ( units > 0 )
			{
				unit = new clazz();
				unit.setType( type );
				pool.push( unit );
				units--;
			}
		}

	}
}
