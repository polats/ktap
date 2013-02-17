package KTAP.math
{
	public class MathFunctions
	{
		/**
		 * Generates a random integer value inclusive of the lowest and highest number specified.
		 * 
		 * @param nLow - the lowest value that can be generated
		 * @param nHigh - the highest value that can be generated.
		 * @return - a value between nLow and nHigh inclusive.
		 */		
		public static function RandomFromRange(nLow:Number, nHigh:Number):Number
		{
			return Math.floor( Math.random()*( 1 + nHigh - nLow)) + nLow;
		}
	}
}