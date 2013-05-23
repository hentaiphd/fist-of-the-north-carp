package
{
    import org.flixel.*;

    public class HowState extends FlxState{
        [Embed(source="../assets/bg.png")] private var ImgBG:Class;

        override public function create():void{

            var bg:FlxSprite = new FlxSprite(0, 0, ImgBG);
            add(bg);

            var t:FlxText = new FlxText(0,30,FlxG.width,"DOWN to play");
            t.alignment = "center";
            t.size = 22;
            t.color = 0xffe75c70;
            t.text = "FISHING WITH DAD\n\nArrow keys run and jump\nHelp dad by pulling his fish off the line.\nJump on top of fish to remove\nDon't let fish hit you";
            add(t);

            t = new FlxText(0,FlxG.height-40,FlxG.width,"DOWN to play, UP to menu");
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
                FlxG.switchState(new MenuState());
            }
        }
    }
}
