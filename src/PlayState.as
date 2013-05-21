package
{
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

        override public function create():void{

            setupWorld();

            var debugDrawing:DebugDraw = new DebugDraw();
            debugDrawing.debugDrawSetup(_world, ratio, 1.0, 1, 0.5);

            var floor:B2FlxTileblock = new B2FlxTileblock(0, 400, 640, 80, _world);
            floor.createBody();
            floor.makeGraphic(400,640);
            add(floor);

            var dad:Dad = new Dad(_world);
        }

        private function setupWorld():void{

            var gravity:b2Vec2 = new b2Vec2(0,9.8);
            _world = new b2World(gravity,true);
        }

        override public function update():void{

            _world.Step(FlxG.elapsed, 10, 10);
            _world.DrawDebugData();
            super.update();
        }
    }
}
