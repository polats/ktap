package ph.savepoint.tantalus
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import ph.savepoint.tantalus.CTimeManager;

	//import flash.utils.getTimer;
	
	public class CVect2D
	{
		//public var startPt:Point;
		private var endPt:Point;
		
		private var _parent:DisplayObject;
		
		
		private var vX:Number;
		private var vY:Number;
			
		private var length:Number;
		private var angleRad:Number;
		private var angleDeg:Number;
		
		
		private var deltaPt:Point;
		
		private var rDeltaPt:Point;
		private var lDeltaPt:Point;
		
		//public var prevTime:Number = 0;
		
		private var radius:Number = 0;
		private var bounciness:Number = 0.99;
		private var friction:Number = 0.99;
		
		
		
		public function CVect2D(parent:DisplayObject)
		{
			//startPt = new Point(0, 0);
			
			_parent = parent;
			endPt = new Point(0, 0);
		
			vX = endPt.x - _parent.x;
			vY = endPt.y - _parent.y;
			
			length = 0;
			
			angleRad = 0;
			angleDeg = 0;
			
			deltaPt = new Point(0, 0);
			
			rDeltaPt = new Point(0, 0);
			lDeltaPt = new Point(0, 0);
			
			radius = 0;
			
			bounciness = 1;
			friction = 0.99;
			
			
			//prevTime = getTimer();
		}
		
		
		public function setInitialVelocity(angleRad:Number, nLength:Number):void
		{
			vX = nLength * Math.cos(angleRad);
			vY = nLength * Math.sin(angleRad);
		}
		
		
		private function updateSpeed():void
		{
			//v.vx = v.p1.x-v.p0.x;
			//v.vy = v.p1.y-v.p0.y;
			
			vX = endPt.x - _parent.x;
			vY = endPt.y - _parent.y;
		}
		
		
		private function calculateLength():void
		{
			//v.len=Math.sqrt(v.vx*v.vx+v.vy*v.vy);
			length = Math.sqrt((vX * vX) + (vY * vY));
		}
		
		
		private function normalize():void
		{
			//v.dx=v.vx/v.len;
			//v.dy=v.vy/v.len;
			
			//deltaPt.x = vX / length;
			//deltaPt.y = vY / length;
			
			//normalized unti-sized components
			if (length > 0) {
				
				if (vX == 0)
				{
					deltaPt.x = 0;
				}
				else
				{
					deltaPt.x = vX / length;
				}
				
				if (vY == 0)
				{
					deltaPt.y = 0;
				}
				else
				{
					deltaPt.y = vY / length;
				}
				
			} else {
				deltaPt.x = 0;
				deltaPt.y = 0;
			}
			
			//v.rx = -v.vy;
			//v.ry = v.vx; 
			//v.lx = v.vy;
			//v.ly = -v.vx; 
			
			/*rDeltaPt.x = -vY;
			rDeltaPt.y = vX;
			lDeltaPt.x = vY;
			lDeltaPt.y = -vX;*/
			
			
			/*//right hand normal
			v.rx = -v.dy;
			v.ry = v.dx;
			//left hand normal
			v.lx = v.dy;
			v.ly = -v.dx;*/
			
			rDeltaPt.x = -deltaPt.y;
			rDeltaPt.y = deltaPt.x;
			lDeltaPt.x = deltaPt.y;
			lDeltaPt.y = -deltaPt.x;
		}
		
		/**
		 * Updates the Vector by calculating the next position of the parent
		 **/
		public function updateVector():void
		{
			//var thisTime=getTimer();
			//var time=(thisTime-v.lastTime)/100;
			
			/*var thisTime=getTimer();
			var time=(thisTime-v.lastTime)/100;
			v.p1={};
			v.p1.x=v.p0.x+v.vx*time;
			v.p1.y=v.p0.y+v.vy*time;
			v.lastTime=thisTime;*/
			
			//var thisTime:Number = getTimer();
			//var time:Number = (thisTime - prevTime)/100;
			
			var time:Number = CTimeManager.timeDeltaMs /100;
			
			endPt.x = _parent.x + (vX * time);
			endPt.y = _parent.y + (vY * time);
			
			// get length
			//calculateLength();
			
			// get normals
			//normalize();
			
			//prevTime = thisTime;
			
			//startPt = endPt;
			_parent.x = endPt.x;
			_parent.y = endPt.y;
		}
		
		
		private function updateVectorIntersection():void
		{
			endPt.x = _parent.x + vX;
			endPt.y = _parent.y + vY;
			
			// get length
			calculateLength();
			
			// get normals
			normalize();
		}
	}
}