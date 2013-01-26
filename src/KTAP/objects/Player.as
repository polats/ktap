package KTAP.objects
{
	import flash.display.MovieClip;

	public class Player
	{
		private var _assetMC:MovieClip;
		
		public function Player()
		{
			_assetMC = new Assets_PlayerMC();
		}
		
		
		public function get assetMC():MovieClip
		{
			return _assetMC;
		}

	}
}