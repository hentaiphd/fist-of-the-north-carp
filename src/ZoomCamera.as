/**
 * You will need to change the package name to fit your game
 */
package
{
    import org.flixel.FlxCamera;
    import org.flixel.FlxG;

    /**
     * ZoomCamera: A FlxCamera that centers its zoom on the target that it follows
     * Flixel version: 2.5+
     *
     * @link http://www.kwarp.com
     * @author greglieberman
     * @email greg@kwarp.com
     *
     */
    public class ZoomCamera extends FlxCamera
    {

        /**
         * Tell the camera to LERP here eventually
         */
        public var targetZoom:Number;

        /**
         * This number is pretty arbitrary, make sure it's greater than zero!
         */
        protected var zoomSpeed:Number = 25;

        /**
         * Determines how far to "look ahead" when the target is near the edge of the camera's bounds
         * 0 = no effect, 1 = huge effect
         */
        protected var zoomMargin:Number = 0.25;


        public function ZoomCamera(X:int, Y:int, Width:int, Height:int, Zoom:Number=0)
        {
            super(X, Y, Width, Height, Zoom);

            targetZoom = 1;

        }

        public override function update():void
        {
            super.update();

            // update camera zoom
            zoom += (targetZoom - zoom) / 2 * (FlxG.elapsed) * zoomSpeed;

            // if we are zooming in, align the camera (x, y)
            if(target && _zoom != 1)
            {
                alignCamera();
            }
            else
            {
                x = 0;
                y = 0;
            }
        }


        /**
         * Align the camera x and y to center on the target
         * that it's following when zoomed in
         *
         * This took many guesses!
         */
        private function alignCamera():void
        {

            // target position in screen space
            var targetScreenX:Number = target.x + target.width/2 - scroll.x;
            var targetScreenY:Number = target.y + target.height/2- scroll.y;

            // center on the target, until the camera bumps up to its bounds
            // then gradually favor the edge of the screen based on zoomMargin
            var ratioMinX:Number = (targetScreenX / (width/2) ) - 1 - zoomMargin;
            var ratioMinY:Number = (targetScreenY / (height/2)) - 1 - zoomMargin;
            var ratioMaxX:Number = ((-width + targetScreenX) / (width/2) ) + 1 + zoomMargin;
            var ratioMaxY:Number = ((-height + targetScreenY) / (height/2)) + 1 + zoomMargin;

            // offsets are numbers between [-1, 1]
            var offsetX:Number = clamp(ratioMinX, -1, 0) + clamp(ratioMaxX, 0, 1);
            var offsetY:Number = clamp(ratioMinY, -1, 0) + clamp(ratioMaxY, 0, 1);

            // offset the screen in any direction, based on zoom level
            // Example: a zoom of 2 offsets it half the screen at most
            x = -(width  / 2) * (offsetX) * (_zoom - 1);
            y = -(height / 2) * (offsetY) * (_zoom - 1);

        }

        /**
         * Given a value passed in, returns a Number between min and max (inclusive)
         *
         * @param value        the Number you want to evaluate
         * @param min        the minimum number that should be returned
         * @param max        the maximum number that should be returned
         * @return             value clamped between min and max
         *
         */
        private function clamp(value:Number, min:Number, max:Number) : Number
        {
            if(value < min) return min;
            if(value > max) return max;
            return value;
        }


    }
}
