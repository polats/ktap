package ph.savepoint.tantalus
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	
	/**
	 * Creates a sound effect object, meant to be played once.
	 * Object should be destroyed/freed every time it finishes playing.
	 * 
	 **/
	public class CSoundEffect
	{
		private var _sfx:Sound;
		private var _sfxChannel:SoundChannel;
		private var _bWillDelete:Boolean = false;
		
		
		/**
		 * Constructor, taking a sound object to be played as SFX
		 * @param sound - the sound object to be played
		 */		
		public function CSoundEffect(sound:Sound)
		{
			_sfx = sound;
			_bWillDelete = false;
		}
		
		
		/**
		 * Releases the resources that was used by the class, usually called
		 * before the class is terminated. 
		 * 
		 */		
		public function destroy():void
		{
			//delete _sfx;
			if(_sfxChannel)
			{
				_sfxChannel.stop();
				_sfxChannel.removeEventListener(Event.SOUND_COMPLETE, onSfxComplete);
				
				_sfxChannel.soundTransform = new SoundTransform();
				_sfxChannel = null;
			}
			_sfx = null;
		}
		
		
		/**
		 * Triggers the SFX to play and releases itself once it is done playing. 
		 * 
		 */		
		public function playAndDestroy():void
		{
			_sfxChannel = _sfx.play();
			_sfxChannel.addEventListener(Event.SOUND_COMPLETE, onSfxComplete);
			_sfxChannel.soundTransform = CSoundManager.sfxTransform;
			
			_bWillDelete = true;
		}
		
		
		/**
		 * Triggers the SFX to play, but keeps itself in memory for later use. 
		 * 
		 */		
		public function play():void
		{
			_sfxChannel = _sfx.play();
			_sfxChannel.addEventListener(Event.SOUND_COMPLETE, onSfxComplete);
			_sfxChannel.soundTransform = CSoundManager.sfxTransform;
			
			_bWillDelete = false;
		}
		
				
		private function onSfxComplete(evt:Event):void
		{
			var i:int = CSoundManager.arrSfxList.indexOf( this );
			//trace( "_sfx: " + i );
			CSoundManager.arrSfxList.splice( i, 1 );
			if(_bWillDelete)
			{
				//destroy the instance after _sfx has finished playing
				destroy();
			}
		}

		
		public function get sfxChannel():SoundChannel
		{
			return _sfxChannel;
		}

	}
}