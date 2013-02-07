package KTAP.layers
{
	import KTAP.objects.Dancer;
	
	import flash.display.Sprite;

	public class LayerDancers
	{
		private static const MAX_POOL_OBJECT_COUNT:uint = 40;
		
		//! create pool of dancers
		private var _arrPoolDancers:Array;
		private var _arrActiveDancers:Array;
		
		private var _assetSpr:Sprite;
		
		public function LayerDancers()
		{
			_assetSpr = new Sprite();
			
			createPoolDancers();
		}
		
		private function createPoolDancers():void
		{
			_arrPoolDancers = new Array();
			_arrActiveDancers = new Array();
			
			var i:uint = 0;
			var nMax:uint = MAX_POOL_OBJECT_COUNT;
			var tmpItem:Dancer;
			
			for( i = 0; i < nMax; i++ )
			{
				tmpItem = new Dancer();
				tmpItem.signalOnRecycle.add( onDancerRecycle );
				
				_arrPoolDancers.push( tmpItem );
				_assetSpr.addChild( tmpItem.assetMC );
			}
		}
		
		public function spawnMobs( p_count:uint = 1 ):void
		{
			var i:uint = 0;
			var nMax:uint = p_count;
			var tmpItem:Dancer;
			
			for( i = 0; i < nMax; i++ )
			{
				tmpItem = _arrPoolDancers.pop();
				
				if( tmpItem == null )
				{
					trace( "[Error] Dancer Pool Empty!" );
					continue;
				}
				
				tmpItem.randomizeDancerPosition( i % 12 );
				
				_arrActiveDancers.push( tmpItem );
				tmpItem.startMobbing();
			}
		}
		
		public function update():void
		{
			for each ( var tmpDancer:Dancer in _arrActiveDancers )
			{
				if( tmpDancer.state == Dancer.STATE_DANCING )
					tmpDancer.update();
			}
		}
		
		private function onDancerRecycle( p_dancer:Dancer ):void
		{
			var tmpIdx:int = _arrActiveDancers.indexOf( p_dancer );
			if( tmpIdx >= 0 )
				_arrActiveDancers.splice( tmpIdx, 1 );
			
			_arrPoolDancers.push( p_dancer );
		}
		
		public function get assetSpr():Sprite
		{
			return _assetSpr;
		}
	}
}