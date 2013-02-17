package ph.savepoint.tantalus
{
	import flash.geom.Point;
	
	
	/**
	 * Convenience functions for common Math Functions
	 **/
	public class CMathFunctions
	{		
		
		/**
		 * This method accepts two Point objects and returns
		 * the angle between them in radians.
		 * 
		 * @param point1 - The 1st point needed for calculation
		 * @param point2 - The 2nd point needed for calculation
		 * @return - the angle in degrees from point1 to point2
		 */		
		public static function FindAngle(point1:Point, point2:Point):Number
		{
			var dx:Number = point2.x - point1.x;
			var dy:Number = point2.y - point1.y;
			
			return (Math.atan2(dy,dx)) * 180 / Math.PI;
		}
		

		/**
		 * Calculates the distance between two points
		 * 
		 * @param point1 - 1st point needed for calculation
		 * @param point2 - 2nd point needed for calculaion
		 * @return - the distance between the two points
		 */		
		public static function FindDistance(point1:Point, point2:Point):Number
		{
			var distance:Number;
			distance = Math.sqrt(( point1.x - point2.x ) * ( point1.x - point2.x ) + ( point1.y - point2.y ) * ( point1.y - point2.y ) );
		
			return distance;
		}
		
		
		/**
		 * Converts a radian value to its equivalent in Degrees
		 * 
		 * @param radians - the value to be converted
		 * @return - the equivalent degree value
		 */		
		public static function RadiansToDegrees(radians:Number):Number
		{
			return radians * 180 / Math.PI;
		}
		
		
		/**
		 * Converts a Degree value to its equivalent in Radians
		 * 
		 * @param degrees - the value to be converted
		 * @return - the equivalent radian value
		 */		
		public static function DegreesToRadians(degrees:Number):Number
		{
			return degrees * Math.PI / 180;
		}
		
		
		/**
		 * Generates a random integer value inclusive of the lowest and highest number specified.
		 * 
		 * @param nLow - the lowest value that can be generated
		 * @param nHigh - the highest value that can be generated.
		 * @return - a value between nLow and nHigh inclusive.
		 */		
		public static function RandomFromRange(nLow:Number, nHigh:Number):Number
		{
			return Math.floor(Math.random()*( 1 + nHigh - nLow)) + nLow;
		}
		
		
		public static function GetMidpoint( p_pointA:Point, p_pointB:Point ):Point
		{
			return new Point( ( p_pointA.x + p_pointB.x ) / 2, ( p_pointA.y, p_pointB.y ) / 2 );
		}
		
		
		/**
		 * Calculates the angle in between two points that serves as a chord of the circle.
		 * 
		 * @param p_pointA - one of the points of the chord
		 * @param p_pointB - the other point of the chord
		 * @param p_centerPt - the Central Point of the Circle.
		 * @returns angle between Point A, Center Point and Point B in Degrees.
		 */
		public static function GetAngleBetweenCircleChord( p_pointA:Point, p_pointB:Point, p_centerPt:Point ):Number
		{

			//! get modpoint
			var midPoint:Point = GetMidpoint( p_pointA, p_pointB );
			var hypotenuse:Number = Point.distance( p_pointA, p_pointB );
			var opposite:Number = Point.distance( p_pointA, midPoint );
			
			var result:Number = Math.asin( opposite / hypotenuse );
			result = Math.round( CMathFunctions.RadiansToDegrees( result ) * 1000 ) / 1000;
			result = result * 2;
			return result;
		}
		
		
		public static function RotatePointAroundFixedPoint( p_pointA:Point, p_fixedPt:Point, p_DegAngle:Number ):Point
		{
			var radians:Number = DegreesToRadians( p_DegAngle );
			var newX:Number = (Math.cos( radians ) * ( p_pointA.x - p_fixedPt.x ) - Math.sin( radians ) * ( p_pointA.y - p_fixedPt.y )) + p_fixedPt.x;
			var newY:Number = (Math.sin( radians ) * ( p_pointA.x - p_fixedPt.x ) - Math.cos( radians ) * ( p_pointA.y - p_fixedPt.y )) + p_fixedPt.y;
			
			return new Point( newX, newY );
		}
		
		
		public static function AddLeadingZero( p_num:Number):String 
		{
			if( p_num < 10 ) {
				return "0" + p_num;
			}
			return p_num.toString();
		}
		
	}
}