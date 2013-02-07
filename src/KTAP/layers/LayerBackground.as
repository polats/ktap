package KTAP.layers
{
	import KTAP.Constants;
	
	import flash.display.MovieClip;

	public class LayerBackground
	{
		private var _assetMC:MovieClip;
		private var _bgMC:MovieClip;
		private var _nOrigPosY:Number;
		
		public function LayerBackground()
		{
			_assetMC = new Assets_BackgroundMC();
			_bgMC = _assetMC["mc_background"];
			_nOrigPosY = _bgMC.y;
		}
		
		public function update():void
		{
			_bgMC.y += Constants.SPEED_VALUE;
			
			if( _bgMC.y >= 0 )
			{
				_bgMC.y = _nOrigPosY + _bgMC.y;
			}
		}
		
		public function get assetMC():MovieClip
		{
			return _assetMC;
		}
	}
}