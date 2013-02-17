package KTAP.objects
{
	import KTAP.Constants;
	import KTAP.Globals;
	import KTAP.math.MathFunctions;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Strong;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import flashx.textLayout.operations.MoveChildrenOperation;
	
	import org.osflash.signals.Signal;

	public class Dancer
	{
		private static const DANCING_SCALE:Number = 0.3;
		
		public static const STATE_HIDDEN:uint = 0;
		public static const STATE_MOBBING:uint = 1;
		public static const STATE_DANCING:uint = 2;
		public static const STATE_ATTACHED:uint = 3;
		
		public static const TYPE_FEMALE:uint = 0;
		public static const TYPE_MALE:uint = 1;
		public static const TYPE_DONNA:uint = 2;
		
		private var _state:uint = STATE_HIDDEN;
		
		private var _assetMC:MovieClip;
		private var _hitAreaMC:MovieClip;

		private var _signalOnRecycle:Signal;
		private var _signalOnAttach:Signal;
		
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
			
			_hitAreaMC = _assetMC["mc_hitArea"];
			
			_assetMC.scaleX = DANCING_SCALE;
			_assetMC.scaleY = DANCING_SCALE;
			
			_assetMC.visible = false;
			
			_state = STATE_HIDDEN;
			
			_signalOnRecycle = new Signal();
			_signalOnAttach = new Signal();
		}
		
		public function reset():void
		{
			_state = STATE_HIDDEN;
			
			_assetMC.scaleX = DANCING_SCALE;
			_assetMC.scaleY = DANCING_SCALE;
			_assetMC.visible = false;
			_assetMC.gotoAndStop( 1 );
			_assetMC.x = 0;
			_assetMC.y = 0;
		}
		
		public function startMobbing( p_proximity:uint = 0):void
		{
			_assetMC.visible = true;
			
			var nTargetPosX:Number = _assetMC.x + ( Globals.mousePosPt.x - _assetMC.x ) * 0.7;
			var nTargetPosY:Number = _assetMC.y + ( Globals.mousePosPt.y - _assetMC.y ) * 0.7;
			
			nTargetPosX = Math.max( nTargetPosX, 50 );
			nTargetPosY = Math.max( nTargetPosY, 50 );
			
			_assetMC.visible = true;
			_state = STATE_MOBBING;
			//Cubic.easeOut
			TweenMax.to( _assetMC, 1, { x:nTargetPosX, y:nTargetPosY, ease:Cubic.easeOut, onComplete:onMobMoveComplete } );
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
		
		public function attachToPlayer( p_player:Player ):void
		{
			_state = STATE_ATTACHED;
			
			TweenMax.killTweensOf( _assetMC );
			
			_assetMC.scaleX = 1;
			_assetMC.scaleY = 1;
			
			var localPt:Point = p_player.assetMC.parent.globalToLocal( new Point( _assetMC.x, _assetMC.y ) );
			_assetMC.x = localPt.x - p_player.assetMC.x; //localPt.x;
			_assetMC.y = localPt.y - p_player.assetMC.y; //localPt.y;
			
			
			if( _assetMC.y <= 90 )
				p_player.hitAreaBackMC.addChild( _assetMC );
			else
				p_player.hitAreaFrontMC.addChild( _assetMC );
			
			_assetMC.x += 30;
			_assetMC.y += 46;
			
//			_assetMC.stop();
			_signalOnAttach.dispatch( this );
		}
		
		public function update():void
		{
			if( _state != STATE_DANCING )
				return;
			
			_assetMC.y += Globals.scrollSpeed;
			
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
		
		public function set state( p_value:uint ):void
		{
			_state = p_value;
		}

		public function get signalOnRecycle():Signal
		{
			return _signalOnRecycle;
		}

		public function get signalOnAttach():Signal
		{
			return _signalOnAttach;
		}

		public function set signalOnAttach(value:Signal):void
		{
			_signalOnAttach = value;
		}

		public function get hitAreaMC():MovieClip
		{
			return _hitAreaMC;
		}

	}
}