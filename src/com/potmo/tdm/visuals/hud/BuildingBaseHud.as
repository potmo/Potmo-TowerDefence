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
		private var _demolishButton:BasicRenderItem;
		private var _deployFlagButton:BasicRenderItem;
		private var _attackButton:BasicRenderItem;

		private static const DEMOLISH_BUTTON_SEQUENCE:String = "demolishbutton";
		private static const DEPLOY_FLAG_BUTTON_SEQUENCE:String = "deployareabutton";
		private static const ATTACK_BUTTON_SEQUENCE:String = "attackbutton";


		public function BuildingBaseHud( spriteAtlas:SpriteAtlas )
		{
			super( spriteAtlas );

		}


		public function setBuilding( building:BuildingBase ):void
		{
			this._building = building;
		}


		protected function setupGui( spriteAtlas:SpriteAtlas ):void
		{
			_demolishButton = new BasicRenderItem( spriteAtlas.getSequenceByName( DEMOLISH_BUTTON_SEQUENCE ) );

			addButtonLast( _demolishButton, false );

			_deployFlagButton = new BasicRenderItem( spriteAtlas.getSequenceByName( DEPLOY_FLAG_BUTTON_SEQUENCE ) );

			addButtonFirst( _deployFlagButton, true );

			_attackButton = new BasicRenderItem( spriteAtlas.getSequenceByName( ATTACK_BUTTON_SEQUENCE ) );

			addButtonFirst( _attackButton, true );

		}


		public override function handleClick( x:int, y:int, orderManager:OrderManager, gameLogics:GameLogics ):Boolean
		{
			if ( _demolishButton.containsPoint( x, y ) )
			{
				orderManager.requestDemolishHouse( _building );
				gameLogics.getHudManager().hideHud();
				return true;
			}

			if ( _attackButton.containsPoint( x, y ) )
			{
				orderManager.requestAttack( _building );
				gameLogics.getHudManager().hideHud();
				return true;
			}

			if ( _deployFlagButton.containsPoint( x, y ) )
			{
				gameLogics.getHudManager().showConstructionDeployFlagHud( _building );
				gameLogics.getHudManager().hideHud();
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
