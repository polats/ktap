package
{
	import com.greensock.loading.LoaderMax;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class GamePreloader extends MovieClip
	{
		private var _assetMC:MovieClip;
		private var _maskMC:MovieClip;
		private var _txtInfo:TextField;
		
		private var _loader:LoaderMax;
		
		public function GamePreloader()
		{
			super();
			
			_assetMC = new Asset_PreloaderMC();
			this.addChild( _assetMC );
			
			_maskMC = _assetMC["mc_mask"];
			_txtInfo = _assetMC["txtInfo"];
			
			this.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		private function createrLoaderItems():void
		{
			
		}
		
		private function onAddedToStage( p_event:Event ):void
		{
			
		}
	}
}