package
{
    import org.flixel.*;

    public class MenuState extends FlxState{
        [Embed(source="../assets/bg.png")] private var ImgBG:Class;
        [Embed(source="../assets/logo.png")] private var ImgLogo:Class;

        override public function create():void{

            var bg:FlxSprite = new FlxSprite(0, 0, ImgBG);
            add(bg);

            var t:FlxText;
            t = new FlxText(0,FlxG.height/2+40,FlxG.width,"(fist of the north carp)\n\nNina Freeman\nEmmett Butler\n#fishingjam");
            t.size = 22;
            t.color = 0xff109cee;
            t.alignment = "center";
            add(t);

            var logo:FlxSprite = new FlxSprite(90, 100, ImgLogo);
            add(logo);

            t = new FlxText(0,FlxG.height-40,FlxG.width,"DOWN to play");
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
            }
        }
    }
}
