package com.potmo.tdm.visuals.starling
{
	import com.potmo.util.image.BitmapAnimationCacheObject;

	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.Graphics;
	import flash.geom.Rectangle;

	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	public class TextureAnimation extends MovieClip
	{
		private var graphicsCache:TextureAnimationCacheObject;


		public function TextureAnimation( graphics:TextureAnimationCacheObject )
		{
			graphicsCache = graphics;
			super( graphicsCache.frames, 30 );

			pivotX = -graphics.offsetX;
			pivotY = -graphics.offsetY;
			this.smoothing = TextureSmoothing.NONE;

		}


		/**
		 * Set the name from framelabel
		 * @throws Error if not frame has that name
		 */
		public function setFrameFromName( name:String ):void
		{
			currentFrame = getFrameFromName( name );
		}


		/**
		 * Goes to the next frame. If loop is true (default) it will loop if the end is reached
		 */
		public function nextFrame():void
		{

			// check if it is a label decorator to loop
			var frameName:String = getNameOfFrame( currentFrame );

			if ( frameName != "" )
			{
				// split the name 
				// LOOP_NAME means loop on the frame
				// GOTO_NAME means go to frame to NAME
				var parts:Array = frameName.split( "_" );

				if ( parts.length >= 2 )
				{
					// get the first element witch is the instruction
					// remove the instruction
					var instruction:String = parts.splice( 0, 1 )[ 0 ];

					if ( instruction == "GOTO" )
					{

						// join the rest so we get the underscore but without the first one
						var rest:String = parts.join( "_" );

						var newFrame:int = getFrameFromName( rest );

						if ( newFrame != -1 )
						{
							currentFrame = newFrame;
							return;
						}
					}
					else if ( instruction == "LOOP" )
					{
						return;
					}

				}

			}

			// just step ahead
			currentFrame++;
		}


		/**
		 * get the frame named with a framelabel
		 * @returns the frame or -1 if not found
		 */
		public function getFrameFromName( name:String ):int
		{
			for each ( var frameLabel:FrameLabel in graphicsCache.frameLabels )
			{
				if ( frameLabel.name == name )
				{
					// flash indexes from 1 but I index from 0
					return frameLabel.frame - 1;
				}
			}

			return -1;
		}


		/**
		 * Gets the first found name of a frame
		 * @returns the name if found and empty string otherwise
		 */
		public function getNameOfFrame( frame:uint ):String
		{
			for each ( var label:FrameLabel in graphicsCache.frameLabels )
			{
				// remember the flash indexes from 1 but I do from 0
				if ( label.frame - 1 == frame )
				{
					return label.name;
				}
			}

			return "";
		}

	}
}
