package com.potmo.tdm.visuals.hud
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.OrderManager;
	import com.potmo.tdm.asset.button.AttackButton_Asset;
	import com.potmo.tdm.asset.button.DemolishButton_Asset;
	import com.potmo.tdm.asset.button.DeployFlag_Button;
	import com.potmo.tdm.visuals.buildings.BuildingBase;
	import com.potmo.util.image.BitmapAnimation;
	import com.potmo.util.image.BitmapAnimationCacheObject;

	public class BuildingBaseHud extends HudBase
	{

		private static const demolishButtonGraphics:BitmapAnimationCacheObject = new BitmapAnimationCacheObject( new DemolishButton_Asset() );
		private static const attackButtonGraphics:BitmapAnimationCacheObject = new BitmapAnimationCacheObject( new AttackButton_Asset() );
		private static const deployFlagButtonGraphics:BitmapAnimationCacheObject = new BitmapAnimationCacheObject( new DeployFlag_Button() );
		protected var demolishButton:BitmapAnimation;
		protected var attackButton:BitmapAnimation;
		protected var deployFlagButton:BitmapAnimation;
		private var building:BuildingBase;


		public function BuildingBaseHud( building:BuildingBase )
		{
			super();
			this.building = building;

		}


		protected function setupGui():void
		{
			demolishButton = new BitmapAnimation( demolishButtonGraphics );

			addButtonLast( demolishButton, false );

			deployFlagButton = new BitmapAnimation( deployFlagButtonGraphics );

			addButtonFirst( deployFlagButton, true );

			attackButton = new BitmapAnimation( attackButtonGraphics );

			addButtonFirst( attackButton, true );

		}


		public override function handleClick( x:int, y:int, orderManager:OrderManager, gameLogics:GameLogics ):Boolean
		{
			if ( demolishButton.getRect( this ).contains( x, y ) )
			{
				orderManager.requestDemolishHouse( building );
				return true;
			}

			if ( attackButton.getRect( this ).contains( x, y ) )
			{
				orderManager.requestAttack( building );
				return true;
			}

			if ( deployFlagButton.getRect( this ).contains( x, y ) )
			{
				orderManager.requestShowDeployFlag( building );
				return true;
			}

			return false;
		}

	}
}