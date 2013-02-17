package KTAP.layers
{
	import KTAP.math.MathFunctions;
	import KTAP.objects.Dancer;
	import KTAP.objects.Player;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;

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
			var randType:uint;
			
			for( i = 0; i < nMax; i++ )
			{
				randType = MathFunctions.RandomFromRange( 0, 1 );
				
				tmpItem = new Dancer( randType );
				tmpItem.signalOnRecycle.add( onDancerRecycle );
				tmpItem.signalOnAttach.add( onDancerAttach );
				
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
		
		public function hitTestPlayer( p_player:Player ):void
		{
			var i:int = 0;
			var nMax:int = _arrActiveDancers.length;
			var tmpDancer:Dancer;
			
			for( i = 0; i < nMax; i++ )
			{
				tmpDancer = _arrActiveDancers[ i ];
				
				if( tmpDancer == null )
					continue;
				
				if( p_player.hitAreaMC.hitTestObject( tmpDancer.hitAreaMC) )
				{
					trace( "Player Hit!" );
					
					tmpDancer.attachToPlayer( p_player );
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
			var tmpIdx:int = _arrActiveDancers.indexOf( p_dancer );
			if( tmpIdx >= 0 )
				_arrActiveDancers.splice( tmpIdx, 1 );
		}
		
		public function get assetSpr():Sprite
		{
			return _assetSpr;
		}
	}
}