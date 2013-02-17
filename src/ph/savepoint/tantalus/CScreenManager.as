package ph.savepoint.tantalus
{	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**
	 * Takes care of switching and managing of the current active screen displayed.
	 * 
	 * @author Kristian
	 */	
	public class CScreenManager
	{
		private static const LAYER_SCREEN:uint = 0;
		private static const LAYER_VERSION:uint = 1;
		
		
		//! the singleton instance.
		//private static var _instance:CScreenManager;
		
		/** flag to determine if class was instantiated. */
		private static var _allowInstantiation:Boolean;
		
		/** the current screen that the screen manager is displaying */
		private static var _currentScreen:DisplayObject;
		

		
		//! Constructor.
		//! Should check if the class is instantiated.
		//! Throws an error if it tries to create another instance of the class.
//		public function CScreenManager()
//		{
//			if (!allowInstantiation) 
//			{
//				throw new Error("CScreenManager: Creating another instance of a singleton class.");
//			}
//			
//			//init();
//		}


		//! The main function to get the instance of the singleton class
//		public static function getInstance():CScreenManager {
//			if (instance == null) {
//				allowInstantiation = true;
//				instance = new CScreenManager();
//				allowInstantiation = false;
//			}
//			
//			return instance;
//		}
	   
	   
		/**
		 * Initializes the ScreenManager's variables, usually called upon 
		 * initalization of the Document Class 
		 * 
		 */		
		public static function initialize():void
		{
			//initialize the current screen.
			_currentScreen = null;
		}
		
		
		/**
		 * Replaces the current screen with a new screen to be displayed. 
		 * 
		 * @param newScreen - the new screen to be displayed.
		 */		
		public static function changeScreen(newScreen:Sprite):void
		{
			if(_currentScreen)
			{
				CGlobals.getStage().removeChild(_currentScreen);
			}
			
			_currentScreen = newScreen;
			CGlobals.getStage().addChildAt(_currentScreen, LAYER_SCREEN);
		}
		
		
		/**
		 * Adds a textual display of the current version/build number 
		 * at the upperleft of the screen for debugging purposes.
		 *  
		 * @param strVersion - the text to be displayed
		 */		
		public static function setVersionNumber(strVersion:String):void
		{
			if(CGlobals.getStage().numChildren < LAYER_VERSION)
				return; // There is no screen yet.
			
			/*if(CGlobals.getStage().getChildAt(LAYER_VERSION) != null)
			{
			CGlobals.getStage().removeChildAt(LAYER_VERSION);
			}*/
			
			var tmpLabel:TextField = new TextField();
			tmpLabel.text = strVersion;
			
			var tFormat:TextFormat = new TextFormat();
			tFormat.bold = true;
			tFormat.color = 0xFFFFFF;
			
			tmpLabel.setTextFormat(tFormat); 
			tmpLabel.mouseEnabled = false;
			
			CGlobals.getStage().addChildAt(tmpLabel, LAYER_VERSION);
		}
	}
}