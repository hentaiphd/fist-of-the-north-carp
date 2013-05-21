package
{
	import org.flixel.*;
	import flash.events.Event;
	import flash.display.Sprite;

	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class fishing extends FlxGame
	{
		public static var DEBUG_SPRITE:Sprite;

		public function fishing()
		{
			super(640,480,MenuState,1);
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		private function addedToStage(e:Event):void{
		 	DEBUG_SPRITE = new Sprite;
		 	FlxG.stage.addChild(DEBUG_SPRITE);
		}
	}
}
