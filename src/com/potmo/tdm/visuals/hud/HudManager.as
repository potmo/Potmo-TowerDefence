package com.potmo.tdm.visuals.hud
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.GameView;
	import com.potmo.tdm.visuals.building.Building;
	import com.potmo.tdm.visuals.building.variant.Camp;
	import com.potmo.tdm.visuals.building.variant.ConstructionSite;
	import com.potmo.tdm.visuals.hud.variant.CampHud;
	import com.potmo.tdm.visuals.hud.variant.ConstructionSiteHud;
	import com.potmo.tdm.visuals.hud.variant.DeployFlagHud;
	import com.potmo.util.logger.Logger;

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
			Logger.log( "showCampHud" );

			if ( !_campHud )
			{
				_campHud = new CampHud( _spriteAtlas );
			}

			_campHud.setup( camp );
			setHud( _campHud );
		}


		public function showConstructionSiteHud( constructionSite:ConstructionSite ):void
		{
			Logger.log( "showConstructionSiteHud" );

			if ( !_constructionSiteHud )
			{
				_constructionSiteHud = new ConstructionSiteHud( _spriteAtlas );
			}

			_constructionSiteHud.setup( constructionSite );
			setHud( _constructionSiteHud );
		}


		public function showDeployFlagHud( building:Building ):void
		{
			Logger.log( "showDeployFlagHud" );

			if ( !_deployFlagHud )
			{
				_deployFlagHud = new DeployFlagHud( _spriteAtlas );
			}

			_deployFlagHud.setup( building, _gameView );

			setHud( _deployFlagHud );
		}


		public function hideHud():void
		{
			Logger.log( "hideHud" );
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


		public function update( gameLogics:GameLogics ):void
		{
			if ( _currentHud )
			{
				_currentHud.setX( Math.round( _gameView.getCameraPosition() ) );
				_currentHud.update( gameLogics );
			}
		}
	}
}
