package user 
{
	import flash.events.MouseEvent;
	import game.core.ComponentEvent;
	import game.core.Game;
	import game.core.Position;
	import game.ui.Image;
	import game.ui.Window;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class ItemFound extends Window 
	{
		
		public function ItemFound(name:String, fileName:String) 
		{
			super(name, fileName);
		}
		
		override protected function onCreate(e:ComponentEvent):void 
		{
			super.onCreate(e);
			
			if (Game.scene.name == "level_4") addComponent(new Position(209, 131), null, new Image("graphics/interface/key_seen.swf"));
			
			if (Game.scene.name == "level_16") addComponent(new Position(304, 12), null, new Image("graphics/interface/grog_seen.swf"));
			
			if (Game.scene.name == "level_18") addComponent(new Position(136, 184), null, new Image("graphics/interface/banan_seen.swf"));
			
			if (Game.scene.name == "level_19") addComponent(new Position(114, 216), null, new Image("graphics/interface/banan_seen.swf"));
			
			if (Game.scene.name == "level_21") addComponent(new Position(72, 226), null, new Image("graphics/interface/mapa_seen.swf"));
			
			if (Game.scene.name == "level_22") addComponent(new Position(252, 246), null, new Image("graphics/interface/mapa_seen.swf"));
			
			if (Game.scene.name == "level_23") addComponent(new Position(252, 246), null, new Image("graphics/interface/mapa_seen.swf"));
			
			if (Game.scene.name == "level_24") addComponent(new Position(224, 213), null, new Image("graphics/interface/mapa_seen.swf"));
		}
		
		override protected function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			
			Main.showActiveTarget("exit");
			
			Game.destroyWindow(this);
		}
		
	}

}