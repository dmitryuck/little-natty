package user 
{
	import flash.events.Event;
	import game.core.*;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Scene20 extends Scene
	{
		public var canComplete:Boolean;
		
		public var wand:int = 4;
		public var step:int = 60;
		
		
		public function Scene20(sourceFile:String)
		{
			super(sourceFile);
		}
		
		override protected function onCreate(e:SceneEvent):void 
		{
			super.onCreate(e);
			
			Main.loadInterface();
			
			Main.setWand(wand);
			Main.setStep(step);
			
			Main.showActiveTarget("popugay");
		}
		
		override protected function onDestroy(e:Event):void 
		{
			super.onDestroy(e);
			
			Main.unloadInterface();
		}
		
	}

}