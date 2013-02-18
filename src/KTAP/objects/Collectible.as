package KTAP.objects
{
	import flash.display.MovieClip;

	public class Collectible
	{
		public static const STATE_READY:uint = 0;
		public static const STATE_COLLECTED:uint = 1;
		public static const STATE_HIDDEN:uint = 2;
		
		private var _assetMC:MovieClip;
		private var _state:uint;
		private var _type:uint = 0;
		
		public function Collectible( p_type:uint = 0 )
		{
			switch( p_type )
			{
				default: _assetMC = new Collectable_01_MC(); break;
			}
			
			_type = p_type;
			_state = STATE_HIDDEN;
		}
		
		public function reset():void
		{
			_state = STATE_HIDDEN;
		}

		public function get assetMC():MovieClip
		{
			return _assetMC;
		}

		public function get state():uint
		{
			return _state;
		}


	}
}