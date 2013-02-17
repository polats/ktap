//! This code is taken from http://ripeworks.com/tracing-as3-to-chrome/
//! 
//! Chrome Developer Logs for web debugging.

//! Modified to support tracing simultaneous with local debugger (not in browser)

package ph.savepoint.tantalus
{
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
//	import flash.events.UncaughtErrorEvent;
	import flash.external.ExternalInterface;
	
	
	/**
	 * Aims to have the contents of the trace function to be directed to 
	 * browser console logs for web debugging.
	 * 
	 * @author Kristian
	 */	
	public class Console extends Sprite
	{
		// flag to toggle the use of external interface function calls.
		private static var _isUseExternalInterface:Boolean = true;
		
		private static var _allowInstantiation:Boolean = true;
		private static var _instance:Console;
		
		
		/**
		 * Constructor
		 */		
		public function Console():void
		{
			if(_allowInstantiation)
			{
				super();
			}
		}
		
		
		private function initialize():void
		{
			if(!_allowInstantiation)
				return;
			
			_instance = new Console();
			_allowInstantiation = false;
			
			_isUseExternalInterface = true;
			
			if(loaderInfo.hasOwnProperty("uncaughtErrorEvents"))
			{
//				loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler, false, 0, true);
			}
		}
		
		
		/**
		 * An alternative to the native trace command.
		 * 
		 * @param arguments - elements that need to be traced/printed out on console.
		 */		
		public static function log(... arguments):void
		{
			Console.localtrace(arguments);
		}
		
		
		/**
		 * An alternative to native trace command, displaying the content as a warning on browser consoles.
		 * 
		 * @param arguments - elements that need to be traced/printed out on console.
		 */		
		public static function warn(... arguments):void
		{
			Console.localtrace(arguments, "warn");
		}
		
		
		/**
		 * An alternative to native trace command, displaying the content as an error on browser consoles.
		 * 
		 * @param arguments - elements that need to be traced/printed out on console.
		 */		
		public static function error(... arguments):void
		{
			Console.localtrace(arguments, "error");
		}
		
		
		private static function localtrace(args:Object,type:String = "log"):void
		{
			for(var i:String in args)
			{
				if( !args[i] is String)
					args[i] = args[i].toString();
				
				trace(args[i]);
				
				try
				{
					if(_isUseExternalInterface)
					{
						ExternalInterface.call("console."+type,args[i]);
					}
					
					if( type == "log") 
					{	
						localtrace(args[i]);
					}
				}
				catch(e:Error)
				{  }
				
			}
		}
		
		
//		private static function uncaughtErrorHandler(e:UncaughtErrorEvent):void
//		{
//			if( e.error is Error)
//			{
//				var stack:String = Error(e.error).getStackTrace();
//				Console.error(Error(e.error).message + ((stack!=null)? "\n"+stack : ""));
//			}
//			else if( e.error is ErrorEvent)
//			{
//				Console.error(ErrorEvent(e.error).text);
//			}
//			else
//			{
//				Console.error(e.error.toString());
//			}
//		}

		
		public static function get isUseExternalInterface():Boolean
		{
			return _isUseExternalInterface;
		}

		
		public static function set isUseExternalInterface(value:Boolean):void
		{
			_isUseExternalInterface = value;
		}
	}
}