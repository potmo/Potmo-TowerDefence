package com.potmo.tdm.visuals.unit
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.p2d.atlas.animation.SpriteAtlasSequence;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.display.BasicRenderItem;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.building.Building;
	import com.potmo.tdm.visuals.unit.state.UnitState;
	import com.potmo.tdm.visuals.unit.variant.settings.UnitSettings;
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	public class UnitBase extends BasicRenderItem implements Unit
	{
		private var _settings:UnitSettings;

		protected var currentState:UnitState;
		private var _owningPlayer:Player;
		private var _homeBuilding:Building;

		protected var targetedByUnits:Vector.<Unit> = new Vector.<Unit>();

		private var _velx:Number = 0;
		private var _vely:Number = 0;

		private var _health:int;

		private static const HEALTH_BAR_HEIGHT:int = 6;
		private static const HEALTH_BAR_WIDTH:int = 20;
		private var _oldX:Number;
		private var _oldY:Number;
		private var _positionIsDirty:Boolean;
		private var _targetUnit:Unit;
		private var _spawned:Boolean;
		private var _numberOfTargetingEnemies:int;


		public function UnitBase( spriteAtlas:SpriteAtlas, settings:UnitSettings )
		{
			super( spriteAtlas.getSequenceByName( settings.getSequenceName() ) );
			this._settings = settings;

			_health = settings.getMaxHealth();

			_spawned = false;

		/*_healthBarBackground = new Quad( HEALTH_BAR_WIDTH, HEALTH_BAR_HEIGHT, 0xFFCCCCCC );
		   _healthBarBackground.x = -_healthBarBackground.width / 2;
		   _healthBarBackground.y = -_mainGraphics.height - _healthBarBackground.height;
		   this.addChild( _healthBarBackground );

		   _healthBar = new Quad( HEALTH_BAR_WIDTH - 2, HEALTH_BAR_HEIGHT - 2, 0xFF00CC00 );
		   _healthBar.x = _healthBarBackground.x + 1;
		   _healthBar.y = _healthBarBackground.y + 1;
		   this.addChild( _healthBar );*/

		}


		public function init( gameLogics:GameLogics ):void
		{
			// override
			throw new Error( "Override init in unit variant" );
		}


		/**
		 * Reset and clear all saved information
		 */
		final public function reset( gameLogics:GameLogics ):void
		{
			//TODO: Probably more to reset for unit

			// make sure its dead
			setHealth( 0 );
			_owningPlayer = null;
			// currentState must not be cleared. It will be returned and reset in init
			_homeBuilding = null;
			_velx = 0;
			_vely = 0;
			_spawned = false;
		}


		final public function spawn( gameLogics:GameLogics ):void
		{
			_spawned = true;
			setHealth( _settings.getMaxHealth() );
		}


		/**
		 * Update the unit in the mail loop
		 */
		final public function update( gameLogics:GameLogics ):void
		{

			// visit the state to see if we should make any changes to it
			currentState.visit( gameLogics );

			// update the frames
			currentFrame = graphicsSequence.getNextFrame( currentFrame, false, true );
		}


		final public function setFrameFromName( name:String ):void
		{
			currentFrame = graphicsSequence.getFrameOfLabel( name );
		}


		/**
		 * Set the health and update healthbar
		 */
		final protected function setHealth( value:int ):void
		{
			var newHealth:int = StrictMath.clamp( value, 0, _settings.getMaxHealth() );

			if ( newHealth != _health )
			{
				_health = newHealth;
					//_healthBar.width = ( _health / _settings.maxHealth ) * ( HEALTH_BAR_WIDTH - 2 );
			}
		}


		final protected function getHealth():int
		{
			return _health;
		}


		/**
		 * Damage this unit.
		 * If the unit has health left the unit will be hurt
		 * If the unit has no health left then the unit will be killed and then probably die
		 */
		final public function damage( amount:int, gameLogics:GameLogics ):void
		{

			amount = StrictMath.min( getHealth(), amount );

			setHealth( getHealth() - amount );

			if ( getHealth() <= 0 )
			{
				kill( gameLogics );
			}
			else
			{
				handleBeingHurt( amount, gameLogics );
			}
		}


		/**
		 * Kill this unit. It will probably die (but does not have to)
		 */
		final public function kill( gameLogics:GameLogics ):void
		{
			Logger.log( "Kill Unit: " + this );
			handleBeingKilled( gameLogics );
		}


		/**
		 * Heal this unit. Health will increase
		 */
		final public function heal( amount:int, gameLogics:GameLogics ):void
		{
			var healthBefore:int = getHealth();
			setHealth( healthBefore + amount );
			var healthAfter:int = getHealth();
			handleBeingHealed( healthAfter - healthBefore, gameLogics );
		}


		/**
		 * Tell this unit to charge (start walking towards the enemy base)
		 */
		final public function charge( gameLogics:GameLogics ):void
		{
			handleBeeingCommandedToCharge( gameLogics );
		}


		/**
		 * Tell the unit to deploy (just set the position where to start)
		 */
		final public function deploy( x:int, y:int, gameLogics:GameLogics ):void
		{
			handleBeingDeployed( x, y, gameLogics );
		}


		final public function moveToFlag( gameLogics:GameLogics ):void
		{
			var homeBuilding:Building = this.getHomeBuilding();
			var deployFlagX:int = homeBuilding.getDeployFlagX();
			var deployFlagY:int = homeBuilding.getDeployFlagY();
			handleBeeingCommandedToMoveToPosition( deployFlagX, deployFlagY, gameLogics );
		}


		final public function setHomeBuilding( building:Building ):void
		{
			this._homeBuilding = building;
		}


		final public function getHomeBuilding():Building
		{
			return _homeBuilding;
		}


		final public function setOwningPlayer( player:Player ):void
		{
			this._owningPlayer = player;

			if ( _owningPlayer )
			{
				/*if ( _owningPlayer.getColor() == PlayerColor.RED )
				   {
				   _healthBar.color = 0xFFFF0000;
				   }
				   else
				   {
				   _healthBar.color = 0xFF0000FF;
				   }*/
			}
		}


		final public function getOwningPlayer():Player
		{
			return _owningPlayer;
		}


		final public function getType():UnitType
		{
			return _settings.getUnitType();
		}


		final public function getOldX():Number
		{
			return _oldX;
		}


		final public function getOldY():Number
		{
			return _oldY;
		}


		final public function isPositionDirty():Boolean
		{
			return _positionIsDirty;
		}


		final public function setPositionAsClean():void
		{
			_oldX = this.x;
			_oldY = this.y;
			_positionIsDirty = false;
		}


		final override public function setX( value:Number ):void
		{
			if ( this.x != value )
			{
				_positionIsDirty = true;
				this.x = value;
			}
		}


		final override public function setY( value:Number ):void
		{
			if ( this.y != value )
			{
				_positionIsDirty = true;
				this.y = value;
			}
		}


		final public function setVelX( value:Number ):void
		{
			this._velx = value;
		}


		final public function getVelX():Number
		{
			return _velx;
		}


		final public function setVelY( value:Number ):void
		{
			this._vely = value;
		}


		final public function getVelY():Number
		{
			return _vely;
		}


		public function getZDepth():int
		{
			return this.y;
		}


		public function setColorMultiplyer( alpha:Number, red:Number, green:Number, blue:Number ):void
		{
			this.redMultiplyer = red;
			this.greenMultiplyer = green;
			this.blueMultiplyer = blue;
			this.alphaMultiplyer = alpha;
		}


		final public function getRadius():Number
		{
			return _settings.getRadius();
		}


		final public function getSettings():UnitSettings
		{
			return _settings;
		}


		final public function getState():UnitState
		{
			return currentState;
		}


		final public function isDead():Boolean
		{
			return !_spawned || getHealth() <= 0;
		}


		public function targetedByEnemy():void
		{
			_numberOfTargetingEnemies++;
		}


		public function untargetedByEnemy():void
		{
			_numberOfTargetingEnemies--;
		}


		public function getNumberOfTargetingEnemies():int
		{
			return _numberOfTargetingEnemies;
		}


		// functions to override
		public function handleBeingHurt( amount:int, gameLogics:GameLogics ):void
		{
			throw new Error( "Override function in unit variant" );
		}


		public function handleBeingKilled( gameLogics:GameLogics ):void
		{
			throw new Error( "Override function in unit variant" );
		}


		public function handleBeingHealed( amount:int, gameLogics:GameLogics ):void
		{
			throw new Error( "Override function in unit variant" );
		}


		public function handleBeeingCommandedToCharge( gameLogics:GameLogics ):void
		{
			throw new Error( "Override function in unit variant" );
		}


		public function handleBeingDeployed( x:int, y:int, gameLogics:GameLogics ):void
		{
			throw new Error( "Override function in unit variant" );

		}


		public function handleBeeingCommandedToMoveToPosition( x:int, y:int, gameLogics:GameLogics ):void
		{
			throw new Error( "Override function in unit variant" );

		}


		public function toString():String
		{
			return "[" + getType().toString() + " p: " + ( _owningPlayer ? _owningPlayer.getColor().toString() : null ) + "]";
		}

	}
}
