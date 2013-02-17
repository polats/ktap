package ph.savepoint.tantalus
{
	import flash.media.Sound;
	import flash.media.SoundTransform;
	
	
	/**
	 * Provides control over BGM and SFX playback, as well as Master Volume adjustment.
	 * 
	 * @author Kristian
	 */	
	public class CSoundManager
	{
		private static var _bgMusic:CBGMusic;
		
		private static var _sfxTransform:SoundTransform = new SoundTransform();
		private static var _bgmTransform:SoundTransform = new SoundTransform();
		
		private static var _bgmEnabled:Boolean;
		private static var _sfxEnabled:Boolean;
		
		private static var _arrSfxList:Array = new Array();

		/**
		 * Plays an SFX releasing the object at once after playing.
		 *  
		 * @param sfx - the sound object to be played.
		 * @return - the SoundEffect object created 
		 */		
		public static function playSFX(sfx:Sound):CSoundEffect
		{
			if( _sfxEnabled )
			{
				var tmpSfxObj:CSoundEffect = new CSoundEffect(sfx);
				//_arrSfxList.push( tmpSfxObj );
				tmpSfxObj.playAndDestroy();
				return tmpSfxObj;
			}
			return null;
		}
		
		
		/**
		 * Plays a BGM, regardless if there is already a BGM currently being played by SoundManager.
		 *  
		 * @param bgm - the sound object to be played as BGM
		 * @param bLooping - determines whether the BGM will continuously play or not.
		 */		
		public static function playBGM(bgm:Sound, bLooping:Boolean = true):void
		{
			if(_bgMusic != null)
			{
				if(_bgMusic.isPlaying)
				{
					_bgMusic.stop();
					_bgMusic.destroy();
					_bgMusic = null;
				}
			}
			
			_bgMusic = new CBGMusic(bgm, bLooping);
			_bgMusic.play();
			if(!_bgmEnabled) _bgMusic.pause();
		}
		
		
		/**
		 * Pauses the BGM from playing. 
		 * 
		 */		
		public static function pauseBGM():void
		{
			if(_bgMusic != null)
			{
				_bgMusic.pause();
			}
		}
		
		
		/**
		 * Prompts the BGM to continue playing at the point wherein it was paused. 
		 * 
		 */		
		public static function unpauseBGM():void
		{
			if(_bgMusic != null)
			{
				_bgMusic.unpause();
			}
		}
		
		
		/**
		 * Stops the BGM completely from playing. 
		 * 
		 */		
		public static function stopBGM():void
		{
			if(_bgMusic != null)
			{
				_bgMusic.stop();
			}
		}
		
		
		/**
		 * Sets/Controls the volume for SFX.
		 * 
		 * @param vol - A value between 0 and 1 inclusive, with 1 being the loudest.
		 */		
		public static function setSfxVolume(vol:Number):void
		{
			if(vol > 1)
			{
				_sfxTransform.volume = 1;
			}
			else if(vol < 0)
			{
				_sfxTransform.volume = 0;
			}
			else
			{
				_sfxTransform.volume = vol;
				
			}
			
			var sfx:CSoundEffect;
			for ( var i:int = 0; i < _arrSfxList.length; i++ )
			{
				sfx = _arrSfxList[i] as CSoundEffect;
				sfx.sfxChannel.soundTransform = _sfxTransform;
			}
		}
		
		
		/**
		 * Sets/Controls the volume for BGM.
		 * 
		 * @param vol - A value between 0 and 1 inclusive, with 1 being the loudest.
		 */	
		public static function setBgmVolume(vol:Number):void
		{
			if(vol > 1)
			{
				_bgmTransform.volume = 1;
			}
			else if(vol < 0)
			{
				_bgmTransform.volume = 0;
			}
			else
			{
				_bgmTransform.volume = vol;
			}
			
			_bgMusic.bgmChannel.soundTransform = _bgmTransform;
		}
		
		
		public static function isBgmPaused():Boolean
		{
			if(_bgMusic == null)
				return false;
			
			return _bgMusic.isPaused;
		}
		
		public static function isBGMPlaying():Boolean
		{
			if(_bgMusic == null)
				return false;
			
			return _bgMusic.isPlaying;
		}

		
		public static function get bgmEnabled():Boolean
		{
			return _bgmEnabled;
		}

		
		public static function set bgmEnabled(value:Boolean):void
		{
			_bgmEnabled = value;
		}

		
		public static function get sfxEnabled():Boolean
		{
			return _sfxEnabled;
		}

		
		public static function set sfxEnabled(value:Boolean):void
		{
			_sfxEnabled = value;
			
			if( _sfxEnabled )
			{
				setSfxVolume(1);
			}
			else
			{
				setSfxVolume(0);
			}
		}

		
		public static function get bgmTransform():SoundTransform
		{
			return _bgmTransform;
		}

		
		public static function set bgmTransform(value:SoundTransform):void
		{
			_bgmTransform = value;
		}

		
		public static function get sfxTransform():SoundTransform
		{
			return _sfxTransform;
		}

		
		public static function set sfxTransform(value:SoundTransform):void
		{
			_sfxTransform = value;
		}

		
		public static function get arrSfxList():Array
		{
			return _arrSfxList;
		}
	}
}