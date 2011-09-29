package com.potmo.tdm.visuals.starling
{
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public class SortingSprite extends Sprite
	{
		public function SortingSprite()
		{
			super();
		}


		public function sortChildren():void
		{
			this.mChildren.sort( zSortCompareFunction );

		}


		private final function zSortCompareFunction( a:DisplayObject, b:DisplayObject ):int
		{
			return ( a.y - b.y );
		}
	}
}
