package com.potmo.tdm.display
{
	import com.potmo.p2d.atlas.animation.SpriteAtlasSequence;
	import com.potmo.p2d.renderer.Renderable;
	import com.potmo.p2d.renderer.Renderer;

	import flash.geom.Point;

	public class BasicRenderItem implements Renderable
	{
		protected var x:Number = 0;
		protected var y:Number = 0;
		protected var currentFrame:uint = 0;
		protected var graphicsSequence:SpriteAtlasSequence;
		protected var rotation:Number = 0;
		protected var scaleX:Number = 1.0;
		protected var scaleY:Number = 1.0;
		protected var alphaMultiplyer:Number = 1.0;
		protected var redMultiplyer:Number = 1.0;
		protected var greenMultiplyer:Number = 1.0;
		protected var blueMultiplyer:Number = 1.0;


		public function BasicRenderItem( graphicsSequence:SpriteAtlasSequence )
		{
			this.graphicsSequence = graphicsSequence;
			this.currentFrame = graphicsSequence.getNthFrame( 0 );
		}


		public function render( renderer:Renderer ):void
		{
			renderer.draw( currentFrame, x, y, rotation, scaleX, scaleY, alphaMultiplyer, redMultiplyer, greenMultiplyer, blueMultiplyer );
		}


		public function containsPoint( x:Number, y:Number ):Boolean
		{
			var regpoint:Point = graphicsSequence.getRegpointOfFrame( currentFrame );
			var frameSize:Point = graphicsSequence.getSizeOfFrame( currentFrame );

			if ( x > this.x - regpoint.x && x < this.x - regpoint.x + frameSize.x )
			{
				if ( y > this.y - regpoint.y && y < this.y - regpoint.y + frameSize.y )
				{
					return true;
				}
			}

			return false;
		}


		public function getWidth():Number
		{
			var frameSize:Point = graphicsSequence.getSizeOfFrame( currentFrame );
			return frameSize.x;
		}


		public function getHeight():Number
		{
			var frameSize:Point = graphicsSequence.getSizeOfFrame( currentFrame );
			return frameSize.y;
		}


		public function getX():Number
		{
			return x;
		}


		public function getY():Number
		{
			return y;
		}


		public function setX( value:Number ):void
		{
			this.x = value;
		}


		public function setY( value:Number ):void
		{
			this.y = value;
		}


		public function setAlpha( value:Number ):void
		{
			alphaMultiplyer = value;
		}


		public function getAlpha():Number
		{
			return alphaMultiplyer;
		}

	}
}
