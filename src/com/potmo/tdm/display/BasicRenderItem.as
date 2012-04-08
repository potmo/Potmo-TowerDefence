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
		protected var regpointX:Number = 0.0;
		protected var regpointY:Number = 0.0;
		protected var alphaMultiplyer:Number = 1.0;
		protected var redMultiplyer:Number = 1.0;
		protected var greenMultiplyer:Number = 1.0;
		protected var blueMultiplyer:Number = 1.0;


		public function BasicRenderItem( graphicsSequence:SpriteAtlasSequence, regpointX:Number = 0.0, regpointY:Number = 0.0 )
		{
			this.graphicsSequence = graphicsSequence;
			this.currentFrame = graphicsSequence.getNthFrame( 0 );
			this.regpointX = regpointX;
			this.regpointY = regpointY;
		}


		public function render( renderer:Renderer ):void
		{
			renderer.draw( currentFrame, x - regpointX, y - regpointY, rotation, scaleX, scaleY, alphaMultiplyer, redMultiplyer, greenMultiplyer, blueMultiplyer );
		}


		public function containsPoint( x:Number, y:Number ):Boolean
		{
			var frameSize:Point = graphicsSequence.getSizeOfFrame( currentFrame );

			if ( x > this.x - regpointX && x < this.x - regpointX + frameSize.x )
			{
				if ( y > this.y - regpointY && y < this.y - regpointY + frameSize.y )
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

	}
}
