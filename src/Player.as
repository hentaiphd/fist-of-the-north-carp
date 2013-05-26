package{
    import org.flixel.*;
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;

    public class Player extends FlxSprite{
        [Embed(source = "../assets/jump.mp3")] private var sfxJump:Class;
        [Embed(source="../assets/girl_sprites.png")] private var ImgPlayer:Class;

        private var runSpeed:int = 5;
        private var _jumppower:int = 290;
        private var jumping:Boolean = false;
        private var running:Boolean = false;
        public var lastUnhookTime:Number = 0;

        public function Player(x:int, y:int){
            super(20, 340);

            loadGraphic(ImgPlayer, true, true, 48, 80, true);
            frameWidth = 48;
            frameHeight = 80;
            width = 30

            addAnimation("run", [7,8,9,10], 14, true);
            addAnimation("standing", [11]);
            addAnimation("crouching", [3]);
            addAnimation("jumping", [4]);
            addAnimation("apex", [5]);
            addAnimation("falling", [6]);
            addAnimation("fishslap", [1,2], 14, false);

            drag.x = runSpeed*8;
            drag.y = runSpeed*3;
        }

        override public function update():void{
            super.update();
            borderCollide();
            acceleration.x = 0;
            acceleration.y = 1000;


            if(FlxG.keys.LEFT) {
                facing = LEFT;
                x -= runSpeed;
                play("run");
            } else if(FlxG.keys.RIGHT){
                facing = RIGHT;
                x += runSpeed;
                play("run");
            } else {
                play("standing");
                running = false;
            }

            if(this.isTouching(FlxObject.FLOOR)){
                jumping = false;
            }

            if((FlxG.keys.SPACE || FlxG.keys.UP)){
                if(!jumping){
                    play("crouching");
                    jumping = true;
                    velocity.y -= _jumppower;
                } else {
                    velocity.y -= 10;
                }
            }

            if(FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("SPACE")){
                FlxG.play(sfxJump);
            }

            if(jumping == true){
                if(velocity.y < 0){
                    play("jumping");
                }
                if(velocity.y > 0){
                    play("falling");
                }
            }
        }

        public function borderCollide():void{
            if(x >= FlxG.width - width)
                x = FlxG.width - width;
            if(this.x <= 0)
                this.x = 0;
            if(this.y >= FlxG.height - height)
                this.y = FlxG.height - height;
            if(this.y <= 0)
                this.y = 0;
        }

        public function fishSlap():void{
            play("fishslap");
        }

    }
}
