package{
    import org.flixel.*;
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;

    public class Dad extends FlxSprite{
        public var _world:b2World;
        private var ratio:Number = 30;
        private var rod:B2FlxSprite;
        private var jointBase:B2FlxSprite;

        public function Dad(_world:b2World){
            this._world = _world;

            setupRod();
            setupLine();
        }

        private function setupRod():void{
            jointBase = new B2FlxSprite(320, 100, 5, 5, _world);
            jointBase.angle = 30;
            jointBase.createBody(b2Body.b2_staticBody);
            jointBase.makeGraphic(5, 5);

            rod = new B2FlxSprite(jointBase.x, jointBase.y, 3, 100, _world);
            rod.angle = 30;
            rod.createBody(b2Body.b2_dynamicBody);
            rod._obj.SetAngle(1.9*Math.PI);
            rod.makeGraphic(3, 100);

            FlxG.state.add(jointBase);
            FlxG.state.add(rod);

            var revJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
            revJointDef.Initialize(jointBase._obj, rod._obj, new b2Vec2(jointBase._obj.GetPosition().x,jointBase._obj.GetPosition().y));
            revJointDef.enableMotor = true;
            revJointDef.motorSpeed = -2;
            revJointDef.maxMotorTorque = 10;
            var joint_added:b2RevoluteJoint = _world.CreateJoint(revJointDef) as b2RevoluteJoint;
        }

        private function setupLine():void{
            var chainLength:int = 5;
            var polygonShape:b2PolygonShape = new b2PolygonShape();
            polygonShape.SetAsBox(5/ratio,chainLength/ratio);

            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.density=.01;
            fixtureDef.shape=polygonShape;

            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type=b2Body.b2_dynamicBody;

            for (var i:Number = 0; i <= 30; i++) {
                bodyDef.position.Set(320/ratio,(chainLength+2*chainLength*i)/ratio);
                if (i==0) {
                    var _link:B2FlxSprite = new B2FlxSprite(320, 240, 2, chainLength, _world);
                    _link.createBody(b2Body.b2_dynamicBody,bodyDef,fixtureDef);
                    _link.makeGraphic(2, chainLength+10);
                    FlxG.state.add(_link);
                    var link:b2Body=_link._obj;
                    revoluteJoint(rod._obj,link,new b2Vec2(0,50/ratio),new b2Vec2(0,-chainLength/ratio));
                }
                else {
                    var _newLink:B2FlxSprite = new B2FlxSprite(320, 240, 2, chainLength, _world);
                    _newLink.createBody(b2Body.b2_dynamicBody,bodyDef,fixtureDef);
                    _newLink.makeGraphic(2, chainLength+10);
                    FlxG.state.add(_newLink);
                    var newLink:b2Body=_newLink._obj;
                    revoluteJoint(link,newLink,new b2Vec2(0,chainLength/ratio),new b2Vec2(0,-chainLength/ratio));
                    link=newLink;
                }
            }
        }

        private function revoluteJoint(bodyA:b2Body,bodyB:b2Body,anchorA:b2Vec2,anchorB:b2Vec2):void {
            var revoluteJointDef:b2RevoluteJointDef=new b2RevoluteJointDef();
            revoluteJointDef.localAnchorA.Set(anchorA.x,anchorA.y);
            revoluteJointDef.localAnchorB.Set(anchorB.x,anchorB.y);
            revoluteJointDef.bodyA=bodyA;
            revoluteJointDef.bodyB=bodyB;
            _world.CreateJoint(revoluteJointDef);
        }
    }
}
