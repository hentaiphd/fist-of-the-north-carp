package
{
    import org.flixel.*;

    public class MenuState extends FlxState{
        [Embed(source="../assets/bg.png")] private var ImgBG:Class;

        override public function create():void{

            var bg:FlxSprite = new FlxSprite(0, 0, ImgBG);
            add(bg);

            var t:FlxText;
            t = new FlxText(0,FlxG.height/2-10,FlxG.width,"go fishing today");
            t.size = 36;
            t.color = 0xff0000ff;
            t.alignment = "center";
            add(t);
            t = new FlxText(FlxG.width/2-50,FlxG.height-20,100,"DOWN to play");
            t.alignment = "center";
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
