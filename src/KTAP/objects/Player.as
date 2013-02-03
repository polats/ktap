package KTAP.objects
{
	import flash.display.MovieClip;

	public class Player
	{
		private var _assetMC:MovieClip;
		
		public function Player()
		{
			_assetMC = new Asset_DonnaDancerMC(); //Assets_PlayerMC();
			_assetMC.stop();
			
			_assetMC.scaleX = 0.5;
			_assetMC.scaleY = 0.5
		}
		
		
		public function get assetMC():MovieClip
		{
			return _assetMC;
		}

	}
}