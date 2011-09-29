package com.potmo.tdm.visuals.starling
{
	import com.potmo.util.image.BitmapUtil;

	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	import starling.textures.Texture;

	public class TextureAnimationCacheObject
	{
		private var _frames:Vector.<Texture>;
		private var _offsetX:int;
		private var _offsetY:int;
		private var _frameLabels:Vector.<FrameLabel>;


		public function TextureAnimationCacheObject( clip:MovieClip )
		{
			var bitFrames:Vector.<BitmapData> = BitmapUtil.rasterizeMovieClip( clip );

			//TODO: Trim the textures so there is no empty pixels. Then put them in a gigantic bitmap and use it as a texture. then us Texture.fromTexture(). Saves some memory

			_frames = new <Texture>[];

			for each ( var bitFrame:BitmapData in bitFrames )
			{
				_frames.push( Texture.fromBitmapData( bitFrame, false, false ) );
			}

			var enclosingRect:Rectangle = BitmapUtil.getEnclosingRect( clip );
			_offsetX = enclosingRect.x;
			_offsetY = enclosingRect.y;

			_frameLabels = BitmapUtil.getFrameLables( clip );
		}


		public function get frames():Vector.<Texture>
		{
			return _frames;
		}


		public function get offsetX():int
		{
			return _offsetX;
		}


		public function get offsetY():int
		{
			return _offsetY;
		}


		public function get frameLabels():Vector.<FrameLabel>
		{
			return _frameLabels;
		}
	}
}
