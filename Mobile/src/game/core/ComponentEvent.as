package game.core 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class ComponentEvent extends Event 
	{
		public static const COMPONENT_LOADED:String = "COMPONENT_LOADED";
		
		public function ComponentEvent(type:String) 
		{
			super(type);
		}
		
	}

}