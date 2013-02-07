package KTAP.objects
{
	import KTAP.Constants;
	import KTAP.Globals;
	import KTAP.math.MathFunctions;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Strong;
	
	import flash.display.MovieClip;
	
	import flashx.textLayout.operations.MoveChildrenOperation;
	
	import org.osflash.signals.Signal;

	public class Dancer
	{
		public static const STATE_HIDDEN:uint = 0;
		public static const STATE_MOBBING:uint = 1;
		public static const STATE_DANCING:uint = 2;
		
		public static const TYPE_FEMALE:uint = 0;
		public static const TYPE_MALE:uint = 1;
		public static const TYPE_DONNA:uint = 2;
		
		private var _state:uint = STATE_HIDDEN;
		
		private var _assetMC:MovieClip;

		private var _signalOnRecycle:Signal;
		
		public function Dancer( p_type:uint = TYPE_FEMALE )
		{
//			_assetMC = new Assets_DancerMC();
			if( p_type == TYPE_FEMALE )
			{
				_assetMC = new Asset_FemaleDancerMC();
			}
			else
			{
				_assetMC = new Asset_MaleDancerMC();
			}
			
			_assetMC.scaleX = 0.5;
			_assetMC.scaleY = 0.5;
			
			_assetMC.visible = false;
			
			_state = STATE_HIDDEN;
			
			_signalOnRecycle = new Signal();
		}
		
		public function startMobbing( p_proximity:uint = 0):void
		{
			_assetMC.visible = true;
			
			var nTargetPosX:Number = _assetMC.x + ( Globals.heroPosPt.x - _assetMC.x ) * 0.7;
			var nTargetPosY:Number = _assetMC.y + ( Globals.heroPosPt.y - _assetMC.y ) * 0.7;
			
			nTargetPosX = Math.max( nTargetPosX, 50 );
			nTargetPosY = Math.max( nTargetPosY, 50 );
			
			_assetMC.visible = true;
			_state = STATE_MOBBING;
			TweenMax.to( _assetMC, 2, { x:nTargetPosX, y:nTargetPosY, ease:Cubic.easeOut, onComplete:onMobMoveComplete } );
		}
		
		public function randomizeDancerPosition( p_corderIdx:int = -1 ):void
		{
			
			// 0  |  1 |  2 |  3  
			//    +--------+
			// 4  |        |   5
			//    |        |
			// 6  |        |   7
			//    +--------+   
			// 8  | 9 | 10 |  11 
			
			if( p_corderIdx < 0 )
			{
				p_corderIdx = MathFunctions.RandomFromRange( 1, 12 ) - 1;
			}
			
			
			var posX:Number;
			var posY:Number;
			
			var nHalfScreenWidth:Number = Constants.SCREEN_WIDTH * 0.5;
			var nHalfScreenHeight:Number = Constants.SCREEN_HEIGHT * 0.5;
			
			
			switch( p_corderIdx )
			{
				case 0: //! upper left
					posX = MathFunctions.RandomFromRange( nHalfScreenWidth * -1, 0 );
					posY = MathFunctions.RandomFromRange( nHalfScreenHeight * -1, 0 );	
					break;
				
				case 1: //! upper right
					posX = MathFunctions.RandomFromRange( 0, nHalfScreenWidth );
					posY = MathFunctions.RandomFromRange( nHalfScreenHeight * -1, 0 );
					break;
				
				case 2: //! lower left
					posX = MathFunctions.RandomFromRange( nHalfScreenWidth, Constants.SCREEN_WIDTH );
					posY = MathFunctions.RandomFromRange( nHalfScreenHeight * -1, 0 );
					break;
				
				case 3: //lower right
					posX = MathFunctions.RandomFromRange( Constants.SCREEN_WIDTH, Constants.SCREEN_WIDTH + nHalfScreenWidth );
					posY = MathFunctions.RandomFromRange( nHalfScreenHeight * -1, 0 );
					break;
				
				case 4:
					posX = MathFunctions.RandomFromRange( nHalfScreenWidth * -1, 0 );
					posY = MathFunctions.RandomFromRange( 0, nHalfScreenHeight );
					break;
				
				case 5:
					posX = MathFunctions.RandomFromRange( Constants.SCREEN_WIDTH, Constants.SCREEN_WIDTH + nHalfScreenWidth );
					posY = MathFunctions.RandomFromRange( 0, nHalfScreenHeight );
					break;
				
				case 6:
					posX = MathFunctions.RandomFromRange( nHalfScreenWidth * -1, 0 );
					posY = MathFunctions.RandomFromRange( nHalfScreenHeight, Constants.SCREEN_HEIGHT );
					break;
				
				case 7:
					posX = MathFunctions.RandomFromRange( Constants.SCREEN_WIDTH, Constants.SCREEN_WIDTH + nHalfScreenWidth );
					posY = MathFunctions.RandomFromRange( nHalfScreenHeight, Constants.SCREEN_HEIGHT );
					break;
				
				case 8:
					posX = MathFunctions.RandomFromRange( nHalfScreenWidth * -1, 0 );
					posY = MathFunctions.RandomFromRange( Constants.SCREEN_HEIGHT, Constants.SCREEN_HEIGHT + nHalfScreenHeight );
					break;
				
				case 9: //! upper right
					posX = MathFunctions.RandomFromRange( 0, nHalfScreenWidth );
					posY = MathFunctions.RandomFromRange( Constants.SCREEN_HEIGHT, Constants.SCREEN_HEIGHT + nHalfScreenHeight );
					break;
				
				case 10: //! lower left
					posX = MathFunctions.RandomFromRange( nHalfScreenWidth, Constants.SCREEN_WIDTH );
					posY = MathFunctions.RandomFromRange( Constants.SCREEN_HEIGHT, Constants.SCREEN_HEIGHT + nHalfScreenHeight );
					break;
				
				case 11: //lower right
					posX = MathFunctions.RandomFromRange( Constants.SCREEN_WIDTH, Constants.SCREEN_WIDTH + nHalfScreenWidth );
					posY = MathFunctions.RandomFromRange( Constants.SCREEN_HEIGHT, Constants.SCREEN_HEIGHT + nHalfScreenHeight );
					break;
				
			}
			
			assetMC.x = posX;
			assetMC.y = posY;
		}
		
		private function recycleMe():void
		{
			_state = STATE_HIDDEN;
			_assetMC.visible = false;
			_signalOnRecycle.dispatch( this );
		}
		
		public function update():void
		{
			_assetMC.y += Constants.SPEED_VALUE;
			
			if( _assetMC.y > Constants.SCREEN_HEIGHT + 30 )
			{
				recycleMe();
			}
		}
		
		
		private function onMobMoveComplete():void
		{
			_state = STATE_DANCING;
		}
		
		public function get assetMC():MovieClip
		{
			return _assetMC;
		}
		
		public function get state():uint
		{
			return _state;
		}

		public function get signalOnRecycle():Signal
		{
			return _signalOnRecycle;
		}

	}
}