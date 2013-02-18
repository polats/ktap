package
{
	import KTAP.Constants;
	
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.VideoLoader;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	import ph.savepoint.tantalus.CMathFunctions;
	
	public class GamePreloader extends MovieClip
	{
		private var _assetMC:MovieClip;
		private var _maskMC:MovieClip;
		private var _txtInfo:TextField;
		
		private var _loader:LoaderMax;
		
		private var _nTotalPercent:Number;
		private var _nMaskStartPosX:Number;
		
		public function GamePreloader()
		{
			super();
			
			this.graphics.beginFill( 0x000000, 1 );
			this.graphics.drawRect( 0, 0, Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT );
			this.graphics.endFill();
			
			_nTotalPercent = 0;
			
			_assetMC = new Asset_PreloaderMC();
			this.addChild( _assetMC );
			_assetMC.y = _assetMC.y - 25;
			_assetMC.x = _assetMC.x + 3;
			
			_maskMC = _assetMC["mc_mask"];
			_txtInfo = _assetMC["txtInfo"];
			
			_txtInfo.mouseEnabled = false;
			
			_txtInfo.text = "0%";
			_nMaskStartPosX = _maskMC.x;
			
			//! move mask to the left
			_maskMC.x = _maskMC.x - _maskMC.width;
			
			//! add listeners
			loaderInfo.addEventListener( ProgressEvent.PROGRESS, onLoaderInfoProgress );
		}
		
		private function createrLoaderItems():void
		{
			_loader = new LoaderMax( { name:"itemsQueue", onProgress:onLoadItemsProgress, onComplete:onLoadItemsComplete } );
			_loader.append( new VideoLoader( "swf_data/videos/intro.mp4", { name:"introVideo", container:null, scaleMode:"proportionalInside", bgColor:0x000000, autoPlay:false, width:Constants.SCREEN_WIDTH, height:Constants.SCREEN_HEIGHT, volume:1, estimatedBytes:2500 } ) );
			_loader.load();
		}
		
		private function onLoaderInfoProgress( p_event:ProgressEvent ):void
		{
			var percent:Number = p_event.bytesLoaded / p_event.bytesTotal;
			
			_nTotalPercent = Math.floor( percent * 100 ) - 50 ;
			_txtInfo.text = "Loading: " + CMathFunctions.AddLeadingZero( _nTotalPercent ) + "%";
			
			_maskMC.x = _nMaskStartPosX - _maskMC.width + ( _maskMC.width * ( _nTotalPercent / 100 ) );
			
			if ( root.loaderInfo.bytesLoaded >= root.loaderInfo.bytesTotal ) 
			{
				loaderInfo.removeEventListener( ProgressEvent.PROGRESS, onLoaderInfoProgress );
				createrLoaderItems();
			}
			else 
			{
				trace( "Loading: " + percent );	
			}
		}
		
		private function onLoadItemsProgress( p_event:LoaderEvent ):void
		{
			trace( "LoadItems Progress: " + p_event.target.progress );
			var percent:Number =p_event.target.progress;
			
			_nTotalPercent = 50 + ( Math.floor( percent * 100 ) * 0.5 );
			_maskMC.x = _nMaskStartPosX - _maskMC.width + ( _maskMC.width * ( _nTotalPercent / 100 ) );
		}
		
		private function onLoadItemsComplete( p_event:LoaderEvent ):void
		{
			trace( "LoadItems Complete!" );
			
			startup();
		}
		
		private function startup():void
		{			
			var mainClass:Class = getDefinitionByName("Main") as Class;
			stage.addChild(new mainClass() as Sprite);
			stage.removeChild(this);
		}
	}
}