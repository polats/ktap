package KTAP.layers
{
	import KTAP.Constants;
	import KTAP.math.MathFunctions;
	import KTAP.objects.Dancer;
	import KTAP.objects.Player;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import org.osflash.signals.Signal;
	
	import ph.savepoint.tantalus.CMathFunctions;
	import ph.savepoint.tantalus.CTimer;

	public class LayerDancers
	{
		private static const MAX_POOL_OBJECT_COUNT:uint = 65;
		
		//! create pool of dancers
		private var _arrPoolDancers:Array;
		private var _arrActiveDancers:Array;
		
		private var _singleDancerSpawnTimer:CTimer;
		
		private var _assetSpr:Sprite;
		
		private var _officialFemaleDancerMC:MovieClip;
		
		private var _signalPlayerHit:Signal;
		
		public function LayerDancers()
		{
			_assetSpr = new Sprite();
			_signalPlayerHit = new Signal();
			
			_officialFemaleDancerMC = new Asset_FemaleDancerMC();
			_officialFemaleDancerMC.gotoAndStop( 1 );
			
			_singleDancerSpawnTimer = new CTimer( 100 );
			_singleDancerSpawnTimer.maxTimeMs = CMathFunctions.RandomFromRange( Constants.MIN_TIME_SINGLE_DANCER_SPAWN_MS, Constants.MAX_TIME_SINGLE_DANCER_SPAWN_MS );
			createPoolDancers();
		}
		
		private function createPoolDancers():void
		{
			_arrPoolDancers = new Array();
			_arrActiveDancers = new Array();
			
			var i:uint = 0;
			var nMax:uint = MAX_POOL_OBJECT_COUNT;
			var tmpItem:Dancer;
			var randType:uint;
			
			for( i = 0; i < nMax; i++ )
			{
				randType = MathFunctions.RandomFromRange( 0, 1 );
				
				tmpItem = new Dancer( randType );
				tmpItem.signalOnRecycle.add( onDancerRecycle );
				tmpItem.signalOnAttach.add( onDancerAttach );
				
				_arrPoolDancers.push( tmpItem );
				tmpItem.assetMC.gotoAndStop( 1 );
				_assetSpr.addChild( tmpItem.assetMC );
			}
		}
		
		public function resetDancers():void
		{
			var i:uint = 0;
			var nMax:uint = _arrActiveDancers.length;
			var tmpDancer:Dancer;
			
			for( i = 0; i < nMax; i++ )
			{
				tmpDancer = _arrActiveDancers.splice( 0, 1 )[ 0 ] as Dancer;
				_arrPoolDancers.push( tmpDancer );
			}
			
			i = 0;
			nMax = _arrPoolDancers.length;
			
			for( i = 0; i < nMax; i++ )
			{
				tmpDancer = _arrPoolDancers[ i ];
				
				tmpDancer.reset();
				_assetSpr.addChild( tmpDancer.assetMC );
			}
			
			_officialFemaleDancerMC.gotoAndStop( 1 );
		}
		
		public function startDancing():void
		{
//			var i:uint = 0;
//			var nMax:uint = _arrPoolDancers.length;
//			var tmpDancer:Dancer;
//			
//			for( i = 0; i < nMax; i++ )
//			{
//				tmpDancer = _arrPoolDancers[ i ];
//				tmpDancer.assetMC.gotoAndPlay( 1 );
//			}
			
			_officialFemaleDancerMC.gotoAndPlay( 1 );
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
				tmpItem.assetMC.gotoAndPlay( _officialFemaleDancerMC.currentFrame );
			}
		}
		
		public function spawnMobOnRandomPosition( p_count:uint = 1 ):void
		{
			var i:uint = 0;
			var nMax:uint = p_count;
			var tmpItem:Dancer;
			var randIdx:uint = 0;
			
			for( i = 0; i < nMax; i++ )
			{
				tmpItem = _arrPoolDancers.pop();
				
				if( tmpItem == null )
				{
					trace( "[Error] Dancer Pool Empty!" );
					continue;
				}
				
				randIdx = MathFunctions.RandomFromRange( 1, 12 ) -1;
				tmpItem.randomizeDancerPosition( randIdx % 12 );
				
				_arrActiveDancers.push( tmpItem );
				tmpItem.startMobbing();
				tmpItem.assetMC.gotoAndPlay( _officialFemaleDancerMC.currentFrame );
			}
		}
		
		public function spawnStandingDancer( p_count:uint = 1 ):void
		{
			var i:uint = 0;
			var nMax:uint = p_count;
			var tmpItem:Dancer;
			var randIdx:uint = 0;
			
			for( i = 0; i < nMax; i++ )
			{
				tmpItem = _arrPoolDancers.pop();
				
				if( tmpItem == null )
				{
					trace( "[Error] Dancer Pool Empty!" );
					continue;
				}
				
//				randIdx = MathFunctions.RandomFromRange( 2, 3 ) -1;
				tmpItem.randomizeStandingDancerPosition();
				
				_arrActiveDancers.push( tmpItem );
				tmpItem.startDancing();
				tmpItem.assetMC.gotoAndPlay( _officialFemaleDancerMC.currentFrame );
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
		
		public function updateSingleDancerSpawnTimer():void
		{
			_singleDancerSpawnTimer.updateTimer();
			if( _singleDancerSpawnTimer.bHasElapsed )
			{
				var nRandCount:Number = CMathFunctions.RandomFromRange( 1, 3 );
				
				spawnStandingDancer( nRandCount );
				
				//! we randomize the max time to wait for the next spawn
				_singleDancerSpawnTimer.maxTimeMs = CMathFunctions.RandomFromRange( Constants.MIN_TIME_SINGLE_DANCER_SPAWN_MS, Constants.MAX_TIME_SINGLE_DANCER_SPAWN_MS );
				_singleDancerSpawnTimer.resetTimer();
			}
		}
		
		public function hitTestPlayer( p_player:Player ):void
		{
			var i:int = 0;
			var nMax:int = _arrActiveDancers.length;
			var tmpDancer:Dancer;
			
			for( i = 0; i < nMax; i++ )
			{
				tmpDancer = _arrActiveDancers[ i ];
				
				if( tmpDancer == null || tmpDancer.state == Dancer.STATE_ATTACHED )
					continue;
				
				if( p_player.hitAreaBackMC.hitTestObject( tmpDancer.hitAreaMC )
					|| p_player.hitAreaFrontMC.hitTestObject( tmpDancer.hitAreaMC ) )
				{
					trace( "Player Hit!" );
					
					tmpDancer.attachToPlayer( p_player );
					p_player.reduceEaseSpeed();
					
					_signalPlayerHit.dispatch();
				}
			}
		}
		
		public function shoveAttachedDancers():void
		{
			var i:int = 0;
			var nMax:int = _arrActiveDancers.length;
			var tmpDancer:Dancer;
			var newPosPt:Point;
			
			for( i = 0; i < nMax; i++ )
			{
				tmpDancer = _arrActiveDancers[ i ];
				
				if( tmpDancer.state == Dancer.STATE_ATTACHED )
				{
					newPosPt = tmpDancer.assetMC.localToGlobal( new Point( tmpDancer.assetMC.x, tmpDancer.assetMC.y ) );
					
					_assetSpr.addChild( tmpDancer.assetMC );
					tmpDancer.assetMC.scaleX = Dancer.DANCING_SCALE;
					tmpDancer.assetMC.scaleY = Dancer.DANCING_SCALE;
					tmpDancer.assetMC.x = newPosPt.x;
					tmpDancer.assetMC.y = newPosPt.y;
					
					tmpDancer.moveAway();
				}
			}
		}
		
		private function onDancerRecycle( p_dancer:Dancer ):void
		{
			var tmpIdx:int = _arrActiveDancers.indexOf( p_dancer );
			if( tmpIdx >= 0 )
				_arrActiveDancers.splice( tmpIdx, 1 );
			
			_arrPoolDancers.push( p_dancer );
		}
		
		private function onDancerAttach( p_dancer:Dancer ):void
		{
//			var tmpIdx:int = _arrActiveDancers.indexOf( p_dancer );
//			if( tmpIdx >= 0 )
//				_arrActiveDancers.splice( tmpIdx, 1 );
//
		}
		
		public function get assetSpr():Sprite
		{
			return _assetSpr;
		}

		public function get signalPlayerHit():Signal
		{
			return _signalPlayerHit;
		}

	}
}