package com.potmo.tdm.display
{
	import com.potmo.p2d.renderer.Renderable;
	import com.potmo.p2d.renderer.Renderer;

	public class RenderContainer
	{
		private var _children:Vector.<Renderable>;
		private var _numChildren:uint = 0;


		public function RenderContainer()
		{
			_children = new Vector.<Renderable>();
			_numChildren = 0;
		}


		public function addChild( child:Renderable ):void
		{
			_children.push( child );
			_numChildren++;
		}


		public function removeChild( child:Renderable ):void
		{
			var index:int = _children.indexOf( child );
			_children.splice( index, 1 );
			_numChildren--;
		}


		public function render( renderer:Renderer ):void
		{
			for ( var i:uint = 0; i < _numChildren; i++ )
			{
				_children[ i ].render( renderer );
			}
		}

	}
}
