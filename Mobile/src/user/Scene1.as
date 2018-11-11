package user 
{
	import flash.events.Event;
	import game.core.*;
	import game.ui.Button;
	import game.ui.Text;
	import game.ui.Window;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Scene1 extends Scene
	{
		public var canComplete:Boolean;
		
		public var wand:int = 4;
		public var step:int = 20;
		
		
		public function Scene1(sourceFile:String)
		{
			super(sourceFile);
			
			canComplete = true;			
			
		}
		
		override protected function onCreate(e:SceneEvent):void 
		{
			super.onCreate(e);			

			Main.showLoading();
			
			var slides:Window = Game.loadWindow(new Position(), "slides", Slides, "graphics/comix/int_1.swf");
			
			Main.loadInterface();
			
			Main.setWand(wand);
			Main.setStep(step);
		}
		
		override protected function onDestroy(e:Event):void 
		{
			super.onDestroy(e);
			
			Main.unloadInterface();
		}
		
	}

}