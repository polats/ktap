package KTAP.objects
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * ...
	 * @author ScanPlayGames
	 */
	public class PhysicsObject extends Sprite
	{
		protected var body:b2Body;
		protected var bodyDef:b2BodyDef;
		protected var fixtureDef:b2FixtureDef;
		protected var boxDef:b2PolygonShape;
		protected var m_world:b2World;
		protected var m_physScale:Number;
		
		public function PhysicsObject( p_world:b2World, p_physScale:Number )
		{
			m_world = p_world;
			m_physScale = p_physScale;
			
			//create the box definition
			boxDef                 = new b2PolygonShape();
			bodyDef                = new b2BodyDef();
			fixtureDef             = new b2FixtureDef();
		}
		
		public function GetBody():b2Body
		{
			return body;
		}
		
		public function Destroy():void
		{
			m_world.DestroyBody(body);
			
//			Main.physicsObjects.splice(Main.physicsObjects.indexOf(this), 1);
//			
//			if (Main.sprite.contains(this))
//				Main.sprite.removeChild(this);
		}
		
		public function Update():void
		{
			x = body.GetPosition().x * m_physScale;
			y = body.GetPosition().y * m_physScale;
			rotation  = body.GetAngle() * (180 / Math.PI);
		}
	}
}