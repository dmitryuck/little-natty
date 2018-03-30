package user 
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import game.core.ComponentEvent;
	import game.ui.Window;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Interface extends Window 
	{
		public var timer:Timer;
		
		
		public function Interface(name:String, fileName:String) 
		{
			super(name, fileName);
			
			Main.timeMin = 0;
			Main.timeSec = 0;
		}
		
		override protected function onCreate(e:ComponentEvent):void 
		{
			super.onCreate(e);
			
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		public function onTimer(e:TimerEvent):void
		{
			Main.timeSec ++;
			
			if (Main.timeSec >= 60)
			{
				Main.timeSec = 0;
				Main.timeMin ++;
			}
		}
		
		override protected function onDestroy(e:Event):void 
		{
			super.onDestroy(e);
			
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			timer = null;
		}
	}

}