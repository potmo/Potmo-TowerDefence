package com.potmo.tdm.visuals.building
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.display.ZSortableRenderable;
	import com.potmo.tdm.player.Player;

	public interface Building extends ZSortableRenderable
	{
		function init( gameLogics:GameLogics ):void;
		function reset( gameLogics:GameLogics ):void;
		function update( gameLogics:GameLogics ):void;

		function getType():BuildingType;

		function setConstructionSiteId( positionId:ConstructionSiteId ):void;
		function getConstructionSiteId():ConstructionSiteId;

		function setOwningPlayer( player:Player ):void;
		function getOwningPlayer():Player;

		//TODO: Theese function should be moved to ClickableBuilding
		function handleClick( x:int, y:int, gameLogics:GameLogics ):void
		function handleClickOutside( x:int, y:int, gameLogics:GameLogics ):void

		function getX():Number;
		function getY():Number;

		function setX( x:Number ):void;
		function setY( y:Number ):void;

		function isUnderPosition( x:Number, y:Number ):Boolean;

		//TODO: Theese should be moved to a UnitHoldingBuilding
		function chargeWithAllUnits( gameLogics:GameLogics ):void;
		function killAllUnits( gameLogics:GameLogics ):void;
		function setDeployFlag( x:Number, y:Number, gameLogics:GameLogics ):void;
		function getDeployFlagMaxDistanceFromBuilding():Number;
		function getDeployFlagX():Number;
		function getDeployFlagY():Number;

		function getUpgrade( buildingFactory:BuildingFactory ):Building;
	}
}
