package
{
   import Box2D.Dynamics.*;
   import flash.display.Sprite;

   public class DebugDraw extends Sprite
   {
      public function DebugDraw()
      {
      }

      public function debugDrawSetup(Box2DWorld:b2World, MetersToPixelsRatio:Number, LineThickness:Number, Alpha:Number, FillAlpha:Number):void
      {
         var debugSprite:Sprite = new Sprite();
         addChild(debugSprite);

         var debugDraw:b2DebugDraw = new b2DebugDraw();

         debugDraw.SetSprite(debugSprite);
         debugDraw.SetDrawScale(MetersToPixelsRatio);
         debugDraw.SetLineThickness(LineThickness);
         debugDraw.SetAlpha(Alpha);
         debugDraw.SetFillAlpha(FillAlpha);
         debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
         Box2DWorld.SetDebugDraw(debugDraw);
      }
   }
}