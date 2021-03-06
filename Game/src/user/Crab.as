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
	public class Crab extends GameObject
	{		
		public var animTimer:Timer;
		
		
		public function Crab(fileName:String, name:String, tag:String) 
		{
			super(fileName, name, tag);
		}		
		
		// Старт диалога
		public static function showDialog():void
		{
			var currentSceneClass:Class = Main.getCurrentSceneClass();
			if (currentSceneClass(Game.scene).canComplete || Game.findWindow("dialog")) return;
			
			if (Game.scene.getCurrentScene() == "level_3")
			{				
				Game.loadWindow(new Position(0, 0), "dialog", DialogCrab1, "graphics/comix/vstrecha_s_crabom.swf");				
			}
			
			if (Game.scene.getCurrentScene() == "level_5")
			{
				Game.loadWindow(new Position(0, 0), "dialog", DialogCrab2, "graphics/comix/prines_kluch.swf");				
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
			
			animTimer = new Timer(3000);
			animTimer.addEventListener(TimerEvent.TIMER, onIdlePlay);
			animTimer.start();
		}
		
		// Проигрывание анимации бездействия
		public function onIdlePlay(e:TimerEvent):void
		{
			playAnimation("idle", false);
		}		
		
		override protected function onDestroy(e:Event):void 
		{
			super.onDestroy(e);
			
			animTimer.removeEventListener(TimerEvent.TIMER, onIdlePlay);
			animTimer = null;
		}
		
	}

}