package com.potmo.tdm.visuals.hud
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.display.BasicRenderItem;
	import com.potmo.tdm.player.OrderManager;
	import com.potmo.tdm.visuals.building.BuildingBase;

	public class BuildingBaseHud extends HudBase
	{

		private var _building:BuildingBase;
		private var demolishButton:BasicRenderItem;
		private var deployFlagButton:BasicRenderItem;
		private var attackButton:BasicRenderItem;

		private static const DEMOLISH_BUTTON_SEQUENCE:String = "demoloshbutton";
		private static const DEPLOY_FLAG_BUTTON_SEQUENCE:String = "deployflagbutton";
		private static const ATTACK_BUTTON_SEQUENCE:String = "attackbutton";


		public function BuildingBaseHud( spriteAtlas:SpriteAtlas )
		{
			super( spriteAtlas );

			setupGui( spriteAtlas );

		}


		public function setBuilding( building:BuildingBase ):void
		{
			this._building = building;
		}


		protected function setupGui( spriteAtlas:SpriteAtlas ):void
		{
			demolishButton = BasicRenderItem( spriteAtlas.getSequenceByName( DEMOLISH_BUTTON_SEQUENCE ) );

			addButtonLast( demolishButton, false );

			deployFlagButton = new BasicRenderItem( spriteAtlas.getSequenceByName( DEPLOY_FLAG_BUTTON_SEQUENCE ) );

			addButtonFirst( deployFlagButton, true );

			attackButton = new BasicRenderItem( spriteAtlas.getSequenceByName( ATTACK_BUTTON_SEQUENCE ) );

			addButtonFirst( attackButton, true );

		}


		public override function handleClick( x:int, y:int, orderManager:OrderManager, gameLogics:GameLogics ):Boolean
		{
			if ( demolishButton.containsPoint( x, y ) )
			{
				orderManager.requestDemolishHouse( _building );
				return true;
			}

			if ( attackButton.containsPoint( x, y ) )
			{
				orderManager.requestAttack( _building );
				return true;
			}

			if ( deployFlagButton.containsPoint( x, y ) )
			{
				gameLogics.getHudManager().showConstructionDeployFlagHud( _building );
				return true;
			}

			return false;
		}


		override public function clear():void
		{
			super.clear();
			_building = null;
		}

	}
}
