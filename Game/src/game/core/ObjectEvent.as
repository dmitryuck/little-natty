package game.core 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class ObjectEvent extends Event 
	{
		public static const OBJECT_LOADED:String = "OBJECT_LOADED";
		
		public function ObjectEvent(type:String) 
		{
			super(type);
		}
		
	}

}