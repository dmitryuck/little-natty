package user 
{
	import flash.events.MouseEvent;
	import game.core.Audio;
	import game.core.Game;
	import game.ui.Window;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Slides extends Window 
	{
		public var clickCount:int;
		
		
		public function Slides(name:String, fileName:String) 
		{
			super(name, fileName);
			
			Audio.stopMusic();
		}
		
		override protected function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			
			// Уровень 1 начало игры
			if (Game.scene.getCurrentScene() == "level_1")
			{
				if (clickCount == 0) setSource("graphics/comix/int_2.swf");
				if (clickCount == 1)
				{
					setSource("graphics/comix/int_3.swf");
					
					Audio.playSound("sounds/int_3.mp3");
				}
				
				if (clickCount == 2)
				{
					setSource("graphics/comix/int_4.swf");
				}
				
				if (clickCount == 3)
				{
					setSource("graphics/comix/int_5.swf");
				}				
				
				if (clickCount == 4)
				{
					Audio.playMusic("sounds/game_music.mp3", true);
					
					Main.showActiveTarget("exit");
					
					Game.destroyWindow(this);		
				}
			}
			
			// Уровень 25 конец игры
			if (Game.scene.getCurrentScene() == "level_25")
			{
				if (clickCount == 0) setSource("graphics/comix/sc_end_2.swf");
				if (clickCount == 1)
				{
					//setSource("graphics/comix/sc_end_black.swf");
				}
				if (clickCount == 2) 
				{
					Game.loadScene("scenes/menu.scn");
					
					Game.destroyWindow(this);
				}
			}
			
			clickCount += 1;
		}
		
	}

}