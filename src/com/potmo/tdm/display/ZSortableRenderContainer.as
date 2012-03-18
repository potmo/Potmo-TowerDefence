package com.potmo.tdm.display
{
	import com.potmo.p2d.renderer.Renderable;
	import com.potmo.p2d.renderer.Renderer;

	public class ZSortableRenderContainer implements Renderable
	{

		private var _children:Vector.<ZSortableRenderable>;
		private var _numChildren:uint = 0;


		public function ZSortableRenderContainer()
		{
			_children = new Vector.<ZSortableRenderable>();
			_numChildren = 0;
		}


		public function addChild( child:ZSortableRenderable ):void
		{
			_children.push( child );
			_numChildren++;
		}


		public function removeChild( child:ZSortableRenderable ):void
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


		public function sortDepth():void
		{
			_children.sort( depthSortFuncton );
		}


		private function depthSortFuncton( child1:ZSortableRenderable, child2:ZSortableRenderable ):int
		{
			if ( child1.getZDepth() < child2.getZDepth() )
			{
				return -1;
			}
			else if ( child1.getZDepth() > child2.getZDepth() )
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}

	}
}
