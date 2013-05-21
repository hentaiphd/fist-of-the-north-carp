package
{
    import org.flixel.*;
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import flash.events.Event;
    import flash.display.Sprite;
    import Box2D.Dynamics.Joints.*;


    public class PlayState extends FlxState{
        [Embed(source="../assets/tiles.png")] private var ImgCube:Class;

        public var _world:b2World;

        private var ratio:Number = 30;
        private var the_rev_joint:b2RevoluteJointDef = new b2RevoluteJointDef();

        override public function create():void{

            setupWorld();

            var debugDrawing:DebugDraw = new DebugDraw();
            debugDrawing.debugDrawSetup(_world, ratio, 1.0, 1, 0.5);

            var floor:B2FlxTileblock = new B2FlxTileblock(0, 400, 640, 80, _world);
            floor.createBody();
            floor.makeGraphic(400,640);

            add(floor);

            var cube:B2FlxSprite = new B2FlxSprite(320, 100, 5, 5, _world);
            cube.angle = 30;
            cube.createBody(b2Body.b2_staticBody);
            cube.makeGraphic(5, 5);

            var cube2:B2FlxSprite = new B2FlxSprite(cube.x, cube.y, 3, 100, _world);
            cube2.angle = 30;
            cube2.createBody(b2Body.b2_dynamicBody);
            cube2._obj.SetAngle(1.9*Math.PI);
            cube2.makeGraphic(3, 100);

            add(cube);
            add(cube2);

            the_rev_joint.Initialize(cube._obj, cube2._obj, new b2Vec2(cube._obj.GetPosition().x,cube._obj.GetPosition().y));
            the_rev_joint.enableMotor = true;
            the_rev_joint.motorSpeed = -2;
            the_rev_joint.maxMotorTorque = 10;
            var joint_added:b2RevoluteJoint = _world.CreateJoint(the_rev_joint) as b2RevoluteJoint;

            // link polygon shape
            var chainLength:int = 5;
            var polygonShape:b2PolygonShape = new b2PolygonShape();
            polygonShape.SetAsBox(5/ratio,chainLength/ratio);
            // link fixture;
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.density=.01;
            fixtureDef.shape=polygonShape;
            // link body
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type=b2Body.b2_dynamicBody;
            // link creation

            for (var i:Number=0; i<=30; i++) {
                bodyDef.position.Set(320/ratio,(chainLength+2*chainLength*i)/ratio);
                if (i==0) {
                    var _link:B2FlxSprite = new B2FlxSprite(320, 240, 2, chainLength, _world);
                    _link.createBody(b2Body.b2_dynamicBody,bodyDef,fixtureDef);
                    _link.makeGraphic(2, chainLength+10);
                    add(_link);
                    var link:b2Body=_link._obj;
                    revoluteJoint(cube2._obj,link,new b2Vec2(0,50/ratio),new b2Vec2(0,-chainLength/ratio));
                }
                else {
                    var _newLink:B2FlxSprite = new B2FlxSprite(320, 240, 2, chainLength, _world);
                    _newLink.createBody(b2Body.b2_dynamicBody,bodyDef,fixtureDef);
                    _newLink.makeGraphic(2, chainLength+10);
                    add(_newLink);
                    var newLink:b2Body=_newLink._obj;
                    revoluteJoint(link,newLink,new b2Vec2(0,chainLength/ratio),new b2Vec2(0,-chainLength/ratio));
                    link=newLink;
                }
            }

            add(new FlxText(0,0,100,"INSERT GAME HERE"));
        }

        private function setupWorld():void{

            var gravity:b2Vec2 = new b2Vec2(0,9.8);
            _world = new b2World(gravity,true);
        }

        private function revoluteJoint(bodyA:b2Body,bodyB:b2Body,anchorA:b2Vec2,anchorB:b2Vec2):void {
            var revoluteJointDef:b2RevoluteJointDef=new b2RevoluteJointDef();
            revoluteJointDef.localAnchorA.Set(anchorA.x,anchorA.y);
            revoluteJointDef.localAnchorB.Set(anchorB.x,anchorB.y);
            revoluteJointDef.bodyA=bodyA;
            revoluteJointDef.bodyB=bodyB;
            _world.CreateJoint(revoluteJointDef);
        }

        override public function update():void{

            _world.Step(FlxG.elapsed, 10, 10);
            _world.DrawDebugData();
            super.update();
        }
    }
}
