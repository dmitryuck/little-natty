package  
{
	import flash.events.Event;
	import game.core.*;
	
	/**
	 * ...
	 * @author Monkgol
	 */

	public class SceneTemplate extends Scene
	{
		
		public function SceneTemplate(sourceFile:String) 
		{
			super(sourceFile);
		}
		
		override protected function onCreate(e:Event):void 
		{
			super.onCreate(e);			
		}
		
		override protected function onDestroy(e:Event):void 
		{
			super.onDestroy(e);
		}
		
		override protected function onUpdate(e:Event):void 
		{
			super.onUpdate(e);				
		}
	}

}