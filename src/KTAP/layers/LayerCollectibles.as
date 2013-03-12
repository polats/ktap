package KTAP.layers
{
	import KTAP.objects.Collectible;
	import KTAP.objects.Player;
	
	import flash.display.Sprite;
	
	import org.osflash.signals.Signal;
	
	import ph.savepoint.tantalus.CTimer;

	public class LayerCollectibles
	{
		private var _assetSpr:Sprite;
		
		private var _arrCollectibles:Array;
		private var _currIdx:uint;
		
		private var _spawnTimer:CTimer;
		
		private var _signalLetterCollected:Signal;
		
		public function LayerCollectibles()
		{
			_assetSpr = new Sprite();
			_arrCollectibles = new Array();
			
			_spawnTimer = new CTimer( 8000 );
			_spawnTimer.resetTimer();
			
			_signalLetterCollected = new Signal();
			
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
				tmpItem.signalOnRecycle.add( onItemRecycle );
				
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
				
				//! go to next collectible;
				_currIdx = _currIdx + 1;
				_currIdx = ( _currIdx % 5 );
				
				if( tmpItem.state != Collectible.STATE_HIDDEN )
				{
					nOffset = nOffset + 1;
				}
				else
				{
					trace( "currIdx: " + _currIdx );
					return tmpItem;
				}
			}
			
			return null;
		}
		
		private function spawnCollectible():void
		{
			var tmpItem:Collectible = getNextCollectible();
			
			if( tmpItem == null )
				return;
			
			//! spawn the collectible above the screen.
			tmpItem.spawnOnTopOfScreen();
			_assetSpr.addChild( tmpItem.assetMC );
		}
		
		public function update():void
		{
			var i:uint = 0;
			var nMax:uint = _arrCollectibles.length;
			var tmpItem:Collectible;
			
			for( i = 0; i < nMax; i++ )
			{
				tmpItem = _arrCollectibles[ i ];
				tmpItem.update();
			}	
		}
		
		public function updateTimer():void
		{
			_spawnTimer.updateTimer();
			if( _spawnTimer.bHasElapsed )
			{
				//! spawn a letter
				spawnCollectible();
				_spawnTimer.resetTimer();
			}
		}
		
		public function hitTestPlayer( p_player:Player ):void
		{
			var i:int = 0;
			var nMax:int = _arrCollectibles.length;
			var tmpItem:Collectible;
			
			for( i = 0; i < nMax; i++ )
			{
				tmpItem = _arrCollectibles[ i ];
				
				if( tmpItem == null || tmpItem.state != Collectible.STATE_READY )
					continue;
				
				if( p_player.hitAreaBackMC.hitTestObject( tmpItem.assetMC )
					|| p_player.hitAreaFrontMC.hitTestObject( tmpItem.assetMC ) )
				{
					trace( "Letter Collected!" );
//					p_player.playAcquireAnimation();
					
					tmpItem.setAsCollected();
					if( _assetSpr.contains( tmpItem.assetMC ) )
						_assetSpr.removeChild( tmpItem.assetMC );
					
//					tmpItem.attachToPlayer( p_player );
					_signalLetterCollected.dispatch( tmpItem );
				}
			}
		}
		
		public function resetCollectibles():void
		{
			_currIdx = 0;
			
			var i:uint = 0;
			var nMax:uint = _arrCollectibles.length;
			var tmpItem:Collectible;
			
			for( i = 0; i < nMax; i++ )
			{
				tmpItem = _arrCollectibles[ i ];
				tmpItem.recycleMe();
			}
			
			_spawnTimer.resetTimer();
		}
		
		private function onItemRecycle( p_item:Collectible ):void
		{
			if( _assetSpr.contains( p_item.assetMC ) )
				_assetSpr.removeChild( p_item.assetMC );
		}

		public function get assetSpr():Sprite
		{
			return _assetSpr;
		}

		public function get signalLetterCollected():Signal
		{
			return _signalLetterCollected;
		}
	}
}