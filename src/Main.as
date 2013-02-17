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

package{

import Box2D.Collision.*;
import Box2D.Collision.Shapes.*;
import Box2D.Common.Math.*;
import Box2D.Dynamics.*;
import Box2D.Dynamics.Contacts.*;
import Box2D.Dynamics.Joints.*;

import General.*;

import KTAP.Globals;

import TestBed.*;

import flash.display.*;
import flash.display.MovieClip;
import flash.events.Event;
import flash.text.*;

	[SWF(width='634', height='475', backgroundColor='#292C2C', frameRate='30')]
	public class Main extends MovieClip{
		public function Main() {
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);

			Globals.initialize();
			
			m_sprite = new Sprite();
			addChild(m_sprite);
			
			m_fpsCounter.x = 7;
			m_fpsCounter.y = 5;
			addChildAt(m_fpsCounter, 0);
			
			// input
			m_input = new Input(m_sprite);
			
			m_currTest = new TestRagdoll();
			
		}
		
		public function update(e:Event):void{
			// clear for rendering
			m_sprite.graphics.clear()
			
			// update current test
			m_currTest.Update();
			
			// Update input (last)
			Input.update();
			
			// update counter and limit framerate
			m_fpsCounter.update();
			FRateLimiter.limitFrame(30);
		}
		
		
		//======================
		// Member data
		//======================
		static public var m_fpsCounter:FpsCounter = new FpsCounter();
		public var m_currId:int = 0;
		static public var m_currTest:Test;
		static public var m_sprite:Sprite;
//		static public var m_aboutText:TextField;
		// input
		public var m_input:Input;
	}
}
