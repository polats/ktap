package ph.savepoint.tantalus
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	

	/**
	 * Provides keyboard input detection/events for keyboard and mouse.
	 * 
	 * @author Kristian
	 */	
	public class CInputManager extends EventDispatcher
	{

		/** flag to determine if class was instantiated. */
		private static var _bIsInitialized:Boolean = false;
		
		
		/**
		 * An array of boolean values indicating the state of the keyboard 
		 * as well as the mouse for input processing.
		 **/
		private static var _arrKBState:Array = new Array();
		private static var _arrKBKeyPressed:Array = new Array();
		
		
		/** Boolean flags to determine mouse states */
		private static var _isMouseDown:Boolean;
		private static var _isMouseMoving:Boolean;
		
		/** Mouse Coordinates */
		private static var _mousePt:Point;
		private static var _prevMousePt:Point;
		private static var _mouseDt:Point;
		
		/** Helper variable to store current mouse position. */
		private static var _mouseMovePt:Point;


		
		/**
		 * Assigns initial values for input tracking variables.
		 * 
		 */		
		public static function initialize():void {

			_isMouseDown = false;
			_isMouseMoving = false;
			
			_mousePt = new Point(0, 0);
			_prevMousePt = new Point(0, 0);
			_mouseDt = new Point(0, 0);
			_mouseMovePt = new Point(0, 0);
			
			//! should only initialize once, to prevent reassigning event listeners
			if(_bIsInitialized)
				return; 
			
			//attach the CInputManager to the stage
			CGlobals.getStage().addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			CGlobals.getStage().addEventListener(KeyboardEvent.KEY_UP,   handleKeyUp);
			CGlobals.getStage().addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			CGlobals.getStage().addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			CGlobals.getStage().addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			CGlobals.getStage().addEventListener(Event.MOUSE_LEAVE, handleMouseLeave);
			
			_bIsInitialized = true;
		}
		
		
		/**
		 * Checked if the specified keyCode is pressed.
		 * 
		 * @param keyCode - the numeric equivalent of the key to be checked.
		 * @return - True if the key has been pressed. False otherwise.
		 */		
        public static function isKeyPressed(keyCode:int):Boolean
        {
			if (_arrKBState[keyCode])
			{
				_arrKBState[keyCode] = false;
				return true;
			}
			
            return false;
        }
		
		
		/**
		 * Checks if the specified key is continuously being held down by the user.
		 * 
		 * @param keyCode - the numeric equivalent of the key to be checked.
		 * @return - True if the key has been pressed. False otherwise.
		 */		
		public static function isKeyHeldDown(keyCode:int):Boolean
        {	
            return _arrKBKeyPressed[keyCode];
        }
		
		
		private static function handleKeyDown(event:KeyboardEvent):void
        {
            if (_arrKBState[event.keyCode] || _arrKBKeyPressed[event.keyCode])
                return;

            _arrKBState[event.keyCode] = true;
			_arrKBKeyPressed[event.keyCode] = true;
			
			//trace("Key Down!");
        }
		
		
		private static function handleKeyUp(event:KeyboardEvent):void
        {
            _arrKBState[event.keyCode] = false;
			_arrKBKeyPressed[event.keyCode] = false;
			
			//trace("Key Up!");
        }
		
		
		private static function handleMouseLeave(event:Event):void
		{
			//trace("CInputManager MOUSE LEAVE");
			_isMouseDown = false;
			_isMouseMoving = false;
		}
		
		
		private static function handleMouseUp(event:MouseEvent):void
		{
			//trace("CInputManager Mouse Up.");
			_isMouseDown = false;
			_isMouseMoving = false;
		}
		
		
		private static function handleMouseDown(event:MouseEvent):void
		{
			//trace("CInputManager Mouse Down.");
			_isMouseDown = true;
			
			var target:* = event.target;
			mouseMovePt.x = target.mouseX;
			mouseMovePt.y = target.mouseY;
			
			_mousePt = target.localToGlobal(mouseMovePt);
		}
		
		
		private static function handleMouseMove(event:MouseEvent):void
		{
			//trace("CInputManager Mouse Move.");
			_isMouseMoving = true;
			
			_prevMousePt.x = _mousePt.x;
			_prevMousePt.y = _mousePt.y;
			
			var target:* = event.target;
			//var location:Point = new Point(target.mouseX, target.mouseY);
			mouseMovePt.x = target.mouseX;
			mouseMovePt.y = target.mouseY;
			
			_mousePt = target.localToGlobal(mouseMovePt);
			
			_mouseDt.x = _mousePt.x - _prevMousePt.x;
			_mouseDt.y = _mousePt.y - _prevMousePt.y;
		}

		
		public static function get isMouseDown():Boolean
		{
			return _isMouseDown;
		}

		
		public static function get isMouseMoving():Boolean
		{
			return _isMouseMoving;
		}

		
		public static function get mousePt():Point
		{
			return _mousePt;
		}

		
		public static function get prevMousePt():Point
		{
			return _prevMousePt;
		}

		
		public static function get mouseDt():Point
		{
			return _mouseDt;
		}

		
		public static function get mouseMovePt():Point
		{
			return _mouseMovePt;
		}
	}
}