package com.potmo.tdm.visuals.hud.variant
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.display.BasicRenderItem;
	import com.potmo.tdm.player.OrderManager;
	import com.potmo.tdm.visuals.building.BuildingType;
	import com.potmo.tdm.visuals.building.variant.ConstructionSite;
	import com.potmo.tdm.visuals.hud.HudBase;

	public class ConstructionSiteHud extends HudBase
	{

		private var _constructionSite:ConstructionSite;

		private var _campButton:BasicRenderItem;
		private var _archeryButton:BasicRenderItem;

		private static const CAMP_BUTTON_SEQUENCE:String = "campbutton";
		private static const ARCHERY_BUTTON_SEQUENCE:String = "archerybutton";


		public function ConstructionSiteHud( spriteAtlas:SpriteAtlas )
		{
			super( spriteAtlas );

			this._constructionSite = _constructionSite;
			this.setupGui( spriteAtlas );
		}


		private function setupGui( spriteAtlas:SpriteAtlas ):void
		{
			_campButton = new BasicRenderItem( spriteAtlas.getSequenceByName( CAMP_BUTTON_SEQUENCE ) );
			_archeryButton = new BasicRenderItem( spriteAtlas.getSequenceByName( ARCHERY_BUTTON_SEQUENCE ) );

			addButtonLast( _campButton );
			addButtonLast( _archeryButton );
		}


		public override function handleClick( x:int, y:int, orderManager:OrderManager, gameLogics:GameLogics ):Boolean
		{
			// check if it was a click on the castle button
			if ( _campButton.containsPoint( x, y ) )
			{
				orderManager.requestConstructBuilding( _constructionSite, BuildingType.CAMP );
				gameLogics.getHudManager().hideHud();
				return true;
			}

			if ( _archeryButton.containsPoint( x, y ) )
			{
				orderManager.requestConstructBuilding( _constructionSite, BuildingType.ARCHERY );
				gameLogics.getHudManager().hideHud();
				return true;
			}

			gameLogics.getHudManager().hideHud();

			return false;
		}


		public function setup( constructionSite:ConstructionSite ):void
		{
			_constructionSite = constructionSite;

		}


		override public function clear():void
		{
			_constructionSite = null;
		}
	}
}
