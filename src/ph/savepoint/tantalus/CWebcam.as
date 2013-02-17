package ph.savepoint.tantalus
{
	import com.gskinner.geom.ColorMatrix;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.StatusEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	
	import uk.co.soulwire.cv.MotionTracker;
	
	public class CWebcam
	{
		public var motionTracker:MotionTracker;
		
		//! For Visualization of Motion Tracking
		public var sourceBmp:Bitmap;
		public var outputBmp:Bitmap;
		public var bounds:Shape;
		public var target:Shape;
		
		private var _matrix:ColorMatrix;
		private var _video:BitmapData;
		private var _vid:Video;
		
		public var cam:Camera;
		
		private var _cameraWidth:int;
		private var _cameraHeight:int;
		private var _frameRate:int;
		
		//private var _startCallback:Function;
		private var _declineCallback:Function;
		
		
		public function CWebcam(camWidth:int, camHeight:int, frameRate:int)
		{
			_cameraWidth = camWidth;
			_cameraHeight = camHeight;
			
			var camW : int = _cameraWidth;
			var camH : int = _cameraHeight;
			
			_frameRate = frameRate;
			
			// Create the camera
			cam = Camera.getCamera();
			cam.setMode(_cameraWidth, _cameraHeight, _frameRate);
		}
		
		
		public function startCamera(declineCallbackFunc:Function):void
		{
			_declineCallback = declineCallbackFunc;
			
			
//			// Create the camera
//			cam = Camera.getCamera();
//			cam.setMode(_cameraWidth, _cameraHeight, _frameRate);
			
			cam.addEventListener(StatusEvent.STATUS, statusHandler);
			
			if(cam.muted)
			{
				//! prompt
				Security.showSettings(SecurityPanel.PRIVACY);
			}
			else
			{
				// Create a video
				_vid = new Video(_cameraWidth, _cameraHeight);
				_vid.attachCamera(cam);
			}
		}
		
		
		protected function statusHandler(event:StatusEvent):void
		{
			//trace("Code: " + event.code);
			
			//cam.removeEventListener(StatusEvent.STATUS, statusHandler);
			
			Console.log("\n[cameraOffHandler]\n " + event.code);
			
			switch(event.code)
			{
				case "Camera.Unmuted":

					// Create a video
					_vid = new Video(_cameraWidth, _cameraHeight);
					_vid.attachCamera(cam);
					
					break;
				
				case "Camera.Muted":
//					if(_declineCallback != null)
//					{
//						_declineCallback();
//					}
					break;
			}
			
			if(_declineCallback != null)
			{
				_declineCallback();
			}
		}		
		
		
		public function removeCameraListeners():void
		{
			cam.removeEventListener(StatusEvent.STATUS, statusHandler);
		}
		
		public function initMotionTracking():void
		{
			//_startCallback = startCallbackFunc;
			//_endCallback = endCallbackFunc;
			

			// Create the Motion Tracker
			motionTracker = new MotionTracker(_vid);
			
			// We flip the input as we want a mirror image
			motionTracker.flipInput = true;
			
			/*** Create a few things to help us visualise what the MotionTracker is doing... ***/
			
			_matrix = new ColorMatrix();
			_matrix.brightness = motionTracker.brightness;
			_matrix.contrast = motionTracker.contrast;
			
			
			// Display the camera input with the same filters (minus the blur) as the MotionTracker is using
			_video = new BitmapData(_cameraWidth, _cameraHeight, false, 0);
			sourceBmp = new Bitmap(_video);
			sourceBmp.scaleX = -1;
			sourceBmp.filters = [new ColorMatrixFilter(_matrix.toArray())];
			
			
			// Show the image the MotionTracker is processing and using to track
			outputBmp = new Bitmap(motionTracker.trackingImage);
			
			
			// A shape to represent the tracking point
			target = new Shape();
			target.graphics.lineStyle(0, 0xFFFFFF);
			target.graphics.drawCircle(0, 0, 10);
			//addChild(_target);
			
			
			// A box to represent the activity area
			bounds = new Shape();
			bounds.x = outputBmp.x;
			bounds.y = outputBmp.y;
			//addChild(_bounds);
		}
		
		
		private function setupInitialFilters():void
		{
			motionTracker.blur = 5;
			motionTracker.brightness = -7;
			motionTracker.contrast = 0;
			motionTracker.minArea = 0;
			
			_matrix.reset();
			_matrix.adjustContrast(motionTracker.contrast);
			_matrix.adjustBrightness(motionTracker.brightness);
			sourceBmp.filters = [new ColorMatrixFilter(_matrix)];
		}
	
		
		public function updateMotionTracker():void
		{
			// Tell the MotionTracker to update itself
			motionTracker.track();
			
			// Move the target with some easing
			//_target.x += ((_motionTracker.x + _bounds.x) - _target.x) / 10;
			//_target.y += ((_motionTracker.y + _bounds.y) - _target.y) / 10;
			target.x += ((motionTracker.x + bounds.x) - target.x);
			target.y += ((motionTracker.y + bounds.y) - target.y);
			
			
			
			// Draw the video captured by the webcam
			_video.draw(motionTracker.input);
			
			// If there is enough movement (see the MotionTracker's minArea property) then continue
			//if ( !_motionTracker.hasMovement ) return;
			if( motionTracker.motionArea == null) return; 
			
			// Draw the motion bounds so we can see what the MotionTracker is doing
			bounds.graphics.clear();
			bounds.graphics.lineStyle(0, 0xFFFFFF);
			bounds.graphics.drawRect(motionTracker.motionArea.x, motionTracker.motionArea.y, motionTracker.motionArea.width, motionTracker.motionArea.height);
			
		}

	}
}