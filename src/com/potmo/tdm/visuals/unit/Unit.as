package com.potmo.tdm.visuals.unit
{
	import com.potmo.p2d.renderer.Renderable;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.display.ZSortableRenderable;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.building.Building;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.unit.settings.UnitSetting;
	import com.potmo.tdm.visuals.unit.state.UnitState;

	public interface Unit extends ZSortableRenderable
	{
		function init( gameLogics:GameLogics ):void;
		function reset( gameLogics:GameLogics ):void;
		function spawn( gameLogics:GameLogics ):void;
		function update( gameLogics:GameLogics ):void;
		function damage( amount:int, gameLogics:GameLogics ):void;
		function kill( gameLogics:GameLogics ):void;
		function heal( amount:int, gameLogics:GameLogics ):void;
		function charge( gameLogics:GameLogics ):void;
		function deploy( x:int, y:int, gameLogics:GameLogics ):void;
		function moveToFlag( gameLogics:GameLogics ):void;

		function getHomeBuilding():Building;
		function setHomeBuilding( building:Building ):void;
		function getOwningPlayer():Player;
		function setOwningPlayer( player:Player ):void;
		function getType():UnitType;

		function isDead():Boolean;

		function getX():Number;
		function getY():Number;
		function getRadius():Number;

		/*function getNumberOfTargetingUnits():int;
		   function startBeingTargetedByUnit( other:IUnit ):void;
		   function stopBeingTargetedByUnit( other:IUnit ):void;*/

		function targetedByEnemy():void;
		function untargetedByEnemy():void;
		function getNumberOfTargetingEnemies():int;

		function getSettings():UnitSetting;

		function getOldX():Number;
		function getOldY():Number;
		function isPositionDirty():Boolean;
		function setPositionAsClean():void;

		function getState():UnitState;

	}
}
