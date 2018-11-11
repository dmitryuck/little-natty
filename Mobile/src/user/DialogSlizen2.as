package user 
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.core.Audio;
	import game.core.ComponentEvent;
	import game.core.Game;
	import game.core.Position;
	import game.core.Source;
	import game.core.Translit;
	import game.ui.Button;
	import game.ui.Image;
	import game.ui.Text;
	import game.ui.Window;
	
	import com.appodeal.aneplugin.*;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class DialogSlizen2 extends Window 
	{
		public var currentReplic:int = 0;
		public var xmlDialog:XML;
		
		public var dlgFile:String = "dialog_slizen_2";
		
		
		public function DialogSlizen2(name:String, fileName:String) 
		{
			super(name, fileName);
			
			Audio.playMusic("sounds/dialog_music.mp3");
			
			Audio.stopAllSounds();
			
			Audio.canSoundPlay = false;
		}
		
		override protected function onCreate(e:ComponentEvent):void 
		{
			super.onCreate(e);			
			
			xmlDialog = new XML(new Source("dialogs/" + Translit.currentLng + "/" + dlgFile + ".txt").getSource());		
			
			hideComponent(addComponent(new Position(382, 131), "nattyImg", new Image("graphics/interface/dialog_2.swf")));
			hideComponent(addComponent(new Position(327, 18), "friendImg", new Image("graphics/interface/dialog_2.swf")));
			
			addComponent(new Position(419, 166), "nattyReplic", new Text("", Main.dialogTextStyle));
			addComponent(new Position(366, 52), "friendReplic", new Text("", Main.dialogTextStyle));
			
			showReplic();
			
			Main.appodeal.show(Appodeal.BANNER_BOTTOM);
		}
		
		// Говорит Натти
		public function nattySay(replic:String):void
		{
			var nattyReplic:Text = Text(getComponentByName("nattyReplic"));
			var friendReplic:Text = Text(getComponentByName("friendReplic"));
			
			showComponent(nattyReplic);
			hideComponent(friendReplic);
			
			showComponent(getComponentByName("nattyImg"));
			hideComponent(getComponentByName("friendImg"));
			
			nattyReplic.setText(replic);
		}
		
		// Говорит друг
		public function friendSay(replic:String):void
		{
			var nattyReplic:Text = Text(getComponentByName("nattyReplic"));
			var friendReplic:Text = Text(getComponentByName("friendReplic"));
			
			showComponent(friendReplic);
			hideComponent(nattyReplic);
			
			showComponent(getComponentByName("friendImg"));
			hideComponent(getComponentByName("nattyImg"));
			
			friendReplic.setText(replic);
		}
		
		// Показать реплику
		public function showReplic():void
		{
			for each (var replic:XML in xmlDialog.replic)
			{
				if (replic.@id == currentReplic) 
				{
					switch (replic.@person.toString())
					{
						case "natty": nattySay(replic.toString());
						break;
						
						case "friend": friendSay(replic.toString());
						break;
					}
				}
			}
			
			currentReplic ++;
		}
		
		// Диалог завершен
		public function endDialog():void
		{
			Main.appodeal.hide(Appodeal.BANNER_BOTTOM);
			
			Scene10(Game.scene).canComplete = true;
			
			Exit(Game.scene.getObjectByTag("exit")).open();
			
			Audio.playMusic("sounds/game_music.mp3");
			
			Main.showActiveTarget("exit");
			
			Audio.canSoundPlay = true;
			
			Game.destroyWindow(this);
		}
		
		override protected function onClick(e:MouseEvent):void 
		{
			super.onClick(e);		
			
			if (currentReplic == xmlDialog.children().length()) endDialog(); else showReplic();			
		}		
		
	}

}