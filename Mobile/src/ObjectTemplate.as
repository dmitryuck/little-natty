package  
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.core.*;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class ObjectTemplate extends GameObject
	{		
		public function ObjectTemplate(fileName:String, name:String, tag:String) 
		{
			super(fileName, name, tag);
		}		
		
		override protected function onClick(e:MouseEvent):void 
		{
			if (e.target == this)
			{
				
			}
		}
		
		override protected function onCreate(e:ObjectEvent):void 
		{
			super.onCreate(e);
		}
		
		override protected function onUpdate(e:Event):void 
		{
			super.onUpdate(e);	
		}		
		
		override protected function onDestroy(e:Event):void 
		{
			super.onDestroy(e);
		}
		
	}

}