package ph.savepoint.tantalus
{
	import flash.display.Sprite;
	import flash.display.Stage;
	

	/**
	 * Convenience class that holds direct access to the stage/document class. 
	 * @author Kristian
	 * 
	 */	
	public class CGlobals
	{
		/** 
		 * Reference to the document class.
		 * Advisable to be set upon initialization of Document Class 
		 **/
		private static var _docClass:Sprite = null;
		
		private static var _gameName:String = "MyGame";
		private static var _publisherName:String = "MyPublisher";
		private static var _encryptionKey:String = "0123456789abcdef";		
		
		
		/**
		 * Retrieves the stage wherein the document class is attached. 
		 * @return - the Stage reference.
		 * 
		 */		
		public static function getStage():Stage
		{
			if (!_docClass)
			{
				throw new Error("[CGLobals]: not instantiated.");
				return null;
			}
				
			return _docClass.stage;
		}
		

		
		public static function get docClass():Sprite
		{
			return _docClass;
		}

		
		public static function set docClass(value:Sprite):void
		{
			_docClass = value;
		}

		
		public static function get gameName():String
		{
			return _gameName;
		}

		
		public static function set gameName(value:String):void
		{
			_gameName = value;
		}

		
		public static function get publisherName():String
		{
			return _publisherName;
		}

		
		public static function set publisherName(value:String):void
		{
			_publisherName = value;
		}

		
		public static function get encryptionKey():String
		{
			return _encryptionKey;
		}

		
		public static function set encryptionKey(value:String):void
		{
			_encryptionKey = value;
		}
	}
}