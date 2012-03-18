package com.potmo.tdm.visuals.hud.variant
{
	import com.potmo.tdm.visuals.building.variant.Camp;
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.display.BasicRenderItem;
	import com.potmo.tdm.player.OrderManager;
	import com.potmo.tdm.visuals.building.variant.Camp;
	import com.potmo.tdm.visuals.hud.BuildingBaseHud;

	public class CampHud extends BuildingBaseHud
	{

		private static const KEEP_BUTTON_SEQUENCE:String = "keepbutton";

		private var _keepButton:BasicRenderItem;
		private var _camp:Camp;


		public function CampHud( spriteAtlas:SpriteAtlas )
		{
			super( spriteAtlas );
			setupGui( spriteAtlas );
		}


		override protected function setupGui( spriteAtlas:SpriteAtlas ):void
		{
			super.setupGui( spriteAtlas );
			_keepButton = new BasicRenderItem( spriteAtlas.getSequenceByName( KEEP_BUTTON_SEQUENCE ) );
			addButtonLast( _keepButton );
		}


		public override function handleClick( x:int, y:int, orderManager:OrderManager, gameLogics:GameLogics ):Boolean
		{

			if ( _keepButton.containsPoint( x, y ) )
			{
				orderManager.requestUpgradeBuilding( _camp );
				return true;
			}
			return super.handleClick( x, y, orderManager, gameLogics );
		}


		public function setCamp( camp:Camp ):void
		{
			this._camp = camp;
		}


		override public function clear():void
		{
			super.clear();
			_camp = null;

		}
	}
}
