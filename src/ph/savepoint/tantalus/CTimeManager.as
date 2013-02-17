package ph.savepoint.tantalus
{
	import flash.utils.getTimer;
	
	public class CTimeManager
	{
		public static var timeDeltaMs:Number = 0;
		
		private static var prevTime:Number = 0;
		private static var currTime:Number = 0;
		
		public static function initialize():void
		{
			currTime = getTimer();
			prevTime = currTime;
		}
		
		public static function updateTime():void
		{
			currTime = getTimer();
			timeDeltaMs = currTime - prevTime;
			
			prevTime = currTime;
		}
		
		
		public static function manualTimeUpdate( p_timeDeltaMS:Number ):void
		{
			timeDeltaMs = p_timeDeltaMS;
		}

	}
}