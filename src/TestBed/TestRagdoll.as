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
	import KTAP.math.MathFunctions;
	import KTAP.objects.Dancer;
	import KTAP.objects.Player;
	import KTAP.objects.Ragdoll;
	
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	
	
	public class TestRagdoll extends Test{
		
		//! Stored Mouse Position
		private var _mousePt:Point;
		private var _playerMoveEase:Number = 0.1;
		
		//! Game Objects
		private var _arrRagdolls:Array;
		private var _arrDancers:Array;
		private var _dancer:Dancer;
		private var _player:Player;
		
		//! Containers Only
		private var _sprRagdolls:Sprite;
		private var _sprDancers:Sprite;
		private var _sprPlayer:Sprite;
		
		public function TestRagdoll(){
			
			// Set Text field
			Main.m_aboutText.text = "Ragdolls";
			
			_mousePt = new Point();
			
			createRagdolls();
			createPlayer();
			createDancers();
			
			this.m_sprite.addChild( _sprRagdolls );
			this.m_sprite.addChild( _sprPlayer );
			this.m_sprite.addChild( _sprDancers );
			
			/*
			var circ:b2CircleShape; 
			var box:b2PolygonShape;
			var bd:b2BodyDef = new b2BodyDef();
			var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			var ground:b2Body = m_world.GetGroundBody();
			
			for (var i:int = 0; i < 7; i++){
				var startX:Number = 45 + 200 * i;
				var startY:Number = 20 + Math.random() * 50;
				
				var tmpRagdoll:Ragdoll = new Ragdoll( startX, startY, m_world, m_physScale );
				m_sprite.addChild( tmpRagdoll );				
				_arrRagdolls.push( tmpRagdoll );
			}

			var head:b2Body;
			
			// Add stairs on the left, these are static bodies so set the type accordingly
			bd.type = b2Body.b2_staticBody;
			fixtureDef.density = 0.0;
			fixtureDef.friction = 0.4;
			fixtureDef.restitution = 0.3;
			for (var j:int = 1; j <= 10; j++) {
				box = new b2PolygonShape();
				box.SetAsBox((10*j) / m_physScale, 10 / m_physScale);
				fixtureDef.shape = box;
				bd.position.Set((10*j) / m_physScale, (150 + 20*j) / m_physScale);
				head = m_world.CreateBody(bd);
				head.CreateFixture(fixtureDef);
			}
			
			// Add stairs on the right
			for (var k:int = 1; k <= 10; k++){
				box = new b2PolygonShape();
				box.SetAsBox((10 * k) / m_physScale, 10 / m_physScale);
				fixtureDef.shape = box;
				bd.position.Set((640-10*k) / m_physScale, (150 + 20*k) / m_physScale);
				head = m_world.CreateBody(bd);
				head.CreateFixture(fixtureDef);
			}
			
			box = new b2PolygonShape();
			box.SetAsBox(30 / m_physScale, 40 / m_physScale);
			fixtureDef.shape = box;
			bd.position.Set(320 / m_physScale, 320 / m_physScale);
			head = m_world.CreateBody(bd);
			head.CreateFixture(fixtureDef);
			*/
			
			TweenMax.delayedCall( 3, startFlashMob );
		}
		
		
		private function createRagdolls():void
		{
			_sprRagdolls = new Sprite();
			_arrRagdolls = new Array();
			
			for (var i:int = 0; i < 10; i++){
				var startX:Number = 70 + Math.random() * 20 + 480 * i;
				var startY:Number = 20 + Math.random() * 50;
				
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
		
		
		public function createDancers():void
		{
			_sprDancers = new Sprite();
			_arrDancers = new Array();
			
			var i:uint = 0;
			var nMax:uint = Constants.MAX_DANCERS;
			var tmpDancer:Dancer;
			
			for( i = 0; i < nMax; i++ )
			{
				tmpDancer = new Dancer();
				_sprDancers.addChild( tmpDancer.assetMC );
				
				_arrDancers.push( tmpDancer );
				randomizeDancerPosition( tmpDancer, i % 12 );
			}
		}
		
		
		private function randomizeDancerPosition( p_dancer:Dancer, p_corderIdx:uint ):void
		{
			
			// 0  |  1 |  2 |  3  
			//    +--------+
			// 4  |        |   5
			//    |        |
			// 6  |        |   7
			//    +--------+   
			// 8  | 9 | 10 |  11 
			
			var posX:Number;
			var posY:Number;
			
			var nHalfScreenWidth:Number = Constants.SCREEN_WIDTH * 0.5;
			var nHalfScreenHeight:Number = Constants.SCREEN_HEIGHT * 0.5;
			
			
			switch( p_corderIdx )
			{
				case 0: //! upper left
					posX = MathFunctions.RandomFromRange( nHalfScreenWidth * -1, 0 );
					posY = MathFunctions.RandomFromRange( nHalfScreenHeight * -1, 0 );	
					break;
				
				case 1: //! upper right
					posX = MathFunctions.RandomFromRange( 0, nHalfScreenWidth );
					posY = MathFunctions.RandomFromRange( nHalfScreenHeight * -1, 0 );
					break;
				
				case 2: //! lower left
					posX = MathFunctions.RandomFromRange( nHalfScreenWidth, Constants.SCREEN_WIDTH );
					posY = MathFunctions.RandomFromRange( nHalfScreenHeight * -1, 0 );
					break;
				
				case 3: //lower right
					posX = MathFunctions.RandomFromRange( Constants.SCREEN_WIDTH, Constants.SCREEN_WIDTH + nHalfScreenWidth );
					posY = MathFunctions.RandomFromRange( nHalfScreenHeight * -1, 0 );
					break;
				
				case 4:
					posX = MathFunctions.RandomFromRange( nHalfScreenWidth * -1, 0 );
					posY = MathFunctions.RandomFromRange( 0, nHalfScreenHeight );
					break;
				
				case 5:
					posX = MathFunctions.RandomFromRange( Constants.SCREEN_WIDTH, Constants.SCREEN_WIDTH + nHalfScreenWidth );
					posY = MathFunctions.RandomFromRange( 0, nHalfScreenHeight );
					break;
				
				case 6:
					posX = MathFunctions.RandomFromRange( nHalfScreenWidth * -1, 0 );
					posY = MathFunctions.RandomFromRange( nHalfScreenHeight, Constants.SCREEN_HEIGHT );
					break;
				
				case 7:
					posX = MathFunctions.RandomFromRange( Constants.SCREEN_WIDTH, Constants.SCREEN_WIDTH + nHalfScreenWidth );
					posY = MathFunctions.RandomFromRange( nHalfScreenHeight, Constants.SCREEN_HEIGHT );
					break;
				
				case 8:
					posX = MathFunctions.RandomFromRange( nHalfScreenWidth * -1, 0 );
					posY = MathFunctions.RandomFromRange( Constants.SCREEN_HEIGHT, Constants.SCREEN_HEIGHT + nHalfScreenHeight );
					break;
				
				case 9: //! upper right
					posX = MathFunctions.RandomFromRange( 0, nHalfScreenWidth );
					posY = MathFunctions.RandomFromRange( Constants.SCREEN_HEIGHT, Constants.SCREEN_HEIGHT + nHalfScreenHeight );
					break;
				
				case 10: //! lower left
					posX = MathFunctions.RandomFromRange( nHalfScreenWidth, Constants.SCREEN_WIDTH );
					posY = MathFunctions.RandomFromRange( Constants.SCREEN_HEIGHT, Constants.SCREEN_HEIGHT + nHalfScreenHeight );
					break;
				
				case 11: //lower right
					posX = MathFunctions.RandomFromRange( Constants.SCREEN_WIDTH, Constants.SCREEN_WIDTH + nHalfScreenWidth );
					posY = MathFunctions.RandomFromRange( Constants.SCREEN_HEIGHT, Constants.SCREEN_HEIGHT + nHalfScreenHeight );
					break;
				
			}
			
			p_dancer.assetMC.x = posX;
			p_dancer.assetMC.y = posY;
		}
		
		
		public override function Update():void
		{
			super.Update();
			updateRagdolls();
			
			updateMousePosition();
			updatePlayer();
		}
		
		
		private function updateMousePosition():void
		{
			Globals.updateHeroPosPt( this.m_sprite.stage.mouseX, this.m_sprite.stage.mouseY );
		}
		
		
		private function updatePlayer():void
		{
			//! ( target - current ) * ease
			
			_player.assetMC.x += ( _mousePt.x - _player.assetMC.x ) * _playerMoveEase;
		}
		
		
		private function startFlashMob():void
		{
			//_dancer.startMobbing();
			
			var i:uint = 0;
			var nMax:uint = _arrDancers.length;
			var tmpDancer:Dancer;
			
			for( i = 0; i < nMax; i++ )
			{
				tmpDancer = _arrDancers[ i ];
				tmpDancer.startMobbing();
			}
			
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