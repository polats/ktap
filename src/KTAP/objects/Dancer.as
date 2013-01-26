package KTAP.objects
{
	import KTAP.Globals;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Strong;
	
	import flash.display.MovieClip;

	public class Dancer
	{
		private var _assetMC:MovieClip;
		
		public function Dancer()
		{
			_assetMC = new Assets_DancerMC();
		}

		public function get assetMC():MovieClip
		{
			return _assetMC;
		}
		
		
		public function startMobbing():void
		{
			var nTargetPosX:Number = _assetMC.x + ( Globals.heroPosPt.x - _assetMC.x ) * 0.7;
			var nTargetPosY:Number = _assetMC.y + ( Globals.heroPosPt.y - _assetMC.y ) * 0.7;
			
			nTargetPosX = Math.max( nTargetPosX, 50 );
			nTargetPosY = Math.max( nTargetPosY, 50 );
			
			TweenMax.to( _assetMC, 2, { x:nTargetPosX, y:nTargetPosY, ease:Strong.easeOut, onComplete:onDanceMoveComplete } );
		}
		
		
		public function startMobbingPart2():void
		{
			var nTargetPosX:Number = _assetMC.x + ( Globals.heroPosPt.x - _assetMC.x ) * 0.7;
			var nTargetPosY:Number = _assetMC.y + ( Globals.heroPosPt.y - _assetMC.y ) * 0.7;
			
			nTargetPosX = Math.max( nTargetPosX, 50 );
			nTargetPosY = Math.max( nTargetPosY, 50 );
			
			TweenMax.to( _assetMC, 2, { x:nTargetPosX, y:nTargetPosY, ease:Strong.easeOut, onComplete:onDanceMoveComplete } );
		}
		
		
		public function onDanceMoveComplete():void
		{
			//! check if will still chase
			
			//! if yes
			//startMobbing();
			
			//! if no
			//startDancing
		}
	}
}