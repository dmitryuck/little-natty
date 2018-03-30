package game.core 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class SceneEvent extends Event 
	{
		public static const SCENE_LOADED:String = "SCENE_LOADED";
		
		public function SceneEvent(type:String) 
		{
			super(type);
		}
		
	}

}