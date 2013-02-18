package KTAP.layers
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.VideoLoader;
	
	import flash.display.Sprite;
	
	import org.osflash.signals.Signal;

	public class LayerMovie
	{
		private var _assetSpr:Sprite;
		private var _videoLoader:VideoLoader;
		
		private var _signalOnVideoPlayComplete:Signal;
		
		public function LayerMovie()
		{
			_assetSpr = new Sprite();
			_assetSpr.mouseChildren = false;
			_assetSpr.mouseEnabled = false;
			
			_videoLoader = LoaderMax.getLoader( "introVideo" );
			_assetSpr.addChild( _videoLoader.content );
			
			_signalOnVideoPlayComplete = new Signal();
			
			_videoLoader.addEventListener( VideoLoader.VIDEO_COMPLETE, onVideoPlayComplete );
		}
		
		public function playVideo():void
		{
			_assetSpr.alpha = 1;
			
			_videoLoader.volume = 0.5;
			_videoLoader.playProgress = 0.01;
			_videoLoader.playVideo();
		}
		
		public function playFadeOut():void
		{
			TweenMax.to( _assetSpr, 1, { alpha:0, ease:Strong.easeOut, onComplete:onFadeOutComplete } ) ;
		}
		
		private function onVideoPlayComplete( p_event:LoaderEvent ):void
		{
			trace( "VIDEO PLAY COMPLETE" );
			_signalOnVideoPlayComplete.dispatch();
			
			playFadeOut();
		}
		
		private function onFadeOutComplete():void
		{
			if( _assetSpr.parent != null )
				_assetSpr.parent.removeChild( _assetSpr );
			
			_assetSpr.alpha = 1;
		}

		public function get assetSpr():Sprite
		{
			return _assetSpr;
		}

		public function get signalOnVideoPlayComplete():Signal
		{
			return _signalOnVideoPlayComplete;
		}
	}
}