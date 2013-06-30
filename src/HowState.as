package
{
    import org.flixel.*;

    public class HowState extends FlxState{
        [Embed(source="../assets/bg.png")] private var ImgBG:Class;
        [Embed(source="../assets/ripple.png")] private var ImgRipple:Class;

        public var player:Player;
        public var leftWall:B2FlxTileblock;
        public var rightWall:B2FlxTileblock;
        public var floor:B2FlxTileblock;

        override public function create():void{

            var bg:FlxSprite = new FlxSprite(0, 0, ImgBG);
            add(bg);

            var ripple:FlxSprite = new FlxSprite(120, 214);
            ripple.loadGraphic(ImgRipple, true, true, 338, 28, true);
            ripple.addAnimation("rippling", [0, 1], .8);
            add(ripple);
            ripple.play("rippling");

            var op:FlxSprite = new FlxSprite(0, 0);
            op.makeGraphic(640, 480);
            op.fill(0x55000000);
            add(op);

            var t:FlxText = new FlxText(0,30,FlxG.width,"DOWN to play");
            t.alignment = "center";
            t.size = 22;
            t.color = 0xffffffff;
            t.text = "FISHING WITH DAD\n\nArrow keys run and jump\nHelp dad by pulling his fish off the line.\nJump on top of fish to remove\nDad's a goofball...\nso don't get fishslapped";
            add(t);

            t = new FlxText(0,FlxG.height-40,FlxG.width,"DOWN to play");
            t.alignment = "center";
            t.size = 20;
            t.color = 0xffffffff;
            add(t);

            floor = new B2FlxTileblock(0, 430, 640, 50, null);
            add(floor);

            leftWall = new B2FlxTileblock(0, 0, 5, 480, null);
            add(leftWall);

            rightWall = new B2FlxTileblock(635, 0, 5, 480, null);
            add(rightWall);

            player = new Player(20,20);
            add(player);

            FlxG.mouse.hide();
        }

        public function spriteCollide2(floor:B2FlxTileblock,player:Player):void{}

        override public function update():void{
            super.update();

            FlxG.collide(floor,player,spriteCollide2);
            FlxG.collide(leftWall,player,spriteCollide2);
            FlxG.collide(rightWall,player,spriteCollide2);

            if(FlxG.keys.DOWN){
                FlxG.switchState(new PlayState());
            }
        }
    }
}
