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
	
	import KTAP.objects.Ragdoll;
	
	
	
	public class TestRagdoll extends Test{
		
		private var _arrRagdolls:Array;
		
		public function TestRagdoll(){
			
			// Set Text field
			Main.m_aboutText.text = "Ragdolls";
			
			_arrRagdolls = new Array();
			
			var circ:b2CircleShape; 
			var box:b2PolygonShape;
			var bd:b2BodyDef = new b2BodyDef();
			var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			
			for (var i:int = 0; i < 10; i++){
				var startX:Number = 70 + Math.random() * 20 + 480 * i;
				var startY:Number = 20 + Math.random() * 50;
				
				var tmpRagdoll:Ragdoll = new Ragdoll( startX, startY, m_world, m_physScale );
				m_sprite.addChild( tmpRagdoll );				
				_arrRagdolls.push( tmpRagdoll );
			}
			
			/*
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
			
		}
		
		
		public override function Update():void
		{
			super.Update();
			updateRagdolls();
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