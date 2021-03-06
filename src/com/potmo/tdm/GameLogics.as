package com.potmo.tdm
{

	import com.potmo.tdm.player.OrderManager;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.player.PlayerColor;
	import com.potmo.tdm.visuals.building.Building;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.building.BuildingFactory;
	import com.potmo.tdm.visuals.building.BuildingManager;
	import com.potmo.tdm.visuals.hud.HudManager;
	import com.potmo.tdm.visuals.hud.variant.DeployFlagHud;
	import com.potmo.tdm.visuals.map.DeployFlag;
	import com.potmo.tdm.visuals.map.MapBase;
	import com.potmo.tdm.visuals.unit.Unit;
	import com.potmo.tdm.visuals.unit.UnitFactory;
	import com.potmo.tdm.visuals.unit.UnitManager;
	import com.potmo.tdm.visuals.unit.projectile.Projectile;
	import com.potmo.tdm.visuals.unit.projectile.ProjectileFactory;
	import com.potmo.tdm.visuals.unit.projectile.ProjectileType;
	import com.potmo.util.logger.Logger;

	public final class GameLogics
	{

		//TODO: Add the real players
		private var _playerRed:Player = new Player( 0, "RedPlayer", PlayerColor.RED, true );
		private var _playerBlue:Player = new Player( 1, "BluePlayer", PlayerColor.BLUE, false );
		private var _playerNeutral:Player = new Player( 2, "NeutralPlayer", PlayerColor.NEUTRAL, false );

		private var _projectiles:Vector.<Projectile> = new Vector.<Projectile>();

		private var _map:MapBase;

		private var _gameView:GameView;
		private var _orderManager:OrderManager;

		private var _unitFactory:UnitFactory;
		private var _buildingFactory:BuildingFactory;
		private var _projectileFactory:ProjectileFactory;

		private var _unitManager:UnitManager;
		private var _buildingManager:BuildingManager;
		private var _hudManager:HudManager;


		public function GameLogics( view:GameView, orderManager:OrderManager, unitManager:UnitManager, buildingManager:BuildingManager, projectileFactory:ProjectileFactory, hudManager:HudManager, map:MapBase )
		{

			this._gameView = view;
			this._orderManager = orderManager;
			this._projectileFactory = projectileFactory;
			this._unitManager = unitManager;
			this._buildingManager = buildingManager;
			this._hudManager = hudManager;
			this._map = map;

			this.initialize();
		}


		private function initialize():void
		{

			_gameView.setGameLogics( this );
			_gameView.setOrderManager( _orderManager );
			_orderManager.setGameLogics( this );

			_gameView.addMap( _map );

			_buildingManager.createDefaultBuildings( _playerRed, _playerBlue, _playerNeutral, this );

		}


		public function update():void
		{

			_buildingManager.update( this );

			//TODO: Build a projectile manager
			var length:int = _projectiles.length;

			for ( var i:int = length - 1; i >= 0; i-- )
			{
				_projectiles[ i ].update( this );

			}

			_unitManager.update( this );
			_gameView.update();
			_hudManager.update( this );

		}


		public function onMapClicked( x:int, y:int ):void
		{

			// check if a building was clicked
			var clickedBuilding:Building = _buildingManager.getBuildingUnderPosition( x, y );

			//send to the clicked building that it was clicked if any
			//TODO: Comment this in if you dont want to be able to alter other players buildings
			if ( clickedBuilding ) //&& clickedBuilding.getOwningPlayer().isMe() )
			{
				Logger.log( "building clicked" );
				clickedBuilding.handleClick( x, y, this );

			}

		}


		public function shootProjectile( type:ProjectileType, fromX:int, fromY:int, toX:int, toY:int ):void
		{
			var projectile:Projectile = _projectileFactory.getProjectile( type );
			_projectiles.push( projectile );
			_gameView.addProjectile( projectile );
			projectile.launch( fromX, fromY, toX, toY );

		}


		public function projectileReachedTarget( projectile:Projectile ):void
		{
			var hitRadius:int = projectile.getHitRadius();
			var hitX:int = projectile.getTargetX();
			var hitY:int = projectile.getTargetY();
			var damage:int = projectile.getDamage();

			var unit:Unit = _unitManager.getClosestUnitToPointWithinRange( hitX, hitY, hitRadius );

			if ( unit )
			{
				unit.damage( damage, this );
				removeProjectile( projectile );
			}

			//TODO: Projectiles that miss should be stuck in the ground for a while

		}


		public function removeProjectile( projectile:Projectile ):void
		{
			var index:int = _projectiles.indexOf( projectile );
			_projectiles.splice( index, 1 );
			_gameView.removeProjectile( projectile );
			_projectileFactory.returnProjectile( projectile );
		}


		public function getBuildingManager():BuildingManager
		{
			return _buildingManager;
		}


		public function getGameView():GameView
		{
			return _gameView;
		}


		public function getUnitManager():UnitManager
		{
			return _unitManager;
		}


		public function getMap():MapBase
		{
			return _map;
		}


		public function getHudManager():HudManager
		{
			return _hudManager;

		}
	}
}
