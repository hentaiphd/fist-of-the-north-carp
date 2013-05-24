package{
    import org.flixel.*;
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;

    public class Player extends FlxSprite{

        [Embed(source="../assets/x.png")] private var ImgPlayer:Class;

        private var runSpeed:int = 5;
        private var _jumppower:int = 290;
        private var jumping:Boolean = false;
        public var lastUnhookTime:Number = 0;

        public function Player(x:int, y:int){
            super(20, 340);
            this.makeGraphic(x,y);
            loadGraphic(ImgPlayer, true, true, 68, 140, true);
            addAnimation("standing", [1]);
            addAnimation("running", [1,2,3,4]);
            addAnimation("crouching", [1]);
            addAnimation("jumping", [1]);
            addAnimation("falling", [1]);
            addAnimation("fishslap", [1,2,3]);

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
                play("running");
            } else if(FlxG.keys.RIGHT){
                facing = RIGHT;
                x += runSpeed;
                play("running");
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

            if(jumping == true){
                if(velocity > 0){
                    play("jumping");
                }
                if(velocity < 0){
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
