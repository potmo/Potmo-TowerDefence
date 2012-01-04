package com.potmo.tdm.visuals.map.forcemap.forcefieldmap
{
	import com.potmo.tdm.visuals.map.forcemap.MapTile;
	import com.potmo.tdm.visuals.map.forcemap.MapTileType;
	import com.potmo.util.image.BitmapUtil;

	import flash.display.BitmapData;
	import flash.geom.Point;

	public class ForceFieldTile extends MapTile
	{

		private var _flowFieldImage:BitmapData;

		private var _force:Force;
		private var _isDirty:Boolean = true;

		private var _forceFieldMap:ITileForceFieldMap;


		public function ForceFieldTile( forceFieldField:ITileForceFieldMap, x:int, y:int, type:MapTileType, force:Force = null )
		{
			super( x, y, type );

			this._forceFieldMap = forceFieldField;

			if ( !force )
			{
				_force = new Force( 0, 0 );
			}
			else
			{
				_force = force;
			}

		}


		private function preRender( horizontalTileSize:int, verticalTileSize:int ):void
		{

			if ( !_flowFieldImage )
			{
				_flowFieldImage = new BitmapData( horizontalTileSize, verticalTileSize, false, 0xAAAAAA );
			}

			//set as not any longer dirty
			_isDirty = false;

			//render field
			for ( var sx:Number = 0; sx < horizontalTileSize; sx++ )
			{
				for ( var sy:Number = 0; sy < verticalTileSize; sy++ )
				{

					var rx:Number = x + sx / horizontalTileSize;
					var ry:Number = y + sy / verticalTileSize;

					var f:Force = _forceFieldMap.getTileForce( rx, ry );

					MapDrawUtil.drawForce( _flowFieldImage, sx, sy, f );
				}
			}

			//render forces
			var halfHoriSize:Number = horizontalTileSize / 2;
			var halfVertSize:Number = verticalTileSize / 2;

			//BitmapUtil.efla(halfHoriSize-3, halfVertSize-3, halfHoriSize+3, halfVertSize+3,0xFFFFFF, flowFieldImage);
			//BitmapUtil.efla(halfHoriSize-3, halfVertSize+3, halfHoriSize+3, halfVertSize-3,0xFFFFFF, flowFieldImage);
			//BitmapUtil.drawCirlce( halfHoriSize, halfHoriSize, 1, 0xFFFFFF, flowFieldImage );
			BitmapUtil.efla( halfHoriSize, halfVertSize, halfHoriSize + _force.x * halfHoriSize, halfVertSize + _force.y * halfVertSize, 0xFFFFFF, _flowFieldImage );
			//	var perpForce:Vector3D = new Vector3D( _force.y, -_force.x );

			//	BitmapUtil.efla( halfHoriSize, halfVertSize, halfHoriSize + _force.x * halfHoriSize + perpForce.x, halfVertSize + _force.y * halfVertSize + perpForce.y, 0xFFFFFF, flowFieldImage );

		}


		public function draw( canvas:BitmapData, horizontalTileSize:int, verticalTileSize:int ):void
		{

			if ( _isDirty )
			{
				preRender( horizontalTileSize, verticalTileSize );
			}

			canvas.copyPixels( _flowFieldImage, _flowFieldImage.rect, new Point( x * horizontalTileSize, y * verticalTileSize ) );

		}


		public function get force():Force
		{
			return _force.clone();
		}


		public function set force( f:Force ):void
		{
			_force = f;
			_isDirty = true;
		}

	}
}
