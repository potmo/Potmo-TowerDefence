package com.potmo.tdm
{
	import com.potmo.p2d.atlas.P2DTextureAtlas;
	import com.potmo.p2d.atlas.animation.P2DSpriteAtlas;
	import com.potmo.p2d.atlas.parser.AtlasParser;
	import com.potmo.p2d.atlas.parser.Cocos2DParser;
	import com.potmo.p2d.renderer.P2DCamera;
	import com.potmo.p2d.renderer.P2DRenderer;
	import com.potmo.tdm.connection.Connector;
	import com.potmo.tdm.player.OrderManager;
	import com.potmo.tdm.visuals.ScreenSize;
	import com.potmo.tdm.visuals.building.BuildingFactory;
	import com.potmo.tdm.visuals.building.BuildingManager;
	import com.potmo.tdm.visuals.hud.HudManager;
	import com.potmo.tdm.visuals.map.MapBase;
	import com.potmo.tdm.visuals.map.MapZero;
	import com.potmo.tdm.visuals.unit.UnitBase;
	import com.potmo.tdm.visuals.unit.UnitFactory;
	import com.potmo.tdm.visuals.unit.UnitManager;
	import com.potmo.tdm.visuals.unit.projectile.ProjectileFactory;
	import com.potmo.tdm.visuals.unit.state.UnitStateFactory;
	import com.potmo.util.fpsCounter.FPSCounter;
	import com.potmo.util.input.MouseManager;
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	[SWF( backgroundColor = "0xCCCCCC", frameRate = "30", width = "960", height = "640" )]
	public class TowerDefenceMulti extends flash.display.Sprite
	{

		private var _renderer:P2DRenderer;

		private var _textureAtlas:P2DTextureAtlas;
		private var _spriteAtlas:P2DSpriteAtlas;

		[Embed( source = "assets/atlas.xml", mimeType = "application/octet-stream" )]
		private static const ATLAS_DESCRIPTOR:Class;

		[Embed( source = "assets/atlas.png", mimeType = "image/png" )]
		private static const ATLAS_TEXTURE:Class;

		[Embed( source = "assets/maps/map0_atlas.xml", mimeType = "application/octet-stream" )]
		private static const MAP_ATLAS_DESCRIPTOR:Class;

		[Embed( source = "assets/maps/map0_atlas.png", mimeType = "image/png" )]
		private static const MAP_ATLAS_TEXTURE:Class;

		private var _frameRateCounter:FPSCounter;
		private var _gameView:GameView;
		private var _orderManager:OrderManager;
		private var _gameLogics:GameLogics;
		private var _map:MapBase;
		private var _unitStateFactory:UnitStateFactory;
		private var _unitFactory:UnitFactory;
		private var _buildingFactory:BuildingFactory;
		private var _projectileFactory:ProjectileFactory;
		private var _unitManager:UnitManager;
		private var _buildingManager:BuildingManager;
		private var _hudManager:HudManager;
		private var _camera:P2DCamera;


		public function TowerDefenceMulti()
		{
			Logger.log( "Startup" );

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			this._frameRateCounter = new FPSCounter();
			addChild( _frameRateCounter );

			MouseManager.initialize( stage );

			// Request a 3D context instance
			var stage3D:Stage3D = stage.stage3Ds[ 0 ];
			stage3D.addEventListener( Event.CONTEXT3D_CREATE, onContextCreated );
			stage3D.addEventListener( ErrorEvent.ERROR, onContextLost );
			stage3D.requestContext3D( Context3DRenderMode.AUTO );

			var viewPort:Rectangle = new Rectangle( 0, 0, 960, 640 );

			var xmlDescriptor:XML = new XML( new ATLAS_DESCRIPTOR() );
			var texture:BitmapData = ( new ATLAS_TEXTURE() as Bitmap ).bitmapData;

			var mapXmlDescriptor:XML = new XML( new MAP_ATLAS_DESCRIPTOR() );
			var mapTexture:BitmapData = ( new MAP_ATLAS_TEXTURE() as Bitmap ).bitmapData;

			var parser:AtlasParser = new Cocos2DParser();

			_textureAtlas = new P2DTextureAtlas();
			_textureAtlas.addTexture( xmlDescriptor, texture, parser );
			_textureAtlas.addTexture( mapXmlDescriptor, mapTexture, parser );

			_spriteAtlas = new P2DSpriteAtlas( _textureAtlas.getFrameNames(), _textureAtlas.getFrameSizes() );

			_camera = new P2DCamera();

			_renderer = new P2DRenderer( viewPort, 0, _textureAtlas, _camera );

			addGame();

		}


		private function onContextLost( event:ErrorEvent ):void
		{
			_renderer.handleContentLost();
		}


		private function onContextCreated( event:Event ):void
		{
			var stage3D:Stage3D = event.target as Stage3D;
			var context3D:Context3D = stage3D.context3D;
			context3D.enableErrorChecking = true;
			context3D.setDepthTest( false, Context3DCompareMode.ALWAYS );
			context3D.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
			context3D.setCulling( Context3DTriangleFace.NONE );

			_renderer.handleContextCreated( context3D );

			addEventListener( Event.ENTER_FRAME, onEnterFrame );

		}


		private function onEnterFrame( event:Event = null ):void
		{
			_gameLogics.update();
			_renderer.render( _gameView );
		}


		private function addGame():void
		{

			_gameView = new GameView( _camera );
			_orderManager = new OrderManager();
			_map = new MapZero( _spriteAtlas );
			_unitStateFactory = new UnitStateFactory();
			_unitFactory = new UnitFactory( _spriteAtlas );
			_buildingFactory = new BuildingFactory( _spriteAtlas );
			_projectileFactory = new ProjectileFactory( _spriteAtlas );

			_unitManager = new UnitManager( _unitFactory, _unitStateFactory, _map );
			_buildingManager = new BuildingManager( _buildingFactory );
			_hudManager = new HudManager( _spriteAtlas, _gameView );

			_gameLogics = new GameLogics( _gameView, _orderManager, _unitManager, _buildingManager, _projectileFactory, _hudManager, _map );

		}

	}
}
