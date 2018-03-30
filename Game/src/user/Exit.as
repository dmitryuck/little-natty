package user
{
	import fl.motion.easing.Linear;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.core.*;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Exit extends GameObject
	{		
		public function Exit(fileName:String, name:String, tag:String) 
		{
			super(fileName, name, tag);			
		}
		
		// Открыть выход с карты
		public function open():void
		{
			this.setSource("graphics/objects/exit.swf");
			
			var timer:Timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			
			function onTimer(e:TimerEvent):void
			{				
				playAnimation("idle");
				
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer = null;
			}
		}
		
		// Если находиться возле выхода пробуем завершить уровень
		public static function tryComplete():void
		{			
			var sceneClass:Class = Main.getCurrentSceneClass();
			
			if (sceneClass(Game.scene).canComplete)
			{				
				var natty:GameObject = Game.scene.getObjectByTag("natty");
				var exit:GameObject = Game.scene.getObjectByTag("exit");
				
				// Ползти к выходу
				natty.moveTo(exit.position, 2, Linear.easeNone, true, nattyOnExit);
				
				function nattyOnExit():void
				{
					natty.stopAnimation();
					
					Main.levelCompleted();
				}
			}
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
			
			var currentSceneClass:Class = Main.getCurrentSceneClass();				
			if (currentSceneClass(Game.scene).canComplete) playAnimation("idle"); else setSource("graphics/objects/noexit.swf");
		}		
		
		override protected function onDestroy(e:Event):void
		{
			super.onDestroy(e);
		}
		
	}

}