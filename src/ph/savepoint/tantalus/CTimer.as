package ph.savepoint.tantalus
{
	public class CTimer
	{
		public var timeElapsedMs:Number;
		public var maxTimeMs:Number;
		
		public var bHasElapsed:Boolean;
		
		public function CTimer(_maxTimeMs:Number)
		{
			maxTimeMs = _maxTimeMs;
			timeElapsedMs = 0;
		
			bHasElapsed = false;
		}
		
		
		public function updateTimer():void
		{
			timeElapsedMs += CTimeManager.timeDeltaMs;	
			
			if(timeElapsedMs >= maxTimeMs)
			{
				bHasElapsed = true;
			}
		}
		
		
		public function resetTimer():void
		{
			timeElapsedMs = 0;
			bHasElapsed = false;
		}
		
		
		public function getTimeRemaining():Number
		{
			return maxTimeMs - timeElapsedMs;
		}
		
		/**
		 * Converts seconds to minutes and seconds
		 * @param number Number of seconds
		 * @return String of minutes and seconds (00:00)
		 */
//		public function convertTime( number:Number ):String {
//			number = Math.abs( number );
//			var val:Array = new Array( 5 );
//			val[ 0 ] = Math.floor( number / 86400 / 7 ); //weeks
//			val[ 1 ] = Math.floor( number / 86400 % 7 );//days
//			val[ 2 ] = Math.floor( number / 3600 % 24 );//hours
//			val[ 3 ] = Math.floor( number / 60 % 60 );//mins
//			val[ 4 ] = Math.floor( number % 60 );//secs
//			var stopage:Boolean = false;
//			var cutIndex:Number  = -1;
//			for(var i:Number = 0; i < val.length; i++ ) {
//				if( val[ i ] < 10 )
//					val[ i ] = "0" + val[ i ];
//				if( val[ i ] == "00" && i < ( val.length - 2 ) && !stopage ) {
//					cutIndex = i;
//				} else {
//					stopage = true;
//				}
//			}
//			val.splice( 0, cutIndex + 1 );
//			return val.join( ":" );
//		}


		
		
		
		public function convertTimeLeftToClockFormat():String
		{
			var nTime:Number = getTimeRemaining();
			nTime = nTime / 1000;
			
			var nHours:Number = Math.floor( nTime / 3600 % 24 );//hours;
			var nMins:Number = Math.floor( nTime / 60 % 60 );//mins;
			var nSecs:Number = Math.floor( nTime % 60 );//secs;
			
			var strTime:String;
			
			
			//! uncomment if double-digit minutes should be in use
//			if(nHours < 10)
//			{
//				strTime = strTime + "0" + nHours + ":";
//			}
//			else
//			{
//				strTime = strTime + nHours + ":";
//			}
			
			
//			if(nMins < 10)
//			{
//				strTime = strTime + "0" + nMins + ":";
//			}
//			else
//			{
//				strTime = strTime + nMins + ":";
//			}
			
			strTime = strTime + nMins + ":";
			
			if(nSecs < 10)
			{
				strTime = strTime + "0" + nSecs;
			}
			else
			{
				strTime = strTime + nSecs;
			}
			
			return strTime;
		}
		
		public function convertTimeElapsedToClockFormat():String
		{
			var nTime:Number = timeElapsedMs;
			nTime = nTime / 1000;
			
			var nHours:Number = Math.floor( nTime / 3600 % 24 );//hours;
			var nMins:Number = Math.floor( nTime / 60 % 60 );//mins;
			var nSecs:Number = Math.floor( nTime % 60 );//secs;
			
			var strTime:String;
			
			
			//! uncomment if double-digit minutes should be in use
			//			if(nHours < 10)
			//			{
			//				strTime = strTime + "0" + nHours + ":";
			//			}
			//			else
			//			{
			//				strTime = strTime + nHours + ":";
			//			}
			
			
			//			if(nMins < 10)
			//			{
			//				strTime = strTime + "0" + nMins + ":";
			//			}
			//			else
			//			{
			//				strTime = strTime + nMins + ":";
			//			}
			
			strTime = strTime + nMins + ":";
			
			if(nSecs < 10)
			{
				strTime = strTime + "0" + nSecs;
			}
			else
			{
				strTime = strTime + nSecs;
			}
			
			return strTime;
		}
	}
}