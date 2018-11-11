package user 
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import game.core.*;
	import game.ui.Button;
	import game.ui.Component;
	import game.ui.SelectBox;
	import game.ui.Text;
	import game.ui.VerticalScrollbar;
	import game.ui.Window;
	import game.utils.*;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Menu extends Scene
	{
		public var menuWnd:Window;
		public var optionsWnd:Window;
		
		public function Menu(sourceFile:String)
		{
			super(sourceFile);			
		}		
		
		override protected function onCreate(e:SceneEvent):void 
		{
			super.onCreate(e);
			
			Audio.playMusic("sounds/menu_music.mp3", true);
			
			Game.scene.getObjectByName("eyes").playAnimation("idle");
		
			menuWnd = Game.loadWindow(new Position(), "menu");
			
			menuWnd.parent.setChildIndex(menuWnd, 0);
			
			//************************************************
			
			var textF:TextField = new TextField();
			addChild(textF);
			
			textF.type = TextFieldType.INPUT;
			textF.text = "";
			//textF.selectable = true;		
			
			//************************************************
			
			var style:Object = { color:"#ffffff", fontFamily:"Arial", fontSize:"16", width:"150" };
			
			menuWnd.addComponent(new Position(520, 132), "btn_play", new Button("graphics/interface/button_menu.swf", "graphics/interface/button_menu_down.swf", onPlayClick, new Text(Translit.getString("ID_PLAY"), style)));
			menuWnd.addComponent(new Position(520, 190), "btn_options", new Button("graphics/interface/button_menu.swf", "graphics/interface/button_menu_down.swf", onOptionsClick, new Text(Translit.getString("ID_OPTIONS"), style)));
			menuWnd.addComponent(new Position(520, 248), "btn_more", new Button("graphics/interface/button_menu.swf", "graphics/interface/button_menu_down.swf", onMoreClick, new Text(Translit.getString("ID_RESET"),style)));
			menuWnd.addComponent(new Position(520, 306), "btn_exit", new Button("graphics/interface/button_menu.swf", "graphics/interface/button_menu_down.swf", onExitClick, new Text(Translit.getString("ID_EXIT"), style)));
		
			// Расшарить
			menuWnd.addComponent(new Position(265, 320), "btn_tweet", new Button("graphics/interface/tweet.swf", null, onTweetClick));
			menuWnd.addComponent(new Position(402, 318), "btn_facebook", new Button("graphics/interface/facebook.swf", null, onFacebookClick));
			
			function onTweetClick():void
			{
				Audio.playSound("sounds/share.mp3");
				Utils.shareTo("twitter", Translit.getString("ID_DESCRIPTION"), Main.gameUrl, "Little Natty");
			}
			
			function onFacebookClick():void
			{
				Audio.playSound("sounds/share.mp3");
				Utils.shareTo("facebook", Translit.getString("ID_DESCRIPTION"), Main.gameUrl, "Little Natty");
			}
			
			function onPlayClick():void
			{
				Audio.playSound("sounds/click.mp3");
				Game.destroyWindow(menuWnd);
				
				Main.showLoading();
				
				var lastScene:String = Game.load("scene");

				if (!lastScene) lastScene = "level_1";
				if (lastScene == "level_26") lastScene = "level_1";
				
				// ****************************************
				if (textF.text != "") lastScene = "level_" + textF.text;
				// ****************************************
				
				Game.loadScene("scenes/" + lastScene + ".scn");
			}
			
			function onOptionsClick():void
			{
				Audio.playSound("sounds/click.mp3");
				
				if (optionsWnd) return;
				
				optionsWnd = Game.loadWindow(new Position(), "options", null, "graphics/interface/options.swf");
				optionsWnd.addComponent(new Position(346, 360), "btn_ok", new Button("graphics/interface/button_other.swf", "graphics/interface/button_other_down.swf", onOkClick, new Text(Translit.getString("ID_OK"), style)));
				
				var opt:Object = { color:"#788E96", fontFamily:"Arial", fontSize:"16", width:"150" };
				
				optionsWnd.addComponent(new Position(374, 74), "text", new Text(Translit.getString("ID_OPTIONS"), opt));
				
				var btn_music:Button = Button(optionsWnd.addComponent(new Position(295, 140), "btn_music", new Button("graphics/interface/off.swf", "graphics/interface/on.swf", onMusicClick)));
				btn_music.addEventListener(ComponentEvent.COMPONENT_LOADED, onBtnMusicLoaded);
				
				function onBtnMusicLoaded(e:ComponentEvent):void
				{
					btn_music.removeEventListener(ComponentEvent.COMPONENT_LOADED, onBtnMusicLoaded);
					
					btn_music.buttonType = Button.BUTTON_TYPE_CHECK;
					btn_music.checked = Audio.canMusicPlay;
				}
				
				var btn_sound:Button = Button(optionsWnd.addComponent(new Position(295, 234), "btn_sound", new Button("graphics/interface/off.swf", "graphics/interface/on.swf", onSoundClick)));
				btn_sound.addEventListener(ComponentEvent.COMPONENT_LOADED, onBtnSoundLoaded);
				
				function onBtnSoundLoaded(e:ComponentEvent):void
				{
					btn_sound.removeEventListener(ComponentEvent.COMPONENT_LOADED, onBtnSoundLoaded);
					
					btn_sound.buttonType = Button.BUTTON_TYPE_CHECK;
					btn_sound.checked = Audio.canSoundPlay;
				}
				
				var txtStyle:Object = { color:"#000000", fontFamily:"Arial", fontSize:"32", width:"150" };
				
				optionsWnd.addComponent(new Position(384, 150), "txt_music", new Text(Translit.getString("ID_MUSIC"), txtStyle));
				optionsWnd.addComponent(new Position(384, 245), "txt_sound", new Text(Translit.getString("ID_SOUND"), txtStyle));				
				
				function onMusicClick():void
				{
					Audio.canMusicPlay = !Audio.canMusicPlay;
					
					if (!Audio.canMusicPlay) Audio.stopMusic();
				}
				
				function onSoundClick():void
				{
					Audio.canSoundPlay = !Audio.canSoundPlay;
				}
				
				function onOkClick():void
				{
					Audio.playSound("sounds/click.mp3");
					Game.destroyWindow(optionsWnd);
					
					optionsWnd = null;
				}
			}
			
			function onMoreClick():void
			{
				Audio.playSound("sounds/click.mp3");
				// Utils.goTo("http://feromonstudio.pp.ua/games.html?lng=" + Translit.currentLng);
				Game.save("scene", "level_1");
			}
			
			function onExitClick():void
			{
				Audio.playSound("sounds/click.mp3");
				Game.close();
			}
		}
		
		override protected function onDestroy(e:Event):void 
		{
			super.onDestroy(e);
		}
		
	}

}