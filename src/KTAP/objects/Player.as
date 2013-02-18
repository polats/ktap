package KTAP.objects
{
	import KTAP.Constants;
	import KTAP.Globals;
	
	import flash.display.MovieClip;
	
	import org.osflash.signals.Signal;

	public  class Player
	{	
		private var _speedReductionTick:Number;
		
		private var _assetMC:MovieClip;
		private var _hitAreaFrontMC:MovieClip;
		private var _hitAreaBackMC:MovieClip;
		
		private var _easeSpeed:Number;
		
		private var _signalNoMoreSpeed:Signal;
		
		public function Player()
		{
			_assetMC = new Asset_DonnaDancerMC(); //Assets_PlayerMC();
			_assetMC.stop();
			
			_assetMC.scaleX = 0.3;
			_assetMC.scaleY = 0.3;
			
			_hitAreaFrontMC = _assetMC["mc_hitAreaFront"];
			_hitAreaBackMC = _assetMC["mc_hitAreaBack"];
			
			_easeSpeed = Constants.DEFAULT_EASE_SPEED;
			_speedReductionTick = Globals.easeSpeed / Constants.MAX_STICKY_DANCERS;
			
			_signalNoMoreSpeed = new Signal();
		}
		
		public function update():void
		{
			assetMC.x += ( Globals.mousePosPt.x - assetMC.x ) * _easeSpeed;
			assetMC.y += ( Globals.mousePosPt.y - assetMC.y ) * _easeSpeed;
		}
		
		public function reduceEaseSpeed():void
		{
			if( _easeSpeed == 0 )
				return;
			
			_easeSpeed = _easeSpeed - _speedReductionTick;
			trace( "speed reduced!" );
			
			if( _easeSpeed < 0 )
			{
				_easeSpeed = 0;
				trace( "game over!" );
				_signalNoMoreSpeed.dispatch();
			}
		}
		
		public function resetEaseSpeed():void
		{
			_easeSpeed = Globals.easeSpeed;
		}
		
		public function getPercentSpeedReduced():Number
		{
			return ( _easeSpeed / Constants.DEFAULT_EASE_SPEED );
		}
		
		public function get assetMC():MovieClip
		{
			return _assetMC;
		}

		public function get signalNoMoreSpeed():Signal
		{
			return _signalNoMoreSpeed;
		}

		public function get hitAreaFrontMC():MovieClip
		{
			return _hitAreaFrontMC;
		}

		public function get hitAreaBackMC():MovieClip
		{
			return _hitAreaBackMC;
		}


	}
}