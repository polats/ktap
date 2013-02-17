package ph.savepoint.tantalus
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	/**
	 * Compilation of all graphics (Bitmap/BitmapData) related functions.
	 * 
	 * @author Kristian
	 */	
	public class CGraphics2D
	{
		
		/**
		 * Calculates the average pixel colors from a given pixel data.
		 *  
		 * @param source - the BitmapData object to be averaged.
		 * @return - a uint value of the average color representation from the BitmapData.
		 */		
		public static function averageColour( source:BitmapData ):uint
		{
			var red:Number = 0;
			var green:Number = 0;
			var blue:Number = 0;
			
			var count:Number = 0;
			var pixel:Number;
			
			for (var x:int = 0; x < source.width; x++)
			{
				for (var y:int = 0; y < source.height; y++)
				{
					pixel = source.getPixel(x, y);
					
					red += pixel >> 16 & 0xFF;
					green += pixel >> 8 & 0xFF;
					blue += pixel & 0xFF;
					
					count++
				}
			}
			
			red /= count;
			green /= count;
			blue /= count;
			
			return red << 16 | green << 8 | blue;
		}
		
		
		public static function scaleBitmapData( bitmapData:BitmapData, scale:Number ):BitmapData 
		{
			scale = Math.abs(scale);
			var width:int = ( bitmapData.width * scale) || 1;
			var height:int = ( bitmapData.height * scale) || 1;
			var transparent:Boolean = true;
			var result:BitmapData = new BitmapData(width, height, transparent);
			var matrix:Matrix = new Matrix();
			matrix.scale( scale, scale );
			result.draw( bitmapData, matrix) ;
			return result;
		}
	}
}