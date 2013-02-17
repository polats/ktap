package ph.savepoint.tantalus
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	
	/**
	 * Provides control for BGM playback with basic functions including 
	 * play, pause, unpause, stop.
	 * 
	 * @author Kristian
	 */	
	public class CBGMusic
	{
		private var _bgm:Sound;
		private var _bgmChannel:SoundChannel;
		
		private var _nTickPosition:Number;
		
		private var _bLooping:Boolean = false;
		private var _isPlaying:Boolean = false;
		private var _isPaused:Boolean = false;
		
		public var bgmVolume:Number = 1;
		
		/**
		 * Constuctor.
		 *  
		 * @param bgmusic - The Sopund object to be played as BGM.
		 * @param bWIllLoop - Flag that determines if the BGM will have looping playback.
		 */		
		public function CBGMusic(bgmusic:Sound, bWIllLoop:Boolean)
		{
			_bgm = bgmusic;
			
			_bLooping = bWIllLoop;
			_isPlaying = false;
			_isPaused = false;
			
			bgmVolume = 1;
		}
		
		
		/**
		 * Releases all resources bound to this class before being terminated.
		 * 
		 */		
		public function destroy():void
		{
			// remove listeners
			if(_bgmChannel)
			{
				if(_isPlaying || _isPaused)
					_bgmChannel.removeEventListener(Event.SOUND_COMPLETE, onBgmComplete);
				
				_bgmChannel.soundTransform = new SoundTransform();
				//_bgmChannel.soundTransform = null;
			}
			
			
			// assign null to every non- primitive property;
			_bgm = null;
			_bgmChannel = null;
		}
		
		
		/**
		 * Plays the BGM from the start of the track, disregarding the 
		 * previous states of the tracks.
		 * 
		 */		
		public function play():void
		{
			if(_isPaused)
			{
				this.stop();
			}
			
			_nTickPosition = 0;
			_bgmChannel = _bgm.play();
			_bgmChannel.addEventListener(Event.SOUND_COMPLETE, onBgmComplete);
			_bgmChannel.soundTransform = CSoundManager.bgmTransform;
			
			_isPlaying = true;
			_isPaused = false;
		}
		
		
		/**
		 * Suspends the playing of the BGM and puts it on PAUSE State.
		 * 
		 */		
		public function pause():void
		{
			if(_isPlaying && _isPaused == false)
			{
				// save the position of the currently playing music.
				_nTickPosition = _bgmChannel.position;
				
				_bgmChannel.stop();
				_bgmChannel.removeEventListener(Event.SOUND_COMPLETE, onBgmComplete);
				
				_isPaused = true;
			}
		}
		
		
		/**
		 * Continues playback of BGM from the point wherein the track was Paused. 
		 * 
		 */		
		public function unpause():void
		{
			if(_isPlaying && _isPaused)
			{
				// save the position of the currently playing music.
				// _nTickPosition = _bgmChannel.position;
				
				_bgmChannel = _bgm.play(_nTickPosition);
				_bgmChannel.addEventListener(Event.SOUND_COMPLETE, onBgmComplete);
				_bgmChannel.soundTransform = CSoundManager.bgmTransform;
				
				_isPaused = false;
			}
		}
		
		
		/**
		 * Completely stops BGM playback. 
		 * 
		 */		
		public function stop():void
		{
			if(_isPlaying)
			{
				_bgmChannel.stop();
				_bgmChannel.removeEventListener(Event.SOUND_COMPLETE, onBgmComplete);
			
				_isPlaying = false;
				_isPaused = false;
			}
		}
		
		
		private function onBgmComplete(evt:Event):void
		{
			this.stop();

			if(_bLooping)
			{
				this.play();
			}
		}
		
		
		public function get isPlaying():Boolean 
		{
			return _isPlaying;
		}

		
		public function get isPaused():Boolean
		{
			return _isPaused;
		}

		
		public function get bgmChannel():SoundChannel
		{
			return _bgmChannel;
		}


	}
}