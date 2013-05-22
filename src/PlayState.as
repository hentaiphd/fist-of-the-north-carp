package{
    import org.flixel.*;
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;


    public class PlayState extends FlxState{
        [Embed(source="../assets/tiles.png")] private var ImgCube:Class;

        public var _world:b2World;
        private var ratio:Number = 30;
        public var dad:Dad;
        public var player:Player;

        override public function create():void{
            setupWorld();

            var floor:B2FlxTileblock = new B2FlxTileblock(0, 400, 640, 80, _world);
            floor.createBody();
            floor.makeGraphic(480,640);
            add(floor);

            dad = new Dad(_world);
            player = new Player(20,20);
            add(player);

            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.density = .001;

            var fish:B2FlxSprite = new B2FlxSprite(320, 240, 20, 20, _world);
            fish.createBody(b2Body.b2_dynamicBody, null, fixtureDef);
            fish.makeGraphic(20, 20);
            add(fish);
            dad.hook(fish);
        }

        private function setupWorld():void{
            var gravity:b2Vec2 = new b2Vec2(0,9.8);
            _world = new b2World(gravity,true);
            var debugDrawing:DebugDraw = new DebugDraw();
            debugDrawing.debugDrawSetup(_world, ratio, 1.0, 1, 0.5);
        }

        override public function update():void{
            _world.Step(FlxG.elapsed, 10, 10);
            _world.DrawDebugData();
            FlxG.collide();

            dad.update();

            super.update();
        }
    }
}
