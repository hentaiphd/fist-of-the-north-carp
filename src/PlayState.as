package{
    import org.flixel.*;
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;


    public class PlayState extends FlxState{
        [Embed(source = "../assets/fishslap1.mp3")] private var sfxFishslap:Class;
        [Embed(source = "../assets/getfish.mp3")] private var sfxFishscore:Class;
        [Embed(source = "../assets/startgame.mp3")] private var sfxStart:Class;
        [Embed(source="../assets/bg.png")] private var ImgBG:Class;
        [Embed(source="../assets/fish_1.png")] private var ImgFish1:Class;
        [Embed(source="../assets/fish_2.png")] private var ImgFish2:Class;
        [Embed(source="../assets/fish_3.png")] private var ImgFish3:Class;
        [Embed(source="../assets/fish_4.png")] private var ImgFish4:Class;
        [Embed(source="../assets/fish_5.png")] private var ImgFish5:Class;
        [Embed(source="../assets/fish_6.png")] private var ImgFish6:Class;
        [Embed(source="../assets/fish_7.png")] private var ImgFish7:Class;
        [Embed(source="../assets/fish_8.png")] private var ImgFish8:Class;
        [Embed(source="../assets/fish_9.png")] private var ImgFish9:Class;
        [Embed(source="../assets/fish_10.png")] private var ImgFish10:Class;
        [Embed(source="../assets/fish_11.png")] private var ImgFish11:Class;
        [Embed(source="../assets/fish_12.png")] private var ImgFish12:Class;
        [Embed(source="../assets/ripple.png")] private var ImgRipple:Class;
        [Embed(source="../assets/fishtheme.mp3")] private var SndBGM:Class;

        public var _world:b2World;
        private var ratio:Number = 30;
        public var dad:Dad;
        public var player:Player;

        public var floor:B2FlxTileblock;
        public var leftWall:B2FlxTileblock;
        public var rightWall:B2FlxTileblock;

        public var fish:B2FlxSprite;
        public var sizeCounter:Number = 20;
        public var deadFish:FlxGroup = new FlxGroup();

        public var _timeText:FlxText;
        public var _timer:Number = 0;
        public var _gameEndTime:Number = 0;
        public var _gameWillEnd:Boolean = false;
        public var _endgameActive:Boolean = false;

        public var fishCounter:Number = 0;

        public var zoomCam:ZoomCamera;

        override public function create():void{
            setupWorld();

            var bg:FlxSprite = new FlxSprite(0, 0, ImgBG);
            add(bg);
            FlxG.play(sfxStart);

            floor = new B2FlxTileblock(0, 430, 640, 50, _world);
            floor.createBody();

            leftWall = new B2FlxTileblock(0, 0, 5, 480, _world);
            leftWall.createBody();
            add(leftWall);

            rightWall = new B2FlxTileblock(635, 0, 5, 480, _world);
            rightWall.createBody();
            add(rightWall);

            var ripple:FlxSprite = new FlxSprite(120, 214);
            ripple.loadGraphic(ImgRipple, true, true, 338, 28, true);
            ripple.addAnimation("rippling", [0, 1], .8);
            add(ripple);
            ripple.play("rippling");

            dad = new Dad(270, 110, _world);

            player = new Player(20,20);
            add(player);

            makeFish(20);

            _timeText = new FlxText(0, FlxG.height/2, FlxG.width, "");
            //this.add(_timeText);

            zoomCam = new ZoomCamera(0, 0, 640, 480);
            FlxG.resetCameras(zoomCam);

            if(FlxG.music == null){
                FlxG.playMusic(SndBGM);
            } else {
                FlxG.music.resume();
                if(!FlxG.music.active){
                    FlxG.playMusic(SndBGM);
                }
            }
        }

        private function setupWorld():void{
            var gravity:b2Vec2 = new b2Vec2(0,9.8);
            _world = new b2World(gravity,true);
            var debugDrawing:DebugDraw = new DebugDraw();
            debugDrawing.debugDrawSetup(_world, ratio, 1.0, 1, 0.5);
        }

        private function makeFish(size:Number):void{
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.density = 20*.005;

            var pick:Number = FlxG.random()*12;
            var graphic:Class;
            if(pick > 11){
                graphic = ImgFish12;
            } else if(pick > 10){
                graphic = ImgFish11;
            } else if(pick > 9){
                graphic = ImgFish10;
            } else if(pick > 8){
                graphic = ImgFish9;
            } else if(pick > 7){
                graphic = ImgFish8;
            } else if(pick > 6){
                graphic = ImgFish7;
            } else if(pick > 5){
                graphic = ImgFish6;
            } else if(pick > 4){
                graphic = ImgFish5;
            } else if(pick > 3){
                graphic = ImgFish4;
            } else if(pick > 2){
                graphic = ImgFish3;
            } else if(pick > 1){
                graphic = ImgFish2;
            } else {
                graphic = ImgFish1;
            }

            fish = new B2FlxSprite(320, 240, 48, 24, _world);
            fish.createBody(b2Body.b2_dynamicBody, null, fixtureDef);
            fish.loadGraphic(graphic);
            add(fish);
            dad.hook(fish);
        }

        public function spriteCollide2(floor:B2FlxTileblock,player:Player):void{}
        public function deadFishCollide(dead:FlxSprite,player:Player):void{}
        public function spriteCollide(fish:B2FlxSprite,player:Player):void{
            if(_timer - player.lastUnhookTime > .3){
                if(player.isTouching(FlxObject.DOWN) && fish.isTouching(FlxObject.UP)){
                    deadFish.add(fish);
                    FlxG.play(sfxFishscore);
                    player.lastUnhookTime = _timer;
                    fishCounter += 1;
                    dad.hook(null);
                    sizeCounter += 2;
                    makeFish(sizeCounter);
                } else {
                    player.fishSlap();
                    FlxG.music.pause();
                    FlxG.play(sfxFishslap);
                    zoomCam.target = player;
                    zoomCam.targetZoom = 2.5;
                    _gameWillEnd = true;
                    _gameEndTime = _timer;
                }
            }
        }

        public function showEndgame():void{
            var op:FlxSprite = new FlxSprite(0, 0);
            op.makeGraphic(640, 480);
            op.fill(0x55000000);
            add(op);

            var t:FlxText;
            t = new FlxText(0,FlxG.height/2-90,FlxG.width,"got fishslapped\nhelped dad\nwith " + fishCounter + " fish");
            t.size = 18;
            t.scrollFactor = new FlxPoint(0, 0);
            t.alignment = "center";
            add(t);
            t = new FlxText(0,FlxG.height/2+40,FlxG.width,"DOWN to retry");
            t.alignment = "center";
            t.size = 10;
            t.scrollFactor = new FlxPoint(0, 0);
            add(t);
        }

        override public function update():void{
            FlxG.collide(fish,player,spriteCollide);
            FlxG.collide(deadFish,player,deadFishCollide);
            FlxG.collide(floor,player,spriteCollide2);
            FlxG.collide(leftWall,player,spriteCollide2);
            FlxG.collide(rightWall,player,spriteCollide2);

            if(_timer - _gameEndTime > 1 && _gameWillEnd && !_endgameActive){
                _endgameActive = true;
                showEndgame();
            }

            dad.update();

            _timer += FlxG.elapsed;
            _timeText.text = _timer + "";

            if(!_gameWillEnd){
                _world.Step(FlxG.elapsed, 10, 10);
                _world.DrawDebugData();
                super.update();
            }

            if(_endgameActive){
                if(FlxG.keys.DOWN){
                    FlxG.resetState();
                }
            }
        }
    }
}
