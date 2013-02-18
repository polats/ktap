package KTAP.layers
{
	import KTAP.objects.Collectible;
	
	import flash.display.Sprite;

	public class LayerCollectibles
	{
		private var _assetSpr:Sprite;
		
		private var _arrCollectibles:Array;
		private var _currIdx:uint;
		
		public function LayerCollectibles()
		{
			_assetSpr = new Sprite();
			_arrCollectibles = new Array();
			
			createCollectibles();
		}
		
		private function createCollectibles():void
		{
			var i:uint = 0;
			var nMax:uint = 5;
			var tmpItem:Collectible;
			
			for( i = 0; i < nMax; i++ )
			{
				tmpItem = new Collectible( i );
				_arrCollectibles.push( tmpItem );
			}
		}
		
		private function getNextCollectible():Collectible
		{
			var tmpItem:Collectible;
			var nOffset:uint = 0;
			var nMax:uint = _arrCollectibles.length;
			
			while( nOffset < nMax )
			{
				tmpItem = _arrCollectibles[ _currIdx ];
				
				if( tmpItem.state != Collectible.STATE_HIDDEN )
				{
					//! go to next collectible;
					_currIdx = _currIdx + 1;
					_currIdx = ( _currIdx % 5 );
					
					nOffset = nOffset + 1;
				}
				else
				{
					return tmpItem;
				}
			}
			
			return null;
		}

		public function get assetSpr():Sprite
		{
			return _assetSpr;
		}

	}
}