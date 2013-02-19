package KTAP.objects
{
	import KTAP.Constants;
	import KTAP.Globals;
	import KTAP.math.MathFunctions;
	
	import flash.display.MovieClip;
	
	import org.osflash.signals.Signal;

	public class Collectible
	{
		public static const STATE_READY:uint = 0;
		public static const STATE_COLLECTED:uint = 1;
		public static const STATE_HIDDEN:uint = 2;
		
		private var _assetMC:MovieClip;
		private var _state:uint;
		private var _type:uint = 0;
		
		private var _signalOnRecycle:Signal;
		
		public function Collectible( p_type:uint = 0 )
		{
			switch( p_type )
			{
				case 0: _assetMC = new Collectable_01_MC(); break;
				case 1: _assetMC = new Collectable_02_MC(); break;
				case 2: _assetMC = new Collectable_03_MC(); break;
				case 3: _assetMC = new Collectable_04_MC(); break;
				case 4: _assetMC = new Collectable_05_MC(); break;
				
				default: _assetMC = new Collectable_01_MC(); break;
			}
			
			_type = p_type;
			_state = STATE_HIDDEN;
			_assetMC.visible = false;
			
			_signalOnRecycle = new Signal();
		}
		
		public function spawnOnTopOfScreen():void
		{
			var posX:Number;
			var posY:Number;
			
			var nHalfScreenWidth:Number = Constants.SCREEN_WIDTH * 0.5;
			var nHalfScreenHeight:Number = Constants.SCREEN_HEIGHT * 0.5;
			
			posX = MathFunctions.RandomFromRange( 50, Constants.SCREEN_WIDTH - 50 );
			posY = MathFunctions.RandomFromRange( nHalfScreenHeight * -1, -50 );
			
			assetMC.x = posX;
			assetMC.y = posY;
			
			
			_state = STATE_READY;
			_assetMC.visible = true;
		}
		
		public function update():void
		{
			if( _state == STATE_READY )
			{
				_assetMC.y += Globals.scrollSpeed;
				
				if( _assetMC.y > Constants.SCREEN_HEIGHT + 30 )
				{
					recycleMe();
				}
			}
		}
		
		public function recycleMe():void
		{
			_state = STATE_HIDDEN;
			_assetMC.visible = false;
			
			_signalOnRecycle.dispatch( this );
		}
		
		public function setAsCollected():void
		{
			_state = STATE_COLLECTED;
			_assetMC.visible = false;
		}
		
//		public function reset():void
//		{
//			recycleMe();
//		}

		public function get assetMC():MovieClip
		{
			return _assetMC;
		}

		public function get state():uint
		{
			return _state;
		}

		public function get signalOnRecycle():Signal
		{
			return _signalOnRecycle;
		}


	}
}