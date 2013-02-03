package KTAP.objects
{
	import KTAP.Constants;
	import KTAP.Globals;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Strong;
	
	import flash.display.MovieClip;
	
	import flashx.textLayout.operations.MoveChildrenOperation;

	public class Dancer
	{
		public static const TYPE_FEMALE:uint = 0;
		public static const TYPE_MALE:uint = 1;
		public static const TYPE_DONNA:uint = 2;
		
		private var _assetMC:MovieClip;
		
		//! body parts
		private var _mcBody:MovieClip;
		private var _mcHead:MovieClip;
		private var _mcRightArmUp:MovieClip;
		private var _mcRightArmDown:MovieClip;
		private var _mcLeftArmUp:MovieClip;
		private var _mcLeftArmDown:MovieClip;
		private var _mcRightLegUp:MovieClip;
		private var _mcRightLegDown:MovieClip;
		private var _mcLeftLegUp:MovieClip;
		private var _mcLeftLegDown:MovieClip;
		
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
			
//			_mcBody = _assetMC["mc_body"];
//			_mcHead = _assetMC["mc_head"];
//			_mcRightArmUp = _assetMC["mc_rightArmUp"];
//			_mcRightArmDown = _assetMC["mc_rightArmDown"];
//			_mcLeftArmUp = _assetMC["mc_leftArmUp"];
//			_mcLeftArmDown = _assetMC["mc_leftArmDown"];
//			_mcRightLegUp = _assetMC["mc_rightLegUp"];
//			_mcRightLegDown = _assetMC["mc_rightLegDown"];
//			_mcLeftLegUp = _assetMC["mc_leftLegUp"];
//			_mcLeftLegDown = _assetMC["mc_leftLegDown"];
//			
//			
//			switch( p_type )
//			{
//				case TYPE_FEMALE:
//					_mcBody.gotoAndStop( 1 );
//					_mcHead.gotoAndStop( 1 );
//					_mcRightArmUp.gotoAndStop( 1 );
//					_mcRightArmDown.gotoAndStop( 1 );
//					_mcLeftArmUp.gotoAndStop( 1 );
//					_mcLeftArmDown.gotoAndStop( 1 );
//					_mcRightLegUp.gotoAndStop( 1 );
//					_mcRightLegDown.gotoAndStop( 1 );
//					_mcLeftLegUp.gotoAndStop( 1 );
//					_mcLeftLegDown.gotoAndStop( 1 );
//					break;
//				
//				case TYPE_MALE:
//					_mcBody.gotoAndStop( 3 );
//					_mcHead.gotoAndStop( 3 );
//					_mcRightArmUp.gotoAndStop( 3 );
//					_mcRightArmDown.gotoAndStop( 3 );
//					_mcLeftArmUp.gotoAndStop( 3 );
//					_mcLeftArmDown.gotoAndStop( 3 );
//					_mcRightLegUp.gotoAndStop( 3 );
//					_mcRightLegDown.gotoAndStop( 3 );
//					_mcLeftLegUp.gotoAndStop( 3 );
//					_mcLeftLegDown.gotoAndStop( 3 );
//					break;
//				
//				case TYPE_DONNA:
//					_mcBody.gotoAndStop( 2 );
//					_mcHead.gotoAndStop( 2 );
//					_mcRightArmUp.gotoAndStop( 2 );
//					_mcRightArmDown.gotoAndStop( 2 );
//					_mcLeftArmUp.gotoAndStop( 2 );
//					_mcLeftArmDown.gotoAndStop( 2 );
//					_mcRightLegUp.gotoAndStop( 2 );
//					_mcRightLegDown.gotoAndStop( 2 );
//					_mcLeftLegUp.gotoAndStop( 2 );
//					_mcLeftLegDown.gotoAndStop( 2 );
//					break;
//			}
		}

		public function get assetMC():MovieClip
		{
			return _assetMC;
		}
		
		
		public function startMobbing( p_proximity:uint = 0):void
		{
			_assetMC.visible = true;
			
//			var nTargetPosX:Number = _assetMC.x + ( Globals.heroPosPt.x - _assetMC.x ) * 0.7;
//			var nTargetPosY:Number = _assetMC.y + ( Globals.heroPosPt.y - _assetMC.y ) * 0.7;
			
			
			var nOffset:Number = 0;
			switch( p_proximity )
			{
				case 0: nOffset = 0.9; break;
				case 1: nOffset = 0.8; break;
				case 2: nOffset = 0.7; break;
				case 3: nOffset = 0.6; break;
			}
			
			
			//! set target to center screen first for demo
			var nTargetPosX:Number = _assetMC.x + ( Constants.SCREEN_WIDTH * 0.5 - _assetMC.x ) * nOffset;
			var nTargetPosY:Number = _assetMC.y + ( Constants.SCREEN_HEIGHT * 0.5 - _assetMC.y - 50 ) * nOffset;
			
			nTargetPosX = Math.max( nTargetPosX, 50 );
			nTargetPosY = Math.max( nTargetPosY, 50 );
			
			TweenMax.to( _assetMC, 2, { x:nTargetPosX, y:nTargetPosY, ease:Strong.easeOut, onComplete:onDanceMoveComplete } );
		}
		
		
//		public function startMobbingPart2():void
//		{
//			_assetMC.visible = true;
//			
//			var nTargetPosX:Number = _assetMC.x + ( Globals.heroPosPt.x - _assetMC.x ) * 0.7;
//			var nTargetPosY:Number = _assetMC.y + ( Globals.heroPosPt.y - _assetMC.y ) * 0.7;
//			
//			nTargetPosX = Math.max( nTargetPosX, 50 );
//			nTargetPosY = Math.max( nTargetPosY, 50 );
//			
//			TweenMax.to( _assetMC, 2, { x:nTargetPosX, y:nTargetPosY, ease:Strong.easeOut, onComplete:onDanceMoveComplete } );
//		}
		
		
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