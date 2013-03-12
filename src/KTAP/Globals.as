package KTAP
{
	import KTAP.objects.Player;
	
	import flash.geom.Point;
	
	import ph.savepoint.tantalus.CTimer;

	public class Globals
	{
		private static var _mousePosPt:Point = new Point();
		private static var _heroPosPt:Point = new Point();
		
		public static var easeSpeed:Number;
		public static var scrollSpeed:Number;
		
		public static var gameTimer:CTimer;
		
		public static var nCollectedLetters:int = 0;
		
		public static function initialize():void
		{
			easeSpeed = Constants.DEFAULT_EASE_SPEED;
			scrollSpeed = Constants.SPEED_VALUE;
			
			if( gameTimer == null )
				gameTimer = new CTimer( 0 );
			
			gameTimer.resetTimer();
			
			nCollectedLetters = 0;
		}
		
		public static function updateScrollSpeed( p_player:Player ):void
		{
			scrollSpeed = Constants.SPEED_VALUE * p_player.getPercentSpeedReduced();
		}
		
		public static function updateMousePosPt( p_posX:Number, p_posY:Number ):void
		{
			_mousePosPt.x = p_posX;
			_mousePosPt.y = p_posY;
		}
		
		public static function updateHeroPosPt( p_posX:Number, p_posY:Number ):void
		{
			_heroPosPt.x = p_posX;
			_heroPosPt.y = p_posY;
		}
		
		public static function get mousePosPt():Point
		{
			return _mousePosPt;
		}
	}
}