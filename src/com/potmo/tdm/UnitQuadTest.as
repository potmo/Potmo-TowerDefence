package com.potmo.tdm
{
	import com.potmo.tdm.visuals.unit.IUnit;
	import com.potmo.tdm.visuals.unit.UnitQuadTree;
	import com.potmo.util.image.BitmapUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;

	[SWF( backgroundColor = "0xCCCCCC", frameRate = "30", width = "960", height = "640" )]
	public class UnitQuadTest extends Sprite
	{

		private var canvas:BitmapData;
		private var unitQuad:UnitQuadTree;
		private var units:Vector.<Unit>;


		public function UnitQuadTest()
		{

			canvas = new BitmapData( 500, 500, false );
			addChild( new Bitmap( canvas ) );

			unitQuad = new UnitQuadTree( 0, 0, 500, 500 );
			units = new Vector.<Unit>();

			addUnits( 50 );

			unitQuad.draw( canvas, 1 );

			addEventListener( Event.ENTER_FRAME, onEnterFrame );

		}


		private function onEnterFrame( event:Event ):void
		{
			for each ( var unit:Unit in units )
			{
				unit.setX( unit.getX() + Math.random() * 4 - 2 );
				unit.setY( unit.getY() + Math.random() * 4 - 2 );

				if ( unit.isPositionDirty() )
				{
					unitQuad.cleanPosition( unit );
				}
			}

			BitmapUtil.fill( canvas, 0xFFFFFFFF );
			unitQuad.draw( canvas, 1 );
		}


		private function addUnits( count:int ):void
		{
			var unit:Unit;

			for ( var i:int = 0; i < count; i++ )
			{
				unit = new Unit();
				units.push( unit );
				unit.setX( Math.random() * 500 );
				unit.setY( Math.random() * 500 );

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

	private var x:Number;
	private var y:Number;
	private var _oldX:Number;
	private var _oldY:Number;
	private var _positionIsDirty:Boolean;
	private var _velx:Number;
	private var _vely:Number;


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
			_oldY = x;
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

}
