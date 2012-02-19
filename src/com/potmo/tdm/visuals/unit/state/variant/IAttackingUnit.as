package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.unit.IUnit;

	public interface IAttackingUnit extends IUnit
	{
		function handleAttackStateFinished( state:AttackState, gameLogics:GameLogics ):void;
	}
}
