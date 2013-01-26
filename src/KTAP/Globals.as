package KTAP
{
	import flash.geom.Point;

	public class Globals
	{
		private static var _heroPosPt:Point = new Point();
		
		public static function updateHeroPosPt( p_posX:Number, p_posY:Number ):void
		{
			_heroPosPt.x = p_posX;
			_heroPosPt.y = p_posY;
		}
		
		public static function get heroPosPt():Point
		{
			return _heroPosPt;
		}
	}
}