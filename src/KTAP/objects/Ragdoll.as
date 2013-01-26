package KTAP.objects
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.b2Bound;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointDef;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;

//	import com.physics.World;
	/**
	 * ...
	 * @author ScanPlayGames
	 */
	
	public class Ragdoll extends PhysicsObject
	{
		
		private var circleShape:b2CircleShape;
				
		//head
		public var head:b2Body;
		public var torso:b2Body;
		protected var torso2:b2Body;
		protected var torso3:b2Body;
		
		//arms
		protected var upperArmL:b2Body;
		protected var upperArmR:b2Body;
		protected var lowerArmL:b2Body;
		protected var lowerArmR:b2Body;
		
		//legs
		protected var upperLegL:b2Body;
		protected var upperLegR:b2Body;
		protected var lowerLegL:b2Body;
		protected var lowerLegR:b2Body;
		
		//joints
		protected var jointDef:b2RevoluteJointDef;
		protected var anchorJoint1:b2Joint;
		protected var anchorJoint2:b2Joint;
		
		//fixture details
		protected var density:Number = .1;
		
		
		public function Ragdoll( _x:Number, _y:Number, p_world:b2World, p_physScale:Number )
		{
			super(p_world, p_physScale);
			
			graphics.beginFill( 0xAA0000, 1 );
			graphics.drawRect( 0, 0, 20, 20 );
			graphics.endFill();
			
			var startX:Number = _x;
			var startY:Number =_y ;
			bodyDef.type = b2Body.b2_dynamicBody;
			
			// CREATE THE HEAD
			circleShape = new b2CircleShape( 12.5 / m_physScale );
			
			//fixture def
			fixtureDef.shape = circleShape;
			fixtureDef.density =  density;
			fixtureDef.friction = 0.4;
			fixtureDef.restitution = 0.3;
			
			//create the body def
			bodyDef.position.Set(startX / m_physScale, startY / m_physScale);
			
			//create the head
			head = m_world.CreateBody(bodyDef);
			head.CreateFixture(fixtureDef);
			
			//CREATE THE TORSO
			boxDef.SetAsBox(15 / m_physScale, 30 / m_physScale);
			
			//create the fixture
			fixtureDef.shape = boxDef;
			fixtureDef.density =  density;
			fixtureDef.friction = 0.4;
			fixtureDef.restitution = 0.1;
			
			//set position
			bodyDef.position.Set(startX / m_physScale, (startY + 38) / m_physScale);
			torso = m_world.CreateBody(bodyDef);
			torso.CreateFixture(fixtureDef);
			
			/*
			
			// THE SECOND TORSO SEGMENT
			boxDef = new b2PolygonShape();
			boxDef.SetAsBox(15 / m_physScale, 10 / m_physScale);
			
			//create the fixture
			fixtureDef.shape = boxDef;
			bodyDef.position.Set(startX / m_physScale, (startY + 43) / m_physScale);
			
			torso2 = m_world.CreateBody(bodyDef);
			torso2.CreateFixture(fixtureDef);
			
			//CREAT THE THIRD TORSO SEGMENT
			boxDef.SetAsBox(15 / m_physScale, 10 / m_physScale);
			fixtureDef.shape = boxDef;
			bodyDef.position.Set(startX / m_physScale, (startY + 58) / m_physScale);
			torso3 = m_world.CreateBody(bodyDef);
			torso3.CreateFixture(fixtureDef);
			*/
			
			// CREATE THE UPPER ARM
			fixtureDef.density =  density;
			fixtureDef.friction = 0.4;
			fixtureDef.restitution = 0.1;
			
			// L
			boxDef = new b2PolygonShape();
			boxDef.SetAsBox(18 / m_physScale, 6.5 / m_physScale);
			fixtureDef.shape =boxDef;
			bodyDef.position.Set((startX - 30) / m_physScale, (startY + 20) / m_physScale);
			upperArmL = m_world.CreateBody(bodyDef);
			upperArmL.CreateFixture(fixtureDef);
			
			// R
			boxDef = new b2PolygonShape();
			boxDef.SetAsBox(18 / m_physScale, 6.5 / m_physScale);
			fixtureDef.shape = boxDef;
			bodyDef.position.Set((startX + 30) / m_physScale, (startY + 20) / m_physScale);
			upperArmR = m_world.CreateBody(bodyDef);
			upperArmR.CreateFixture(fixtureDef);
			
			// LowerArm
			fixtureDef.density =  density;
			fixtureDef.friction = 0.4;
			fixtureDef.restitution = 0.1;
			
			// L
			boxDef = new b2PolygonShape();
			boxDef.SetAsBox(17 / m_physScale, 6 / m_physScale);
			fixtureDef.shape = boxDef;
			bodyDef.position.Set((startX - 57) / m_physScale, (startY + 20) / m_physScale);
			lowerArmL = m_world.CreateBody(bodyDef);
			lowerArmL.CreateFixture(fixtureDef);
			
			// R
			boxDef = new b2PolygonShape();
			boxDef.SetAsBox(17 / m_physScale, 6 / m_physScale);
			fixtureDef.shape = boxDef;
			bodyDef.position.Set((startX + 57) / m_physScale, (startY + 20) / m_physScale);
			lowerArmR = m_world.CreateBody(bodyDef);
			lowerArmR.CreateFixture(fixtureDef);
			
			// UpperLeg
			fixtureDef.density =  density;
			fixtureDef.friction = 0.4;
			fixtureDef.restitution = 0.1;
			
			// L
			boxDef = new b2PolygonShape();
			boxDef.SetAsBox(7.5 / m_physScale, 22 / m_physScale);
			fixtureDef.shape = boxDef;
			bodyDef.position.Set((startX - 8) / m_physScale, (startY + 85) / m_physScale);
			upperLegL = m_world.CreateBody(bodyDef);
			upperLegL.CreateFixture(fixtureDef);
			// R
			boxDef = new b2PolygonShape();
			boxDef.SetAsBox(7.5 / m_physScale, 22 / m_physScale);
			fixtureDef.shape =boxDef;
			bodyDef.position.Set((startX + 8) / m_physScale, (startY + 85) / m_physScale);
			upperLegR = m_world.CreateBody(bodyDef);
			upperLegR.CreateFixture(fixtureDef);
			
			// LowerLeg
			fixtureDef.density =  density;
			fixtureDef.friction = 0.4;
			fixtureDef.restitution = 0.1;
			
			// L
			boxDef = new b2PolygonShape();
			boxDef.SetAsBox(6 / m_physScale, 20 / m_physScale);
			fixtureDef.shape = boxDef;
			bodyDef.position.Set((startX - 8) / m_physScale, (startY + 120) / m_physScale);
			lowerLegL = m_world.CreateBody(bodyDef);
			lowerLegL.CreateFixture(fixtureDef);
			
			// R
			boxDef = new b2PolygonShape();
			boxDef.SetAsBox(6 / m_physScale, 20 / m_physScale);
			fixtureDef.shape = boxDef;
			bodyDef.position.Set((startX + 8) / m_physScale, (startY + 120) / m_physScale);
			lowerLegR = m_world.CreateBody(bodyDef);
			lowerLegR.CreateFixture(fixtureDef);
			
			// JOINTS
			jointDef = new b2RevoluteJointDef();
			jointDef.enableLimit = true;
			
			//positionHeadAnchor(startX, startY);
			
			
			
/*			
			// Body to Head
/////////////
			var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
				const numPlanks:int = 2;
				jd.lowerAngle = -15 / (180/Math.PI);
				jd.upperAngle = 15 / (180/Math.PI);
				jd.enableLimit = true;
				
				var prevBody:b2Body = ground;
				for (i = 0; i < numPlanks; ++i)
				{
					bd.position.Set((100 + 22 + 44 * i) / m_physScale, 250 / m_physScale);
					body = m_world.CreateBody(bd);
					body.CreateFixture(fixtureDef);
					
					anchor.Set((100 + 44 * i) / m_physScale, 250 / m_physScale);
					jd.Initialize(prevBody, body, anchor);
					m_world.CreateJoint(jd);
					
					prevBody = body;
				}
				
				anchor.Set((100 + 44 * numPlanks) / m_physScale, 250 / m_physScale);
				jd.Initialize(prevBody, ground, anchor);
				m_world.CreateJoint(jd);
			}

//////////////			
*/			
			// Head to shoulders
			jointDef.lowerAngle = -40 / (180/Math.PI);
			jointDef.upperAngle = 40 / (180/Math.PI);
			jointDef.Initialize(torso, head, new b2Vec2(startX / m_physScale, (startY + 15) / m_physScale));
			m_world.CreateJoint(jointDef);
			
			// Upper arm to shoulders
			// L
			jointDef.lowerAngle = -85 / (180/Math.PI);
			jointDef.upperAngle = 130 / (180/Math.PI);
			jointDef.Initialize(torso, upperArmL, new b2Vec2((startX - 18) / m_physScale, (startY + 20) / m_physScale));
			m_world.CreateJoint(jointDef);
			// R
			jointDef.lowerAngle = -130 / (180/Math.PI);
			jointDef.upperAngle = 85 / (180/Math.PI);
			jointDef.Initialize(torso, upperArmR, new b2Vec2((startX + 18) / m_physScale, (startY + 20) / m_physScale));
			m_world.CreateJoint(jointDef);
			
			// Lower arm to upper arm
			// L
			jointDef.lowerAngle = -130 / (180/Math.PI);
			jointDef.upperAngle = 10 / (180/Math.PI);
			jointDef.Initialize(upperArmL, lowerArmL, new b2Vec2((startX - 45) / m_physScale, (startY + 20) / m_physScale));
			m_world.CreateJoint(jointDef);
			// R
			jointDef.lowerAngle = -10 / (180/Math.PI);
			jointDef.upperAngle = 130 / (180/Math.PI);
			jointDef.Initialize(upperArmR, lowerArmR, new b2Vec2((startX + 45) / m_physScale, (startY + 20) / m_physScale));
			m_world.CreateJoint(jointDef);
			
			/*
			// Shoulders/stomach
			jointDef.lowerAngle = -15 / (180/Math.PI);
			jointDef.upperAngle = 15 / (180/Math.PI);
			jointDef.Initialize(torso, torso2, new b2Vec2(startX / m_physScale, (startY + 35) / m_physScale));
			m_world.CreateJoint(jointDef);
			
			// Stomach/hips
			jointDef.Initialize(torso2, torso3, new b2Vec2(startX / m_physScale, (startY + 50) / m_physScale));
			m_world.CreateJoint(jointDef);
			*/
			
			// Torso to upper leg
			// L
			jointDef.lowerAngle = -25 / (180/Math.PI);
			jointDef.upperAngle = 45 / (180/Math.PI);
			jointDef.Initialize(torso, upperLegL, new b2Vec2((startX - 8) / m_physScale, (startY + 72) / m_physScale));
			m_world.CreateJoint(jointDef);
			// R
			jointDef.lowerAngle = -45 / (180/Math.PI);
			jointDef.upperAngle = 25 / (180/Math.PI);
			jointDef.Initialize(torso, upperLegR, new b2Vec2((startX + 8) / m_physScale, (startY + 72) / m_physScale));
			m_world.CreateJoint(jointDef);
			
			// Upper leg to lower leg
			// L
			jointDef.lowerAngle = -25 / (180/Math.PI);
			jointDef.upperAngle = 115 / (180/Math.PI);
			jointDef.Initialize(upperLegL, lowerLegL, new b2Vec2((startX - 8) / m_physScale, (startY + 105) / m_physScale));
			m_world.CreateJoint(jointDef);
			// R
			jointDef.lowerAngle = -115 / (180/Math.PI);
			jointDef.upperAngle = 25 / (180/Math.PI);
			jointDef.Initialize(upperLegR, lowerLegR, new b2Vec2((startX + 8) / m_physScale, (startY + 105) / m_physScale));
			m_world.CreateJoint(jointDef);
			

		}
		
		public override function Update():void{
			x = upperArmL.GetPosition().x * m_physScale;
			y = upperArmL.GetPosition().y * m_physScale;
			rotation  = upperArmL.GetAngle() * (180 / Math.PI);
			
		}
		
		public function move(x:Number, y:Number):void {
			if (anchorJoint1 != null)
			{
				m_world.DestroyJoint(anchorJoint1);
				m_world.DestroyJoint(anchorJoint2);
			}
			
			
		}
		
		public function positionHeadAnchor(startX:Number, startY:Number):void{

			if (anchorJoint1 != null)
			{
				m_world.DestroyJoint(anchorJoint1);
				m_world.DestroyJoint(anchorJoint2);
			}
			
			var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
			var anchor:b2Vec2 = new b2Vec2();
			var ground:b2Body = m_world.GetGroundBody();
			var prevBody:b2Body = ground;
			
						
			anchor.Set(startX / m_physScale, startY/ m_physScale);
			jd.Initialize(head, ground, anchor);
			anchorJoint2 = m_world.CreateJoint(jd);
			
			
		}
		
		public override function Destroy():void
		{
//			Main.physicsObjects.splice(Main.physicsObjects.indexOf(this), 1);
			
			m_world.DestroyBody(head);
			m_world.DestroyBody(torso);
			m_world.DestroyBody(torso2);
			m_world.DestroyBody(torso3);
			
			m_world.DestroyBody(upperArmL);
			m_world.DestroyBody(upperArmR);
			m_world.DestroyBody(lowerArmL);
			m_world.DestroyBody(lowerArmR);
			
			m_world.DestroyBody(upperLegL);
			m_world.DestroyBody(upperLegR);
			m_world.DestroyBody(lowerLegL);
			m_world.DestroyBody(lowerLegR);
		}
	}
}
