package com.potmo.tdm.display
{
	import com.potmo.p2d.renderer.Renderable;

	public interface ZSortableRenderable extends Renderable
	{
		function getZDepth():int;
	}
}
