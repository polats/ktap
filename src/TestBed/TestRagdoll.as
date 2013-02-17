﻿/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/


package TestBed{
	
	
	
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Dynamics.Joints.*;
	
	import KTAP.Constants;
	import KTAP.Globals;
	import KTAP.layers.LayerBackground;
	import KTAP.layers.LayerDancers;
	import KTAP.layers.LayerGameOver;
	import KTAP.math.MathFunctions;
	import KTAP.objects.Dancer;
	import KTAP.objects.Player;
	import KTAP.objects.Ragdoll;
	
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import flashx.textLayout.elements.BreakElement;
	
	import ph.savepoint.tantalus.CTimeManager;
	import ph.savepoint.tantalus.CTimer;
	
	
	
	public class TestRagdoll extends Test{
		
		private static const STATE_GAME_START:uint = 0;
		private static const STATE_GAME_PLAYING:uint = 1;
		private static const STATE_GAME_END:uint = 2;
		
		private var EVENT_SHOW_CROWD:String = "BGM_SHOW_CROWD";
		private var EVENT_SHOW_CROWD_1:String = "BGM_SHOW_CROWD_1";
		private var EVENT_SHOW_CROWD_3:String = "BGM_SHOW_CROWD_3";
		private var EVENT_SHOW_CROWD_SMALL:String = "BGM_SHOW_CROWD_SMALL";
		private var EVENT_SHOW_CROWD_MED:String = "BGM_SHOW_CROWD_MED";
		private var EVENT_STANZA_END:String = "BGM_STANZA_END";
		
		//! Stored Mouse Position
		private var _mousePt:Point;
		private var _playerMoveEase:Number = 0.1;
		
		//! Flags
		private var _bFollowMouse:Boolean = false;
		private var _bGameHasStarted:Boolean = false;
		
		//! Game Objects
		private var _arrRagdolls:Array;
		private var _crowdIdx:uint = 0;
		private var _dancer:Dancer;
		private var _player:Player;
		private var _mcMusic:MovieClip;
		private var _titleMC:MovieClip;
		
		//! Layers
		private var _layerBackground:LayerBackground;
		private var _layerDancers:LayerDancers;
		private var _layerGameOver:LayerGameOver;
		
		
		//! Containers Only
		private var _sprRagdolls:Sprite;
		private var _sprPlayer:Sprite;
		
		private var _state:uint;
		
		public function TestRagdoll(){
			
			_mousePt = new Point();
			
			//createRagdolls(1, Constants.SCREEN_WIDTH * 0.5, Constants.SCREEN_HEIGHT * 0.5 - 40);
			createPlayer();
			
			//! create layers
			_layerBackground = new LayerBackground();
			this.m_sprite.addChild( _layerBackground.assetMC );
			
			//! Game Over
			_layerGameOver = new LayerGameOver();
			_layerGameOver.signalTryAgainClicked.add( onTryAgain );
			
//			this.m_sprite.addChild( _sprRagdolls );
			
			//! Dancers
			_layerDancers = new LayerDancers();
			_layerDancers.signalPlayerHit.add( onPlayerHit );
			this.m_sprite.addChild( _layerDancers.assetSpr );
			this.m_sprite.addChild( _sprPlayer );

			//! Title
			_titleMC = new Assets_TitleMC();
			this.m_sprite.addChild( _titleMC );
			_titleMC.x = Constants.SCREEN_WIDTH * 0.5;
			_titleMC.y = Constants.SCREEN_HEIGHT * 0.5 + 100;
			
			Globals.mousePosPt.x = Constants.SCREEN_WIDTH * 0.5;
			Globals.mousePosPt.y = Constants.SCREEN_HEIGHT * 0.5 - 100;
			
			//! Music
			_mcMusic = new Assets_MusicMC();
			_mcMusic.addEventListener( EVENT_SHOW_CROWD, onShowCrowd );
			_mcMusic.addEventListener( EVENT_SHOW_CROWD_1, onShowCrowd1 );
			_mcMusic.addEventListener( EVENT_SHOW_CROWD_3, onShowCrowd3 );
			_mcMusic.addEventListener( EVENT_SHOW_CROWD_SMALL, onShowCrowdSmall );
			_mcMusic.addEventListener( EVENT_SHOW_CROWD_MED, onShowCrowdMed );
			_mcMusic.addEventListener( EVENT_STANZA_END, onStanzaEnd );
			this.m_sprite.addChild( _mcMusic );
			_mcMusic.visible = false;
			_mcMusic.gotoAndStop( 1 );
			
			Main.m_sprite.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyPressed );
			_state = STATE_GAME_START;
		}		
		
		
		private function onKeyPressed( p_event:KeyboardEvent ):void
		{
			if( _bGameHasStarted == false )
			{
				animateStart();
				_bGameHasStarted = true;
				_bFollowMouse = true;
				_state = STATE_GAME_PLAYING;
				return;
			}
			
//			if( p_event.keyCode == 32 )
//			{
//				_layerDancers.spawnMobs();
//			}
//			
//			trace( p_event.keyCode );
		}
		
		
		private function animateStart():void
		{
			var tlEnterAnim:TimelineMax = new TimelineMax( { onComplete:onEnterAnimComplete } );
			
			tlEnterAnim.append( TweenMax.to( _titleMC, 1, { scaleX:0.8, scaleY:0.8, ease:Strong.easeIn } ) );
			tlEnterAnim.append( TweenMax.to( _titleMC, 3, {  alpha:0, scaleX:3.0, scaleY:3.0, ease:Strong.easeOut } ) );
			tlEnterAnim.play();
		}
		
		private function createRagdolls(numberOfRagDolls:Number, rdX:Number, rdY:Number):void
		{
			_sprRagdolls = new Sprite();
			_arrRagdolls = new Array();
			
			for (var i:int = 0; i < numberOfRagDolls; i++){
				var startX:Number = rdX + 200 * i;
				var startY:Number = rdY;
				
				var tmpRagdoll:Ragdoll = new Ragdoll( startX, startY, m_world, m_physScale );
				_sprRagdolls.addChild( tmpRagdoll );				
				_arrRagdolls.push( tmpRagdoll );
			}
		}
		
		private function createPlayer():void
		{
			_sprPlayer = new Sprite();
			
			_player = new Player();
			_sprPlayer.addChild( _player.assetMC );
			
			_player.assetMC.x = Constants.SCREEN_WIDTH * 0.5;
			_player.assetMC.y = Constants.SCREEN_HEIGHT * 0.5;
			
			_player.signalNoMoreSpeed.add( onPlayerNoMoreSpeed );
		}
		
		private function onEnterAnimComplete():void
		{
			_mcMusic.gotoAndPlay( 1 );
			_layerDancers.startDancing();
			
			//! mute the sound first
//			var muteTransform:SoundTransform = new SoundTransform();
//			muteTransform.volume = 0;
//			_mcMusic.soundTransform = muteTransform;
		}
		
		private function onShowCrowd( p_event:Event ):void
		{
			if( _state != STATE_GAME_PLAYING )
				return;
			
			trace( "show crowd!" );	
			startFlashMob();
		}
		
		private function onShowCrowd1( p_event:Event ):void
		{
			if( _state != STATE_GAME_PLAYING )
				return;
			
			trace( "show crowd 1!" );
			_layerDancers.spawnMobOnRandomPosition( 1 );
		}
		
		private function onShowCrowd3( p_event:Event ):void
		{
			if( _state != STATE_GAME_PLAYING )
				return;
			
			trace( "show crowd 3!" );
			_layerDancers.spawnMobOnRandomPosition( 3 );
		}
		
		private function onShowCrowdSmall( p_event:Event ):void
		{
			if( _state != STATE_GAME_PLAYING )
				return;
			
			trace( "show crowd SMALL!" );
			var randDancers:uint = MathFunctions.RandomFromRange( 2, 5 );
			_layerDancers.spawnMobOnRandomPosition( randDancers );
		}
		
		private function onShowCrowdMed( p_event:Event ):void
		{
			if( _state != STATE_GAME_PLAYING )
				return;
			
			trace( "show crowd MED!" );
			var randDancers:uint = MathFunctions.RandomFromRange( 6, 10 );
			_layerDancers.spawnMobOnRandomPosition( randDancers );
		}
		
		private function onStanzaEnd( p_event:Event ):void
		{
			_mcMusic.gotoAndPlay( 753 );	
		}
		
		private function onPlayerNoMoreSpeed():void
		{
			_state = STATE_GAME_END;
			//! show game over screen
			
			this.m_sprite.stage.addChild( _layerGameOver.assetMC );
			_layerGameOver.playEnterAnimation();
			
			trace( "GAME DURATION: " + Globals.gameTimer.convertTimeElapsedToClockFormat() );
		}
		
		private function onPlayerHit():void
		{
//			Globals.updateScrollSpeed( _player );
		}
		
		private function onTryAgain():void
		{
			if( this.m_sprite.stage.contains( _layerGameOver.assetMC ) )
				this.m_sprite.stage.removeChild( _layerGameOver.assetMC );
			
			_mcMusic.stop();
			
			//! remove all dancers
			_layerDancers.resetDancers();
			
			Globals.initialize();
			
			//! place donna in the center;
			Globals.mousePosPt.x = Constants.SCREEN_WIDTH * 0.5;
			Globals.mousePosPt.y = Constants.SCREEN_HEIGHT * 0.5 - 100;
			
			//! remove listener for update
			_bGameHasStarted = false;
			_bFollowMouse = false;
			_state = STATE_GAME_START;
			
			_player.resetEaseSpeed();
			
			this.m_sprite.addChild( _titleMC );
			_titleMC.x = Constants.SCREEN_WIDTH * 0.5;
			_titleMC.y = Constants.SCREEN_HEIGHT * 0.5 + 100;
			_titleMC.scaleX = 1;
			_titleMC.scaleY = 1;
			_titleMC.alpha = 1;
		}
		
		public override function Update():void
		{
			super.Update();
//			updateRagdolls();
			
			//! update Timer
			CTimeManager.updateTime();
			if( _state == STATE_GAME_PLAYING )
			{
				Globals.gameTimer.updateTimer();
			}
			
			updateMousePosition();
			updatePlayer();
			
			_layerBackground.update();
			_layerDancers.update();
		}
		
		private function updateMousePosition():void
		{
			if( _bFollowMouse == false )
				return;
			
			Globals.updateMousePosPt( this.m_sprite.stage.mouseX, this.m_sprite.stage.mouseY );
			Globals.updateHeroPosPt( _player.assetMC.x, _player.assetMC.y );
/*
			var md:b2MouseJointDef = new b2MouseJointDef();
			md.bodyA = m_world.GetGroundBody();
			md.bodyB = body;
			md.target.Set(mouseXWorldPhys, mouseYWorldPhys);
			md.collideConnected = true;
			md.maxForce = 500.0 * body.GetMass();
			m_mouseJoint = m_world.CreateJoint(md) as b2MouseJoint;
			body.SetAwake(true);
*/			
		}
		
		private function updatePlayer():void
		{
			//! ( target - current ) * ease
			
			_player.update();
			
			//var playerRagdoll:Ragdoll = _arrRagdolls[0];
			//playerRagdoll.head.SetPosition(new b2Vec2(Globals.heroPosPt.x / m_physScale,Globals.heroPosPt.y / m_physScale));
		
			if( _state == STATE_GAME_PLAYING )
				_layerDancers.hitTestPlayer( _player );
		}
		
		private function startFlashMob():void
		{
//			if( _crowdIdx >= 4 )
//				return;
			
			
			var nCount:uint = 12;
			
			switch( _crowdIdx )
			{
				case 0: nCount = 1; break;
				case 1: nCount = 3; break;
				case 2: nCount = 6; break;
				case 3: nCount = 12; break;
				default: nCount = 12; break;
			}
			
			_layerDancers.spawnMobs( nCount );
			
			_crowdIdx++;
		}
		
		private function updateRagdolls():void
		{
			var i:uint = 0;
			var nMax:uint = _arrRagdolls.length;
			var tmpRagdoll:Ragdoll;
			
			for( i = 0; i < nMax; i++ )
			{
				tmpRagdoll = _arrRagdolls[ i ];
				tmpRagdoll.Update();
			}
		}
	}
}