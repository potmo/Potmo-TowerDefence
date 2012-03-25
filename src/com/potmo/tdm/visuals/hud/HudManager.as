package com.potmo.tdm.visuals.hud
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameView;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.building.variant.Camp;
	import com.potmo.tdm.visuals.building.variant.ConstructionSite;
	import com.potmo.tdm.visuals.hud.variant.CampHud;
	import com.potmo.tdm.visuals.hud.variant.ConstructionSiteHud;
	import com.potmo.tdm.visuals.hud.variant.DeployFlagHud;
	import com.potmo.tdm.visuals.map.DeployFlag;

	public class HudManager
	{
		private var _spriteAtlas:SpriteAtlas;

		private var _campHud:CampHud;
		private var _constructionSiteHud:ConstructionSiteHud;
		private var _deployFlagHud:DeployFlagHud;
		private var _gameView:GameView;
		private var _currentHud:HudBase = null;


		public function HudManager( spriteAtlas:SpriteAtlas, gameView:GameView )
		{
			_spriteAtlas = spriteAtlas;
			_gameView = gameView;
		}


		public function showCampHud( camp:Camp ):void
		{
			if ( !_campHud )
			{
				_campHud = new CampHud( _spriteAtlas );
			}

			_campHud.setCamp( camp );
			setHud( _campHud );
		}


		public function showConstructionSiteHud( constructionSite:ConstructionSite ):void
		{
			if ( !_constructionSiteHud )
			{
				_constructionSiteHud = new ConstructionSiteHud( _spriteAtlas );
			}

			_constructionSiteHud.setConstructionSite( constructionSite );
			setHud( _constructionSiteHud );
		}


		public function showConstructionDeployFlagHud( building:BuildingBase ):void
		{
			if ( !_deployFlagHud )
			{
				_deployFlagHud = new DeployFlagHud( _spriteAtlas );
			}
			var deployFlag:DeployFlag = new DeployFlag( _spriteAtlas );
			_gameView.addMapItem( deployFlag );

			_deployFlagHud.setDeployFlagAndBuilding( deployFlag, building );

			_gameView.startIgnoreMapInteraction();

			setHud( _deployFlagHud );
		}


		public function hideHud():void
		{
			removeHud();
		}


		private function setHud( hud:HudBase ):void
		{
			if ( _currentHud == hud )
			{
				return;
			}

			if ( _currentHud )
			{
				removeHud();
			}
			_currentHud = hud;
			_gameView.setHud( hud );
		}


		private function removeHud():void
		{
			if ( _currentHud )
			{
				_currentHud.clear();
				_gameView.removeHud();

				_gameView.stopIgnoreMapInteraction();
				_currentHud = null;
			}
		}

	}
}
