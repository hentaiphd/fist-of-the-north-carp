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
        private var rodJoint:b2RevoluteJoint;
        private var hookJoint:b2RevoluteJoint;
        private var link:b2Body;

        public static const RODBITS:Number = 1;
        public static const LINEBITS:Number = 2;

        public function Dad(_world:b2World){
            this._world = _world;

            setupRod();
            setupLine();
        }

        public function setRodSpeed(speed:Number):void{
            rodJoint.SetMotorSpeed(speed);
        }

        override public function update():void{
            var speed:Number = rodJoint.GetMotorSpeed();
            var angle:Number = rodJoint.GetJointAngle();
            if(angle <= rodJoint.GetLowerLimit() ||
               angle >= rodJoint.GetUpperLimit()){
                rodJoint.SetMotorSpeed(speed*-1);
            }

            super.update();
        }

        public function hook(fish:B2FlxSprite):void{
            if(fish == null || hookJoint != null){
                _world.DestroyJoint(hookJoint);
                if(fish == null){
                    return;
                }
            }
            hookJoint = revoluteJoint(link, fish._obj, new b2Vec2(0, 0), new b2Vec2(0, 0));
        }

        private function setupRod():void{
            jointBase = new B2FlxSprite(320, 100, 1, 1, _world);
            jointBase.angle = 30;
            jointBase.createBody(b2Body.b2_staticBody,null, null, RODBITS);
            jointBase.makeGraphic(5, 5);

            rod = new B2FlxSprite(jointBase.x, jointBase.y, 3, 100, _world);
            rod.angle = 30;
            rod.createBody(b2Body.b2_dynamicBody, null, null, RODBITS);
            rod._obj.SetAngle(1.9*Math.PI);
            rod.makeGraphic(3, 100);

            FlxG.state.add(jointBase);
            FlxG.state.add(rod);

            var revJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
            revJointDef.Initialize(jointBase._obj, rod._obj,
                new b2Vec2(jointBase._obj.GetWorldCenter().x,
                           jointBase._obj.GetWorldCenter().y));
            revJointDef.enableMotor = true;
            revJointDef.motorSpeed = -1;
            revJointDef.lowerAngle = -0.5 * Math.PI;
            revJointDef.upperAngle = 0.5 * Math.PI;
            revJointDef.enableLimit = true;
            revJointDef.maxMotorTorque = 100;
            rodJoint = _world.CreateJoint(revJointDef) as b2RevoluteJoint;
        }

        private function setupLine():void{
            var chainLength:int = 4;
            var polygonShape:b2PolygonShape = new b2PolygonShape();
            polygonShape.SetAsBox(5/ratio,chainLength/ratio);

            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.density=.01;
            fixtureDef.shape=polygonShape;
            fixtureDef.filter.categoryBits = LINEBITS;
            fixtureDef.filter.maskBits = 0;

            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type=b2Body.b2_dynamicBody;

            for (var i:Number = 0; i <= 25; i++) {
                bodyDef.position.Set(320/ratio,(chainLength+2*chainLength*i)/ratio);
                if (i==0) {
                    var _link:B2FlxSprite = new B2FlxSprite(320, 240, 2, chainLength, _world);
                    _link.createBody(b2Body.b2_dynamicBody,bodyDef,fixtureDef);
                    _link.makeGraphic(2, chainLength+10);
                    FlxG.state.add(_link);
                    link = _link._obj;
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

        private function revoluteJoint(bodyA:b2Body,bodyB:b2Body,anchorA:b2Vec2,anchorB:b2Vec2):b2RevoluteJoint{
            var revoluteJointDef:b2RevoluteJointDef=new b2RevoluteJointDef();
            revoluteJointDef.localAnchorA.Set(anchorA.x,anchorA.y);
            revoluteJointDef.localAnchorB.Set(anchorB.x,anchorB.y);
            revoluteJointDef.bodyA=bodyA;
            revoluteJointDef.bodyB=bodyB;
            return _world.CreateJoint(revoluteJointDef) as b2RevoluteJoint;
        }
    }
}
