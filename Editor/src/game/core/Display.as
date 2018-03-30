package game.core 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Display extends Sprite 
	{		
		public var size:Size;
		
		
		public function Display(parent:Sprite)
		{
			addEventListener(Event.ADDED_TO_STAGE, onCreate);
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);			
			
			parent.addChild(this);
			
			setResolution(800, 600);			
		}		
		
		private function onCreate(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onCreate);
			addEventListener(Event.ENTER_FRAME, onUpdate);
		}		
		
		private function onDestroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			removeEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		private function onUpdate(e:Event):void 
		{
			
		}
		
		public function setResolution(width:int, height:int):void
		{
			size = new Size(width, height);
		}
		
		public function getDisplayWidth():int
		{
			return size.width;
		}
		
		public function getDisplayHeight():int
		{
			return size.height;
		}
		
	}

}