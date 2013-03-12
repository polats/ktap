package KTAP.layers
{
	import KTAP.Constants;
	import KTAP.Globals;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class LayerIngameUI
	{
		private var _assetMC:MovieClip;
		
		private var _txtDistance:TextField;
		
		private var _nDistance:Number;
		
		public function LayerIngameUI()
		{
			_assetMC = new Assets_IngameUI_MC();
			
			_txtDistance = _assetMC["txtDistance"];
		}
		
		public function reset():void
		{
			_txtDistance.text = "0 meters";
		}
		
		public function update():void
		{
			_nDistance = ( Globals.gameTimer.timeElapsedMs / Constants.MS_PER_METER );
			_txtDistance.text = "" + _nDistance.toFixed( 3 ) + " meters";
		}
		
		public function hide():void
		{
			_assetMC.visible = false;
		}
		
		public function show():void
		{
			_assetMC.visible = true;
		}

		public function get assetMC():MovieClip
		{
			return _assetMC;
		}

	}
}