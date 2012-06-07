package com.potmo.tdm.visuals.hud.variant
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.display.BasicRenderItem;
	import com.potmo.tdm.player.OrderManager;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.building.BuildingType;
	import com.potmo.tdm.visuals.building.variant.ConstructionSite;
	import com.potmo.tdm.visuals.building.variant.settings.BuildingSettings;
	import com.potmo.tdm.visuals.building.variant.settings.BuildingSettingsManager;
	import com.potmo.tdm.visuals.hud.HudBase;
	import com.potmo.tdm.visuals.hud.HudButton;

	public class ConstructionSiteHud extends HudBase
	{

		private var _constructionSite:ConstructionSite;

		private var _campButton:HudButton;
		private var _archeryButton:HudButton;
		private var _minersHutButton:HudButton;

		private static const CAMP_BUTTON_SEQUENCE:String = "campbutton";
		private static const ARCHERY_BUTTON_SEQUENCE:String = "archerybutton";
		private static const MINERSHUT_BUTTON_SEQUENCE:String = "minershutbutton"; // TODO: Use miners hut hud button instead of archery


		public function ConstructionSiteHud( spriteAtlas:SpriteAtlas )
		{
			super( spriteAtlas );

			this._constructionSite = _constructionSite;
			this.setupGui( spriteAtlas );
		}


		private function setupGui( spriteAtlas:SpriteAtlas ):void
		{
			_campButton = new HudButton( spriteAtlas.getSequenceByName( CAMP_BUTTON_SEQUENCE ) );
			_archeryButton = new HudButton( spriteAtlas.getSequenceByName( ARCHERY_BUTTON_SEQUENCE ) );
			_minersHutButton = new HudButton( spriteAtlas.getSequenceByName( MINERSHUT_BUTTON_SEQUENCE ) );

			addButtonLast( _campButton );
			addButtonLast( _archeryButton );
			addButtonLast( _minersHutButton );
		}


		public override function handleClick( x:int, y:int, orderManager:OrderManager, gameLogics:GameLogics ):Boolean
		{
			// check if it was a click on the castle button
			if ( _campButton.containsPoint( x, y ) && _campButton.isEnabled() )
			{
				orderManager.requestConstructBuilding( _constructionSite, BuildingType.CAMP );
				gameLogics.getHudManager().hideHud();
				return true;
			}

			if ( _archeryButton.containsPoint( x, y ) && _archeryButton.isEnabled() )
			{
				orderManager.requestConstructBuilding( _constructionSite, BuildingType.ARCHERY );
				gameLogics.getHudManager().hideHud();
				return true;
			}

			if ( _minersHutButton.containsPoint( x, y ) && _minersHutButton.isEnabled() )
			{
				orderManager.requestConstructBuilding( _constructionSite, BuildingType.MINERS_HUT );
				gameLogics.getHudManager().hideHud();
				return true;
			}

			gameLogics.getHudManager().hideHud();

			return false;
		}


		override public function update( gameLogics:GameLogics ):void
		{
			var settings:BuildingSettingsManager = gameLogics.getBuildingManager().getBuildingSettingsManager();
			var player:Player = _constructionSite.getOwningPlayer();
			var affords:Boolean;
			var setting:BuildingSettings;

			setting = settings.getSettingsForType( BuildingType.MINERS_HUT );
			affords = player.canAffordTransaction( setting.getCost() );
			affords ? _minersHutButton.enable() : _minersHutButton.disable();

			setting = settings.getSettingsForType( BuildingType.CAMP );
			affords = player.canAffordTransaction( setting.getCost() );
			affords ? _campButton.enable() : _campButton.disable();

			setting = settings.getSettingsForType( BuildingType.ARCHERY );
			affords = player.canAffordTransaction( setting.getCost() );
			affords ? _archeryButton.enable() : _archeryButton.disable();

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
