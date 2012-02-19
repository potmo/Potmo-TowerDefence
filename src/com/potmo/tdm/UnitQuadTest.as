package com.potmo.tdm
{
	import com.potmo.tdm.visuals.unit.IUnit;
	import com.potmo.tdm.visuals.unit.quadtree.QuadTree;
	import com.potmo.util.image.BitmapUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	[SWF( backgroundColor = "0xCCCCCC", frameRate = "30", width = "960", height = "640" )]
	public class UnitQuadTest extends Sprite
	{

		private var canvas:BitmapData;
		private var unitQuad:QuadTree;
		private var units:Vector.<IUnit>;
		private var mouseRect:Rectangle = new Rectangle( 0, 0, 60, 60 );
		private static const WIDTH:int = 600;
		private static const HEIGHT:int = 600;


		public function UnitQuadTest()
		{

			canvas = new BitmapData( WIDTH, HEIGHT, false );
			addChild( new Bitmap( canvas ) );

			unitQuad = new QuadTree( 0, 0, WIDTH, HEIGHT, 4, 1 );
			units = new Vector.<IUnit>();

			addUnits( 100 );

			unitQuad.draw( canvas, 1 );
			drawUnits( units, 0xFF0000FF, 1 );
			addEventListener( Event.ENTER_FRAME, onEnterFrame );

		}


		private function drawUnits( units:Vector.<IUnit>, color:uint, scale:Number = 1.0 ):void
		{
			for each ( var unit:IUnit in units )
			{
				BitmapUtil.drawCirlce( unit.getX(), unit.getY(), unit.getRadius() - 1, color, canvas );
			}
		}


		private function onEnterFrame( event:Event ):void
		{
			BitmapUtil.fill( canvas, 0xFFFFFFFF );

			for each ( var unit:Unit in units )
			{
				var velX:Number = unit.getVelX();
				var velY:Number = unit.getVelY();

				//	velX = velX * 0.95 + Math.random() * 1 - 0.5;
				//	velY = velY * 0.95 + Math.random() * 1 - 0.5;

				var newX:Number = unit.getX() + velX;
				var newY:Number = unit.getY() + velY;

				if ( newX > WIDTH )
				{
					newX -= WIDTH;
				}

				if ( newX < 0 )
				{
					newX += WIDTH;
				}

				if ( newY > HEIGHT )
				{
					newY -= HEIGHT;
				}

				if ( newY < 0 )
				{
					newY += HEIGHT;
				}

				unit.setX( newX );
				unit.setY( newY );

				if ( unit.isPositionDirty() )
				{
					unitQuad.cleanPosition( unit );
				}

			}

			unitQuad.draw( canvas, 1 );
			drawUnits( units, 0xFF0000FF, 1 );

			mouseRect.x = mouseX;
			mouseRect.y = mouseY;

			// get units from pos
			//var unitsUnder:Vector.<IUnit> = unitQuad.retriveFromPosition( mouseX, mouseY );
			var unitsUnder:Vector.<IUnit> = unitQuad.retriveFromRect( mouseRect.x, mouseRect.y, mouseRect.width, mouseRect.height );
			drawUnits( unitsUnder, 0xFF00FF00, 1 );

			BitmapUtil.drawRectangle( mouseRect.x, mouseRect.y, mouseRect.width, mouseRect.height, 0xFF000000, canvas );
		}


		private function addUnits( count:int ):void
		{
			var unit:Unit;

			for ( var i:int = 0; i < count; i++ )
			{
				unit = new Unit();
				unit.setName( "id:" + i );
				units.push( unit );
				unit.setX( Math.random() * WIDTH );
				unit.setY( Math.random() * HEIGHT );
				/*	unit.setVelX( Math.random() * 1 - 0.5 );
				   unit.setVelY( Math.random() * 1 - 0.5 );*/
				unit.setPositionAsClean();
				unitQuad.insert( unit );
			}

		}
	}
}
import com.potmo.tdm.GameLogics;
import com.potmo.tdm.player.Player;
import com.potmo.tdm.visuals.building.BuildingBase;
import com.potmo.tdm.visuals.unit.IUnit;
import com.potmo.tdm.visuals.unit.UnitType;
import com.potmo.tdm.visuals.unit.settings.IUnitSetting;

import starling.display.DisplayObject;

internal class Unit implements IUnit
{

	private var x:Number = 0;
	private var y:Number = 0;
	private var _oldX:Number = 0;
	private var _oldY:Number = 0;
	private var _positionIsDirty:Boolean = false;
	private var _velx:Number = 0;
	private var _vely:Number = 0;
	private var _name:String = "N/A";


	public function toString():String
	{
		return "Unit[" + _name + "," + x + "," + y + ":" + _oldX + "," + _oldY + "]";
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
		_positionIsDirty = false;
		_oldX = this.x;
		_oldY = this.y;
	}


	final public function setX( value:Number ):void
	{
		if ( x != value )
		{
			_oldX = x;
			_positionIsDirty = true;
			this.x = value;
		}
	}


	final public function getX():Number
	{
		return x;
	}


	final public function setY( value:Number ):void
	{
		if ( y != value )
		{
			_oldY = y;
			_positionIsDirty = true;
			this.y = value;
		}
	}


	final public function getY():Number
	{
		return y;
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


	final public function getRadius():Number
	{
		return 4;
	}


	public function init( gameLogics:GameLogics ):void
	{

	}


	public function reset( gameLogics:GameLogics ):void
	{

	}


	public function update( gameLogics:GameLogics ):void
	{

	}


	public function damage( amount:int, gameLogics:GameLogics ):void
	{

	}


	public function kill( gameLogics:GameLogics ):void
	{

	}


	public function heal( amount:int, gameLogics:GameLogics ):void
	{

	}


	public function charge( gameLogics:GameLogics ):void
	{

	}


	public function deploy( x:int, y:int, gameLogics:GameLogics ):void
	{

	}


	public function getHomeBuilding():BuildingBase
	{
		return null;
	}


	public function setHomeBuilding( building:BuildingBase ):void
	{

	}


	public function getOwningPlayer():Player
	{
		return null;

	}


	public function setOwningPlayer( player:Player ):void
	{

	}


	public function getType():UnitType
	{
		return null;

	}


	public function getAsDisplayObject():DisplayObject
	{
		return null;
	}


	public function isTargetedByAnyUnit():Boolean
	{
		return false;
	}


	public function startBeingTargetedByUnit( other:IUnit ):void
	{

	}


	public function stopBeingTargetedByUnit( other:IUnit ):void
	{

	}


	public function getSettings():IUnitSetting
	{
		return null;
	}


	public function setName( name:String ):void
	{
		this._name = name;

	}


	public function startTargetUnit( other:IUnit ):void
	{
		// TODO Auto-generated method stub
	}


	public function stopTargetUnit():void
	{
		// TODO Auto-generated method stub
	}


	public function isTartetingAnyUnit():Boolean
	{
		return false;
	}
}
