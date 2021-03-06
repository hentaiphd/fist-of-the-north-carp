package
{
    import org.flixel.*;

    public class MenuState extends FlxState{
        [Embed(source="../assets/bg.png")] private var ImgBG:Class;
        [Embed(source="../assets/logo.png")] private var ImgLogo:Class;
        [Embed(source="../assets/ripple.png")] private var ImgRipple:Class;
        [Embed(source="../assets/fishtheme.mp3")] private var SndBGM:Class;

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
            op.fill(0x66000000);
            add(op);

            var t:FlxText;
            t = new FlxText(0,FlxG.height/2+40,FlxG.width,"(fist of the north carp)\nbased on a true story\n\nNina Freeman, Emmett Butler\naudio by Deckman Coss - #fishingjam");
            t.size = 18;
            t.color = 0xffffffff;
            t.alignment = "center";
            add(t);

            var logo:FlxSprite = new FlxSprite(90, 100, ImgLogo);
            add(logo);

            t = new FlxText(0,FlxG.height-40,FlxG.width,"DOWN to play, UP to instructions");
            t.alignment = "center";
            t.size = 20;
            t.color = 0xffffffff;
            add(t);

            FlxG.playMusic(SndBGM);

            FlxG.mouse.hide();
        }

        override public function update():void{
            super.update();

            if(FlxG.keys.DOWN){
                FlxG.switchState(new PlayState());
            } else if(FlxG.keys.UP){
                FlxG.switchState(new HowState());
            }
        }
    }
}
