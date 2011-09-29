package com.potmo.tdm.visuals.hud
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.OrderManager;
	import com.potmo.tdm.asset.button.AttackButton_Asset;
	import com.potmo.tdm.asset.button.DemolishButton_Asset;
	import com.potmo.tdm.asset.button.DeployFlag_Button;
	import com.potmo.tdm.visuals.buildings.BuildingBase;
	import com.potmo.tdm.visuals.starling.TextureAnimation;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;

	public class BuildingBaseHud extends HudBase
	{

		private static const demolishButtonGraphics:TextureAnimationCacheObject = new TextureAnimationCacheObject( new DemolishButton_Asset() );
		private static const attackButtonGraphics:TextureAnimationCacheObject = new TextureAnimationCacheObject( new AttackButton_Asset() );
		private static const deployFlagButtonGraphics:TextureAnimationCacheObject = new TextureAnimationCacheObject( new DeployFlag_Button() );
		protected var demolishButton:TextureAnimation;
		protected var attackButton:TextureAnimation;
		protected var deployFlagButton:TextureAnimation;
		private var building:BuildingBase;


		public function BuildingBaseHud( building:BuildingBase )
		{
			super();
			this.building = building;

		}


		protected function setupGui():void
		{
			demolishButton = new TextureAnimation( demolishButtonGraphics );

			addButtonLast( demolishButton, false );

			deployFlagButton = new TextureAnimation( deployFlagButtonGraphics );

			addButtonFirst( deployFlagButton, true );

			attackButton = new TextureAnimation( attackButtonGraphics );

			addButtonFirst( attackButton, true );

		}


		public override function handleClick( x:int, y:int, orderManager:OrderManager, gameLogics:GameLogics ):Boolean
		{
			if ( demolishButton.getBounds( this ).contains( x, y ) )
			{
				orderManager.requestDemolishHouse( building );
				return true;
			}

			if ( attackButton.getBounds( this ).contains( x, y ) )
			{
				orderManager.requestAttack( building );
				return true;
			}

			if ( deployFlagButton.getBounds( this ).contains( x, y ) )
			{
				orderManager.requestShowDeployFlag( building );
				return true;
			}

			return false;
		}

	}
}
