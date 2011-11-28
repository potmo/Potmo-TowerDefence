package com.potmo.tdm.visuals.units.controller
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.units.UnitBase;

	public interface IUnitComponent
	{
		function update( unit:UnitBase, gameLogics:GameLogics ):void;
	}
}
