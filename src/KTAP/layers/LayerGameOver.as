package KTAP.layers
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Strong;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;

	public class LayerGameOver
	{
		private var _assetMC:MovieClip;
		
		private var _btnTryAgain:MovieClip;
		private var _filterMC:MovieClip;
		private var _gameOverMC:MovieClip;
		
		private var _tlEnterAnim:TimelineMax;
		
		private var _signalTryAgainClicked:Signal;
		
		public function LayerGameOver()
		{
			_assetMC = new Asset_GameOverMC();
			
			_btnTryAgain = _assetMC["btnTryAgain"];
			_filterMC = _assetMC["mc_filter"];
			_gameOverMC = _assetMC["mc_gameOver"];
			
			_btnTryAgain.buttonMode = true;
			_btnTryAgain.mouseChildren = false;
			_btnTryAgain.addEventListener( MouseEvent.CLICK, onBtnClick );
			
			_signalTryAgainClicked = new Signal();
			
			createAnimations();
		}
		
		private function createAnimations():void
		{
			_tlEnterAnim = new TimelineMax( { onComplete:onEnterAnimComplete } );
			
			_tlEnterAnim.append( TweenMax.from( _filterMC, 0.7, { alpha:0, ease:Strong.easeOut } ) );
			_tlEnterAnim.append( TweenMax.from( _gameOverMC, 0.5, { y:_gameOverMC.y - 50, alpha:0, ease:Strong.easeOut } ) );
			_tlEnterAnim.append( TweenMax.from( _btnTryAgain, 0.4, { y:_btnTryAgain.y + 20, alpha:0, ease:Expo.easeOut } ), 0.3 );
			_tlEnterAnim.stop();
			
//			_tlEnterAnim.timeScale = 0.5;
		}
		
		public function playEnterAnimation():void
		{
			_assetMC.mouseChildren = false;
			_assetMC.mouseEnabled = false;
			
			_tlEnterAnim.restart();
		}
		
		private function onEnterAnimComplete():void
		{
			_assetMC.mouseChildren = true;
			_assetMC.mouseEnabled = true;
		}
		
		private function onBtnClick( p_event:MouseEvent ):void
		{
			_signalTryAgainClicked.dispatch();
		}

		public function get assetMC():MovieClip
		{
			return _assetMC;
		}

		public function get signalTryAgainClicked():Signal
		{
			return _signalTryAgainClicked;
		}
	}
}