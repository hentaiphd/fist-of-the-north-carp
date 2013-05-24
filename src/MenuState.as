package
{
    import org.flixel.*;

    public class MenuState extends FlxState{
        [Embed(source="../assets/bg.png")] private var ImgBG:Class;
        [Embed(source="../assets/logo.png")] private var ImgLogo:Class;
        [Embed(source="../assets/ripple.png")] private var ImgRipple:Class;

        override public function create():void{

            var bg:FlxSprite = new FlxSprite(0, 0, ImgBG);
            add(bg);

            var ripple:FlxSprite = new FlxSprite(120, 214);
            ripple.loadGraphic(ImgRipple, true, true, 338, 28, true);
            ripple.addAnimation("rippling", [0, 1], .8);
            add(ripple);
            ripple.play("rippling");

            var t:FlxText;
            t = new FlxText(0,FlxG.height/2+40,FlxG.width,"(fist of the north carp)\nbased on a true story\n\nNina Freeman, Emmett Butler #fishingjam");
            t.size = 22;
            t.color = 0xff109cee;
            t.alignment = "center";
            add(t);

            var logo:FlxSprite = new FlxSprite(90, 100, ImgLogo);
            add(logo);

            t = new FlxText(0,FlxG.height-40,FlxG.width,"DOWN to play, UP to instructions");
            t.alignment = "center";
            t.size = 20;
            t.color = 0xff109cee;
            add(t);


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
