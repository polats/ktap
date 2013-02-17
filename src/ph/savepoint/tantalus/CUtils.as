package ph.savepoint.tantalus
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class CUtils
	{

		
		public static function isValidEmail(p_email:String):Boolean {
			var emailExpression:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return emailExpression.test(p_email);
		}
		
		//! format 0xxx-xxxxxxxx
		public static function isValidPhone(p_phone:String):Boolean {
			var emailExpression:RegExp = /0\d{3}-\d{7}/;
			return emailExpression.test(p_phone);
		}
		
		
		public static function replaceAllOnString( str:String, fnd:String, rpl:String ):String
		{
			return str.split(fnd).join(rpl);
		}
		
		
		public static function zoomFromPoint( p_dispObj:DisplayObject, p_localPt:Point, p_scale:Number ):Rectangle
		{
			var tmpRect:Rectangle = new Rectangle( p_dispObj.x, p_dispObj.y, p_dispObj.width, p_dispObj.height );
			
			//! we get the x coord of the point.
			var tmpNewWidth:Number = p_localPt.x * p_scale;
			var offsetX:Number = tmpNewWidth - p_localPt.x;
			
			var tmpNewHeight:Number = p_localPt.y * p_scale;
			var offsetY:Number = tmpNewHeight - p_localPt.y;
		
			tmpRect.x = tmpRect.x - offsetX;
			tmpRect.y = tmpRect.y - offsetY;
			tmpRect.width = tmpNewWidth;
			tmpRect.height = tmpNewHeight;
			
			return tmpRect;
		}
		
	}
}