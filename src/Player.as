package{
    import org.flixel.*;
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;

    public class Player extends FlxSprite{
        private var runSpeed:int = 5;
        private var _jumppower:int = 290;
        private var jumping:Boolean = false;
        public var lastUnhookTime:Number = 0;

        public function Player(x:int, y:int){
            this.makeGraphic(x,y);

            drag.x = runSpeed*8;
            drag.y = runSpeed*3;
        }

        override public function update():void{
            super.update();
            borderCollide();
            acceleration.x = 0;
            acceleration.y = 1000;

            if(FlxG.keys.LEFT) {
                x -= runSpeed;
            } else if(FlxG.keys.RIGHT){
                x += runSpeed;
            }

            if(this.isTouching(FlxObject.FLOOR)){
                jumping = false;
            }

            if((FlxG.keys.SPACE || FlxG.keys.UP)){
                if(!jumping){
                    jumping = true;
                    velocity.y -= _jumppower;
                } else {
                    velocity.y -= 10;
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

    }
}
