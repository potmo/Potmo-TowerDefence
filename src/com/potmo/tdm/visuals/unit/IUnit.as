package com.potmo.tdm.visuals.unit
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.unit.settings.IUnitSetting;

	import starling.display.DisplayObject;

	public interface IUnit
	{
		function init( gameLogics:GameLogics ):void;
		function reset( gameLogics:GameLogics ):void;
		function update( gameLogics:GameLogics ):void;
		function damage( amount:int, gameLogics:GameLogics ):void;
		function kill( gameLogics:GameLogics ):void;
		function heal( amount:int, gameLogics:GameLogics ):void;
		function charge( gameLogics:GameLogics ):void;
		function deploy( x:int, y:int, gameLogics:GameLogics ):void;
		function getHomeBuilding():BuildingBase;
		function setHomeBuilding( building:BuildingBase ):void;
		function getOwningPlayer():Player;
		function setOwningPlayer( player:Player ):void;
		function getType():UnitType;
		function getAsDisplayObject():DisplayObject;

		function getX():Number;
		function getY():Number;
		function getRadius():Number;

		function isTargetedByAnyUnit():Boolean;
		function startBeingTargetedByUnit( other:IUnit ):void;
		function stopBeingTargetedByUnit( other:IUnit ):void;
		function getSettings():IUnitSetting;

		function getOldX():Number;
		function getOldY():Number;
		function isPositionDirty():Boolean;
		function setPositionAsClean():void;

	}
}
