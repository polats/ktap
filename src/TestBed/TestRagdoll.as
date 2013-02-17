/*
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
	
	
	
	public class TestRagdoll extends Test{
		
		private var EVENT_SHOW_CROWD:String = "BGM_SHOW_CROWD";
		
		
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
		
		//! Containers Only
		private var _sprRagdolls:Sprite;
		private var _sprPlayer:Sprite;
		
		public function TestRagdoll(){
			
			// Set Text field
//			Main.m_aboutText.text = "Ragdolls";
			
			_mousePt = new Point();
			
			//createRagdolls(1, Constants.SCREEN_WIDTH * 0.5, Constants.SCREEN_HEIGHT * 0.5 - 40);
			createPlayer();
//			createDancers();
			
			_mcMusic = new Assets_MusicMC();
			
			//! create layers
			_layerBackground = new LayerBackground();
			this.m_sprite.addChild( _layerBackground.assetMC );
			
//			this.m_sprite.addChild( _sprRagdolls );
			
			_layerDancers = new LayerDancers();
			this.m_sprite.addChild( _layerDancers.assetSpr );
			this.m_sprite.addChild( _sprPlayer );
			this.m_sprite.addChild( _mcMusic );
			_mcMusic.visible = false;
			_mcMusic.gotoAndStop( 1 );

			
			_titleMC = new Assets_TitleMC();
			this.m_sprite.addChild( _titleMC );
			_titleMC.x = Constants.SCREEN_WIDTH * 0.5;
			_titleMC.y = Constants.SCREEN_HEIGHT * 0.5 + 100;
			
			Globals.heroPosPt.x = Constants.SCREEN_WIDTH * 0.5;
			Globals.heroPosPt.y = Constants.SCREEN_HEIGHT * 0.5 - 100;
			
			Main.m_sprite.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyPressed );
		}		
		
		
		private function onKeyPressed( p_event:KeyboardEvent ):void
		{
			if( _bGameHasStarted == false )
			{
				animateStart();
				_bGameHasStarted = true;
				return;
			}
			
			if( p_event.keyCode == 32 )
			{
				_layerDancers.spawnMobs();
			}
			
			trace( p_event.keyCode );
		}
		
		
		private function animateStart():void
		{
			var tlEnterAnim:TimelineMax = new TimelineMax( { onComplete:addListeners } );
			
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
		}
		
		private function addListeners():void
		{
			_mcMusic.addEventListener( EVENT_SHOW_CROWD, onShowCrowd );
			_mcMusic.gotoAndPlay( 1 );
			
			_bFollowMouse = true;
		}
		
		private function onShowCrowd( p_event:Event ):void
		{
			startFlashMob();
		}
		
		public override function Update():void
		{
			super.Update();
//			updateRagdolls();
			
			updateMousePosition();
			updatePlayer();
			
			_layerBackground.update();
			_layerDancers.update();
		}
		
		
		private function updateMousePosition():void
		{
			if( _bFollowMouse == false )
				return;
			
			Globals.updateHeroPosPt( this.m_sprite.stage.mouseX, this.m_sprite.stage.mouseY );
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
			
			_player.assetMC.x += ( Globals.heroPosPt.x - _player.assetMC.x ) * _playerMoveEase;
			_player.assetMC.y += ( Globals.heroPosPt.y - _player.assetMC.y ) * _playerMoveEase;
			
			//var playerRagdoll:Ragdoll = _arrRagdolls[0];
			//playerRagdoll.head.SetPosition(new b2Vec2(Globals.heroPosPt.x / m_physScale,Globals.heroPosPt.y / m_physScale));
		
			_layerDancers.hitTestPlayer( _player );
		}
		
		
		private function startFlashMob():void
		{
			if( _crowdIdx >= 4 )
				return;
			
			
			var nCount:uint = 12;
			
			switch( _crowdIdx )
			{
				case 0: nCount = 1; break;
				case 1: nCount = 3; break;
				case 2: nCount = 6; break;
				case 3: nCount = 12; break;
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
		
		//======================
		// Member Data 
		//======================
	}
	
}