package com.potmo.tdm.visuals.unit
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.player.Player;

	public final class UnitFactory
	{

		private var knightPool:Vector.<Unit> = new Vector.<Unit>();

		//private var archerPool:Vector.<UnitBase> = new Vector.<UnitBase>();
		private var _spriteAtlas:SpriteAtlas;


		public function UnitFactory( spriteAtlas:SpriteAtlas )
		{
			this._spriteAtlas = spriteAtlas;
			populatePool( knightPool, UnitType.KNIGHT, 10 );
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

			while ( units > 0 )
			{
				unit = new clazz( _spriteAtlas );
				pool.push( unit );
				units--;
			}
		}

	}
}
