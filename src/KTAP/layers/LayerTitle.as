package KTAP.layers
{
	import KTAP.Constants;
	
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	import com.greensock.plugins.AutoAlphaPlugin;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;

	public class LayerTitle
	{
		private var _assetMC:MovieClip;
		private var _filterMC:MovieClip;
		private var _titleMC:MovieClip;
		private var _startMC:MovieClip;
		
		private var _tlEnterAnim:TimelineMax;
		private var _tlFadeOutFilter:TimelineMax;
		
		private var _signalOnEnterAnimComplete:Signal;
		private var _signalOnStartClick:Signal;
		
		public function LayerTitle()
		{
			_assetMC = new Assets_TitleMC();
			_filterMC = _assetMC["mc_filter"];
			_titleMC = _assetMC["mc_title"];
			_startMC = _assetMC["mc_start"];
			
			_startMC.buttonMode = true;
			_startMC.addEventListener( MouseEvent.CLICK, onBtnClick );
			
			_signalOnEnterAnimComplete = new Signal();
			_signalOnStartClick = new Signal();
			createAnimations();
		}
		
		private function createAnimations():void
		{
			_tlEnterAnim = new TimelineMax( { onComplete:onEnterAnimComplete } );
			
			_tlEnterAnim.append( TweenMax.to( _titleMC, 1, { scaleX:0.8, scaleY:0.8, ease:Strong.easeIn } ) );
			_tlEnterAnim.append( TweenMax.to( _startMC, 0.5, { alpha:0, ease:Strong.easeOut } ), -1 );
			_tlEnterAnim.append( TweenMax.to( _titleMC, 3, {  alpha:0, scaleX:3.0, scaleY:3.0, ease:Strong.easeOut } ) );
			_tlEnterAnim.append( TweenMax.to( _filterMC, 1, { autoAlpha:1, ease:Strong.easeOut } ), -1 );
			_tlEnterAnim.stop();
			
			_tlFadeOutFilter = new TimelineMax( { onComplete:onFadeOutFilterComplete } );
			_tlFadeOutFilter.append( TweenMax.fromTo( _filterMC, 2, { autoAlpha:1 }, { autoAlpha:0, ease:Strong.easeOut } ) );
			_tlFadeOutFilter.append( TweenMax.from( _startMC, 1, { y:Constants.SCREEN_HEIGHT + 100, ease:Strong.easeOut } ), -2 );
			_tlFadeOutFilter.stop();
		}
		
		public function fadeOutFilter():void
		{
			_startMC.mouseChildren = false;
			_startMC.mouseEnabled = false;
			_tlFadeOutFilter.restart();
		}
		
		public function playEnterAnimation():void
		{
			_startMC.mouseChildren = false;
			_startMC.mouseEnabled = false;
			_tlEnterAnim.restart();
		}
		
		public function resetLayer():void
		{
			_filterMC.alpha = 0;
			_titleMC.scaleX = 1;
			_titleMC.scaleY = 1;
			_titleMC.alpha = 1;
			_startMC.alpha = 1;
		}
		
		private function onEnterAnimComplete():void
		{
			_signalOnEnterAnimComplete.dispatch();
		}
		
		private function onFadeOutFilterComplete():void
		{
			_startMC.mouseChildren = true;
			_startMC.mouseEnabled = true;
		}
		
		private function onBtnClick( p_event:MouseEvent ):void
		{
			_signalOnStartClick.dispatch();
		}

		public function get assetMC():MovieClip
		{
			return _assetMC;
		}

		public function get signalOnEnterAnimComplete():Signal
		{
			return _signalOnEnterAnimComplete;
		}

		public function get signalOnStartClick():Signal
		{
			return _signalOnStartClick;
		}


	}
}