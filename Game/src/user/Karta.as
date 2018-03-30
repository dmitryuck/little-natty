package user
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import game.ui.Window;
	
	import game.core.*;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Karta extends GameObject
	{		
		
		public function Karta(fileName:String, name:String, tag:String) 
		{
			super(fileName, name, tag);
		}		
		
		// Старт диалога
		public static function showDialog():void
		{
			
		}
		
		/*override protected function onClick(e:MouseEvent):void 
		{
			if (e.target == this)
			{
				
			}
		}*/
		
		override protected function onCreate(e:ObjectEvent):void 
		{
			super.onCreate(e);
		}
		
		override protected function onDestroy(e:Event):void 
		{
			super.onDestroy(e);
		}
		
	}

}