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
	public class Scene25 extends Scene
	{
		public var canComplete:Boolean;
		
		public var wand:int = 4;
		public var step:int = 60;
		
		
		public function Scene25(sourceFile:String)
		{
			super(sourceFile);
			
			canComplete = true;			
		}
		
		override protected function onCreate(e:SceneEvent):void 
		{
			super.onCreate(e);			
			
			Main.loadInterface();
			
			Main.setWand(wand);
			Main.setStep(step);
			
			Main.showActiveTarget("exit");
		}
		
		override protected function onDestroy(e:Event):void 
		{
			super.onDestroy(e);
			
			Main.unloadInterface();
		}
		
	}

}