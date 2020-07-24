package
{
	import fl.motion.easing.Linear;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.Font;
	import flash.utils.ByteArray;
	import flash.utils.Timer;	
	import game.ui.Animation;
	import game.ui.Button;
	import game.ui.Component;
	import game.ui.Image;
	import game.ui.Text;
	import game.ui.Window;
	
	import user.*;
	import game.core.*;
	/**
	 * ...
	 * @author Monkgol
	 */
	
	public class Main extends Sprite 
	{
		//[Embed(source="C:\\arialuni.ttf", fontName="ArialUnicodeMS",  mimeType="application/x-font")]       
		//[Embed(source="C:\\WINDOWS\\Fonts\\Calibri.ttf", fontName="ArialUnicodeMS",  mimeType="application/x-font")]       
		//public static var ArialUnicodeMS:Class;
		
		public static var gameUrl:String = "https://play.google.com/store/apps/details?id=air.com.littlenatty";
		
		private static var loadingWnd:Window;

		public static var selectedFruit1:GameObject;
		public static var selectedFruit2:GameObject;
		
		public static var fruitsActive:Boolean;
		
		public static var dialogTextStyle:Object = { color:"#000000", fontFamily:"Arial", fontSize:"16", width:"190" };
		
		public static var interfaceWnd:Window;
		
		public static var timeMin:int;
		public static var timeSec:int;
		
		public static var wand:int;
		public static var step:int;
		
		public static var wandActive:Boolean;
		
		
		Scene1, Scene2, Scene3, Scene4, Scene5, Scene6, Scene7, Scene8, Scene9, Scene10, Scene11, Scene12, Scene13, Scene14, Scene15;
		Scene16, Scene17, Scene18, Scene19, Scene20, Scene21, Scene22, Scene23, Scene24, Scene25;
		
		DialogCrab1, DialogCrab2, DialogSlizen1, DialogSlizen2, DialogSlizen3, DialogPopugay1, DialogPopugay2, DialogPopugay3;
		
		Fruit, Natty, Exit, Menu, Key, Grog, Banan, Karta, Slides;
		
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			new Game(this, "scenes/menu.scn");
			
			fruitsActive = true;
		}
		
		// Подсветить текущюю активную
		public static function showActiveTarget(tag:String):void
		{
			var object:GameObject = Game.scene.getObjectByTag(tag);
			
			if (object)
			{
				var circles:ChildObject = object.addChildObject(new Position(), null, "graphics/effects/circles.swf", "circles");
				circles.addEventListener(ObjectEvent.OBJECT_LOADED, onCirclesLoaded);
				
				function onCirclesLoaded(e:ObjectEvent):void
				{
					circles.removeEventListener(ObjectEvent.OBJECT_LOADED, onCirclesLoaded);
					
					circles.playAnimation("idle", false, onPlayEnd);
					
					function onPlayEnd():void
					{
						object.removeChildObject(circles);
					}
				}
			}
		}
		
		// Показать экран загрузки
		public static function showLoading():void
		{
			var loadWnd:Window = Game.loadWindow(new Position(), "loading", null, "graphics/interface/loading.swf");
			
			loadWnd.addComponent(new Position(), "progress", new Animation("graphics/interface/progress.swf", "idle", false, onLoaded));
			
			function onLoaded():void
			{
				Game.destroyWindow(loadWnd);
			}
		}
		
		// Загрузить игровой интерфейс
		public static function loadInterface():void
		{
			if (Game.scene.getCurrentScene() != "level_1") Audio.playMusic("sounds/game_music.mp3", true);
			
			interfaceWnd = Game.loadWindow(new Position(), "interface", Interface, null);
			
			interfaceWnd.parent.setChildIndex(interfaceWnd, 0);
			
			var style:Object = { color:"#ffffff", fontFamily:"Arial", fontSize:"24", width:"150" };
			
			var btn_wand:Button = Button(interfaceWnd.addComponent(new Position(0, 0), "btn_wand", new Button("graphics/interface/wand.swf", "graphics/interface/wand_down.swf", onWandClick, null, "graphics/interface/wand_disabled.swf")));
			btn_wand.buttonType = Button.BUTTON_TYPE_CHECK;
			
			interfaceWnd.addComponent(new Position(340, 0), "img_step", new Image("graphics/interface/steps.swf"));
			interfaceWnd.addComponent(new Position(688, 0), "btn_menu", new Button("graphics/interface/btn_menu_scene.swf", null, onMenuClick, new Text(Translit.getString("ID_MENU"), style)));
			
			interfaceWnd.addComponent(new Position(58, 10), "txt_wand", new Text("", style));
			interfaceWnd.addComponent(new Position(400, 10), "txt_step", new Text("", style));			
			
			function onWandClick():void
			{
				if (wand > 0)
				{					
					wandActive = true;
					
					resetSelectedFruits();
					
					Audio.playSound("sounds/click.mp3");
				}
			}
			
			function onMenuClick():void
			{
				showLoading();
				
				if (Game.findWindow("level_end")) Game.destroyWindow(Game.findWindow("level_end"));
				
				Audio.playSound("sounds/click.mp3");
				
				Game.loadScene("scenes/menu.scn");
			}
		}
		
		// Установка ванда
		public static function setWand(value:int):void
		{
			wand = value;
			
			if (wand == 0)
			{
				var interfaceWnd:Window = Game.findWindow("interface");
				Button(interfaceWnd.getComponentByName("btn_wand")).enabled = false;
			}
			
			Text(Game.findWindow("interface").getComponentByName("txt_wand")).setText(value.toString());
		}
		
		// Установка степа
		public static function setStep(value:int):void
		{
			step = value;			
			
			Text(Game.findWindow("interface").getComponentByName("txt_step")).setText(value.toString());
			
			if (value == 0) Main.gameOver();
		}
		
		// Выгрузить игровой интерфейс
		public static function unloadInterface():void
		{
			Game.destroyWindow(interfaceWnd);
		}
		
		// Уровень проигран
		public static function gameOver():void
		{
			fruitsActive = false;
			
			Audio.playMusic("sounds/level_over.mp3");
			
			var completeWnd:Window = Game.loadWindow(new Position(), "level_end", null, "graphics/interface/level_end.swf");
			
			var btnStyle:Object = { color:"#ffffff", fontFamily:"Arial", fontSize:"16", width:"150" };
			
			completeWnd.addComponent(new Position(309, 293), "btn_menu", new Button("graphics/interface/button_other.swf", "graphics/interface/button_other_down.swf", onMenuClick, new Text(Translit.getString("ID_MENU"), btnStyle)));
			completeWnd.addComponent(new Position(414, 293), "btn_again", new Button("graphics/interface/button_other.swf", "graphics/interface/button_other_down.swf", onAgainClick, new Text(Translit.getString("ID_AGAIN"), btnStyle)));
			
			var txtStyle:Object = { color:"#000000", fontFamily:"Arial", fontSize:"36", width:"150" };
			
			var currentScene:Class = getCurrentSceneClass();			
			var usedSteps:int = currentScene(Game.scene).step - step;
			
			var dec:String = "";
				
			if (timeSec < 10) dec = "0";
			
			completeWnd.addComponent(new Position(387, 154), "txt_time", new Text(timeMin.toString() + " : " + dec + timeSec.toString(), txtStyle));
			completeWnd.addComponent(new Position(387, 216), "txt_step", new Text(usedSteps.toString(), txtStyle));
			
			var title:Object = { color:"#2E2F30", fontFamily:"Arial", fontSize:"24", width:"240" };
			
			completeWnd.addComponent(new Position(326, 104), "title", new Text(Translit.getString("ID_GAME_OVER"), title));
			
			// Перейти в меню
			function onMenuClick():void
			{
				Audio.playSound("sounds/click.mp3");
				fruitsActive = true;
				
				Game.destroyWindow(completeWnd);
				
				showLoading();
				
				Game.loadScene("scenes/menu.scn");				
			}
			
			// Играть снова
			function onAgainClick():void
			{
				Audio.playSound("sounds/click.mp3");
				fruitsActive = true;
				
				Game.destroyWindow(completeWnd);
				
				showLoading();
				
				Game.loadScene("scenes/" + Game.scene.name + ".scn");				
			}		
			
		}
		
		// Уровень пройден
		public static function levelCompleted():void
		{
			fruitsActive = false;
			
			Audio.stopAllSounds();
			
			if (Game.scene.getCurrentScene() == "level_25")
			{
				var slides:Window = Game.loadWindow(new Position(), "slides", Slides, "graphics/comix/sc_end_1.swf");
			} else
			{			
				Audio.playMusic("sounds/level_win.mp3");
				
				var completeWnd:Window = Game.loadWindow(new Position(), "level_end", null, "graphics/interface/level_end.swf");
				
				var btnStyle:Object = { color:"#ffffff", fontFamily:"Arial", fontSize:"16", width:"150" };
				
				completeWnd.addComponent(new Position(309, 293), "btn_again", new Button("graphics/interface/button_other.swf", "graphics/interface/button_other_down.swf", onAgainClick, new Text(Translit.getString("ID_AGAIN"), btnStyle)));
				completeWnd.addComponent(new Position(414, 293), "btn_next", new Button("graphics/interface/button_other.swf", "graphics/interface/button_other_down.swf", onNextClick, new Text(Translit.getString("ID_NEXT"), btnStyle)));
				
				var txtStyle:Object = { color:"#000000", fontFamily:"Arial", fontSize:"36", width:"150" };
				
				var currentScene:Class = getCurrentSceneClass();
				var usedSteps:int = currentScene(Game.scene).step - step;
				
				var dec:String = "";
				
				if (timeSec < 10) dec = "0";
				
				completeWnd.addComponent(new Position(387, 154), "txt_time", new Text(timeMin.toString() + " : " + dec + timeSec.toString(), txtStyle));
				completeWnd.addComponent(new Position(387, 216), "txt_step", new Text(usedSteps.toString(), txtStyle));
				
				var title:Object = { color:"#2E2F30", fontFamily:"Arial", fontSize:"24", width:"320" };
				
				completeWnd.addComponent(new Position(326, 104), "title", new Text(Translit.getString("ID_GAME_WIN"), title));
				
				// Играть снова
				function onAgainClick():void
				{
					Audio.playSound("sounds/click.mp3");
					fruitsActive = true;
					
					Game.destroyWindow(completeWnd);
					
					showLoading();
					
					Game.loadScene("scenes/" + Game.scene.name + ".scn");				
				}
				
				// Играть следующий левел
				function onNextClick():void
				{
					Audio.playSound("sounds/click.mp3");
					fruitsActive = true;
					
					Game.destroyWindow(completeWnd);
					
					showLoading();
					
					// Game.nextScene();
					
					var currentSceneNum:int = Game.calculateScene()[2];

					Game.loadScene("scenes/" + "level_" + Number(currentSceneNum + 1).toString() + ".scn");
				}
			}
			
			// Сохранение игры
			var currentSceneNum:int = Game.calculateScene()[2];
			
			Game.save("scene", "level_" + Number(currentSceneNum + 1).toString());
		}
		
		// Получить класс текущей сцены
		public static function getCurrentSceneClass():Class
		{
			var currentScene:Class;
			
			switch (Game.scene.name)
			{
				case "level_1": currentScene = Scene1;
				break;
				
				case "level_2": currentScene = Scene2;
				break;
				
				case "level_3": currentScene = Scene3;
				break;
				
				case "level_4": currentScene = Scene4;
				break;
				
				case "level_5": currentScene = Scene5;
				break;
				
				case "level_6": currentScene = Scene6;
				break;
				
				case "level_7": currentScene = Scene7;
				break;
				
				case "level_8": currentScene = Scene8;
				break;
				
				case "level_9": currentScene = Scene9;
				break;
				
				case "level_10": currentScene = Scene10;
				break;
				
				case "level_11": currentScene = Scene11;
				break;
				
				case "level_12": currentScene = Scene12;
				break;
				
				case "level_13": currentScene = Scene13;
				break;
				
				case "level_14": currentScene = Scene14;
				break;
				
				case "level_15": currentScene = Scene15;
				break;
				
				case "level_16": currentScene = Scene16;
				break;
				
				case "level_17": currentScene = Scene17;
				break;
				
				case "level_18": currentScene = Scene18;
				break;
				
				case "level_19": currentScene = Scene19;
				break;
				
				case "level_20": currentScene = Scene20;
				break;
				
				case "level_21": currentScene = Scene21;
				break;
				
				case "level_22": currentScene = Scene22;
				break;
				
				case "level_23": currentScene = Scene23;
				break;
				
				case "level_24": currentScene = Scene24;
				break;
				
				case "level_25": currentScene = Scene25;
				break;
			}
			
			return currentScene;
		}
		
		// Генерировать новый фрукт
		public static function generateFruit():String 
		{
			var newFruit:String;
			
			var fruitsLevel1:Array = new Array(["malina"], ["sliva"], ["vishnya"], ["kiwi"], ["klubnika"]);
			var fruitsLevel2:Array = new Array(["malina"], ["persik"], ["vishnya"], ["hurma"], ["klubnika"], ["apple"]);
			var fruitsLevel3:Array = new Array(["apelsin"], ["granat"], ["grusha"], ["malina"], ["persik"], ["sliva"]);
			var fruitsLevel4:Array = new Array(["abrikos"], ["ananas"], ["apple"], ["ezhevika"], ["hurma"], ["kiwi"]);
			var fruitsLevel5:Array = new Array(["kokos"], ["sliva"], ["vishnya"], ["banan"], ["apelsin"], ["malina"]);
			var fruitsLevel6:Array = new Array(["kokos"], ["granat"], ["grusha"], ["banan"], ["malina"], ["persik"]);
			var fruitsLevel7:Array = new Array(["ezhevika"], ["ananas"], ["grusha"], ["sliva"], ["granat"], ["banan"], ["apelsin"]);
			var fruitsLevel8:Array = new Array(["hurma"], ["kiwi"], ["lemon"], ["persik"], ["klubnika"], ["grusha"], ["kokos"], ["sliva"]);
			var fruitsLevel9:Array = new Array(["apelsin"], ["banan"], ["grusha"], ["hurma"], ["klubnika"], ["malina"], ["persik"], ["sliva"], ["vishnya"]);
			var fruitsLevel10:Array = new Array(["abrikos"], ["ananas"], ["apple"], ["ezhevika"], ["granat"], ["kiwi"], ["klubnika"], ["kokos"], ["sliva"], ["vishnya"]);
			var fruitsLevel11:Array = new Array(["grusha"], ["hurma"], ["lemon"], ["abrikos"], ["apelsin"], ["sliva"], ["malina"], ["ezhevika"], ["apple"], ["granat"]);
			var fruitsLevel12:Array = new Array(["ananas"], ["apelsin"], ["banan"], ["ezhevika"], ["granat"], ["hurma"], ["kiwi"], ["klubnika"], ["kokos"], ["persik"]);
			var fruitsLevel13:Array = new Array(["abrikos"], ["ananas"], ["apelsin"], ["apple"], ["hurma"], ["kiwi"], ["klubnika"], ["kokos"], ["lemon"], ["malina"], ["sliva"]);
			var fruitsLevel14:Array = new Array(["grusha"], ["abrikos"], ["ananas"], ["kiwi"], ["sliva"], ["persik"], ["malina"], ["kokos"], ["hurma"], ["lemon"], ["klubnika"]);
			var fruitsLevel15:Array = new Array(["abrikos"], ["ananas"], ["apelsin"], ["apple"], ["banan"], ["ezhevika"], ["granat"], ["hurma"], ["kiwi"], ["klubnika"], ["vishnya"]);
			var fruitsLevel16:Array = new Array(["vishnya"], ["sliva"], ["persik"], ["malina"], ["lemon"], ["kokos"], ["klubnika"], ["kiwi"], ["hurma"], ["grusha"], ["granat"], ["ezhevika"]);
			var fruitsLevel17:Array = new Array(["abrikos"], ["vishnya"], ["ananas"], ["sliva"], ["apelsin"], ["persik"], ["apple"], ["malina"], ["banan"], ["lemon"], ["ezhevika"], ["kokos"]);
			var fruitsLevel18:Array = new Array(["abrikos"], ["ananas"], ["apelsin"], ["apple"], ["ezhevika"], ["granat"], ["grusha"], ["hurma"], ["kiwi"], ["klubnika"], ["lemon"], ["sliva"]);
			var fruitsLevel19:Array = new Array(["ananas"], ["apelsin"], ["apple"], ["ezhevika"], ["granat"], ["hurma"], ["kiwi"], ["klubnika"], ["malina"], ["persik"], ["sliva"], ["vishnya"], ["kokos"]);
			var fruitsLevel20:Array = new Array(["ananas"], ["apelsin"], ["banan"], ["ezhevika"], ["granat"], ["grusha"], ["kiwi"], ["klubnika"], ["malina"], ["persik"], ["sliva"], ["vishnya"], ["kokos"]);
			var fruitsLevel21:Array = new Array(["vishnya"], ["sliva"], ["persik"], ["malina"], ["lemon"], ["kokos"], ["klubnika"], ["kiwi"], ["hurma"], ["apple"], ["granat"], ["ezhevika"], ["banan"]);
			var fruitsLevel22:Array = new Array(["abrikos"], ["ananas"], ["apelsin"], ["apple"], ["ezhevika"], ["granat"], ["hurma"], ["kiwi"], ["klubnika"], ["kokos"], ["lemon"], ["malina"], ["persik"], ["sliva"]);
			var fruitsLevel23:Array = new Array(["abrikos"], ["apelsin"], ["apple"], ["ezhevika"], ["granat"], ["grusha"], ["hurma"], ["kiwi"], ["klubnika"], ["lemon"], ["malina"], ["persik"], ["sliva"], ["vishnya"]);
			var fruitsLevel24:Array = new Array(["abrikos"], ["ananas"], ["apelsin"], ["grusha"], ["ezhevika"], ["granat"], ["hurma"], ["kiwi"], ["klubnika"], ["kokos"], ["lemon"], ["malina"], ["persik"], ["sliva"]);
			var fruitsLevel25:Array = new Array(["vishnya"], ["sliva"], ["persik"], ["malina"], ["lemon"], ["kokos"], ["klubnika"], ["kiwi"], ["hurma"], ["grusha"], ["granat"], ["banan"], ["apelsin"], ["ananas"], ["abrikos"], ["ezhevika"]);
			
			function randomFruits(fruits:Array):String
			{
				var i:int = Math.floor(Math.random() * fruits.length);
				
				return fruits[i];
			}
			
			switch (Game.scene.name)
			{
				case "level_1": newFruit = randomFruits(fruitsLevel1);
				break;
					
				case "level_2": newFruit = randomFruits(fruitsLevel2);
				break;
				
				case "level_3": newFruit = randomFruits(fruitsLevel3);
				break;
				
				case "level_4": newFruit = randomFruits(fruitsLevel4);
				break;
				
				case "level_5": newFruit = randomFruits(fruitsLevel5);
				break;
				
				case "level_6": newFruit = randomFruits(fruitsLevel6);
				break;
				
				case "level_7": newFruit = randomFruits(fruitsLevel7);
				break;
				
				case "level_8": newFruit = randomFruits(fruitsLevel8);
				break;
				
				case "level_9": newFruit = randomFruits(fruitsLevel9);
				break;
				
				case "level_10": newFruit = randomFruits(fruitsLevel10);
				break;
				
				case "level_11": newFruit = randomFruits(fruitsLevel11);
				break;
				
				case "level_12": newFruit = randomFruits(fruitsLevel12);
				break;
				
				case "level_13": newFruit = randomFruits(fruitsLevel13);
				break;
				
				case "level_14": newFruit = randomFruits(fruitsLevel14);
				break;
				
				case "level_15": newFruit = randomFruits(fruitsLevel15);
				break;
				
				case "level_16": newFruit = randomFruits(fruitsLevel16);
				break;
				
				case "level_17": newFruit = randomFruits(fruitsLevel17);
				break;
				
				case "level_18": newFruit = randomFruits(fruitsLevel18);
				break;
				
				case "level_19": newFruit = randomFruits(fruitsLevel19);
				break;
				
				case "level_20": newFruit = randomFruits(fruitsLevel20);
				break;
				
				case "level_21": newFruit = randomFruits(fruitsLevel21);
				break;
				
				case "level_22": newFruit = randomFruits(fruitsLevel22);
				break;
				
				case "level_23": newFruit = randomFruits(fruitsLevel23);
				break;
				
				case "level_24": newFruit = randomFruits(fruitsLevel24);
				break;
				
				case "level_25": newFruit = randomFruits(fruitsLevel25);
				break;
			}
			
			return newFruit;
		}
		
		// Поменять местами фрукты
		public static function changeFruitPosition(completed:Function):void
		{
			if (!selectedFruit1 || !selectedFruit2 || !fruitsActive) return;
			
			fruitsActive = false;
			
			var fruitName1:String = selectedFruit1 ? selectedFruit1.name : "";
			var fruitName2:String = selectedFruit2 ? selectedFruit2.name : "";
			
			selectedFruit2.name = fruitName1;
			selectedFruit1.name = fruitName2;
			
			var fruit2Position:Position = selectedFruit2.position;
			var fruit1Position:Position = selectedFruit1.position;
			
			selectedFruit2.moveTo(fruit1Position, 0.5, null, false, completed);			
			selectedFruit1.moveTo(fruit2Position, 0.5, null, false, null);			
		}
		
		// Выделить обьект
		public static function selectFruit(fruit:Fruit):void
		{
			selectedFruit1 = selectedFruit2;
			selectedFruit2 = fruit;
			
			selectedFruit2.addChildObject(new Position(0, 0), null, "graphics/interface/fruit_select.swf", "ramka");			
		}		
		
		// Снять выделение с первой фрукты
		public static function resetSelectedFruit1():void
		{
			if (selectedFruit1) 
			{
				var child:ChildObject = selectedFruit1.getChildObjectByName("ramka");
				child.addEventListener(ObjectEvent.OBJECT_DESTROYED, onDestroyed);
				
				selectedFruit1.removeChildObject(child);
				
				function onDestroyed(e:ObjectEvent):void
				{
					child = null;
					selectedFruit1 = null;
				}
			}
		}
		
		// Снять выделение со второй фрукты
		public static function resetSelectedFruit2():void
		{
			if (selectedFruit2) 
			{
				var child:ChildObject = selectedFruit2.getChildObjectByName("ramka");
				child.addEventListener(ObjectEvent.OBJECT_DESTROYED, onDestroyed);
				
				selectedFruit2.removeChildObject(child);
				
				function onDestroyed(e:ObjectEvent):void
				{
					child = null;
					selectedFruit2 = null;
				}
			}
		}
		
		// Обнулить первый выделенный обьект
		public static function resetSelectedFruits():void
		{	
			resetSelectedFruit1();
			resetSelectedFruit2();
		}
		
		public static function getSelectedFruit1():GameObject
		{
			return selectedFruit1 ? selectedFruit1 : null;
		}
		
		public static function getSelectedFruit2():GameObject
		{
			return selectedFruit2 ? selectedFruit2 : null;
		}
		
		// Находяться ли выделенные фрукты рядом
		public static function isSelectedFruitNearby():Boolean
		{
			var fruitName1:String = selectedFruit1 ? selectedFruit1.name : "";
			var fruitName2:String = selectedFruit2 ? selectedFruit2.name : "";
			
			if (!fruitName1 || !fruitName2) return false;
			
			if (fruitName1 == getUpFruit(fruitName2) ||
				fruitName1 == getDownFruit(fruitName2) ||
				fruitName1 == getLeftFruit(fruitName2) ||
				fruitName1 == getRightFruit(fruitName2))
			{
				return true;
			}
			
			resetSelectedFruit1();
			
			return false;
		}
		
		// Определение колонки рядка в имени Фрукта
		public static function getRowColNumber(fruitName:String, numberType:String):int
		{
			if (fruitName.charAt(0) != "f") return 0;	
			
			function isCharNumb(char:String):Boolean
			{
				if (char.charAt(0) == "1" ||
					char.charAt(0) == "2" ||
					char.charAt(0) == "3" ||
					char.charAt(0) == "4" ||
					char.charAt(0) == "5" ||
					char.charAt(0) == "6" ||
					char.charAt(0) == "7" ||
					char.charAt(0) == "8" ||
					char.charAt(0) == "9" ||
					char.charAt(0) == "0")
					{
						return true;
					}
					
				return false;
			}
			
			var numb:int;
			
			for (var n:int = 0; n < fruitName.length; n++)
			{
				if (isCharNumb(fruitName.charAt(n)))
				{
					fruitName = fruitName.slice(fruitName.indexOf("f_") + 2, fruitName.length);
					
					if (numberType == "row")
					{						
						if (isCharNumb(fruitName.charAt(1)))
						{
							numb = int(fruitName.slice(0, 2));
						} else numb = int(fruitName.slice(0, 1));
					} else if (numberType == "col")
					{
						fruitName = fruitName.slice(fruitName.indexOf("_") + 1, fruitName.length);
						
						if (isCharNumb(fruitName.charAt(1)))
						{
							numb = int(fruitName.slice(0, 2));
						} else numb = int(fruitName.slice(0, 1));
					}
					
					break;
				}
			}
			
			return numb;
		}
		
		// Подсчет рядка Фрукта
		public static function getFruitRow(fruitName:String):int
		{
			return getRowColNumber(fruitName, "row");
		}
		
		// Подсчет колонки фрукта
		public static function getFruitCol(fruitName:String):int
		{			
			return getRowColNumber(fruitName, "col");
		}
		
		// Взять фрукт выше
		public static function getUpFruit(fruitName:String):String
		{
			if (!fruitName) return "";
			
			var row:int = getFruitRow(fruitName) - 1;
			var col:int = getFruitCol(fruitName);
			
			// Если фрукты в крайнем положении соседняя фрукта равна null
			if (row <= 0 || col <= 0) return "";
			
			return String("f_" + row + "_" + col);
		}
		
		// Взять фрукт ниже
		public static function getDownFruit(fruitName:String):String
		{
			if (!fruitName) return "";			
			
			var row:int = getFruitRow(fruitName) + 1;
			var col:int = getFruitCol(fruitName);
			
			// Если фрукты в крайнем положении соседняя фрукта равна null
			if (row <= 0 || col <= 0) return "";
			
			return String("f_" + row + "_" + col);
		}
		
		// Взять фрукт левее
		public static function getLeftFruit(fruitName:String):String
		{
			if (!fruitName) return "";			
			
			var row:int = getFruitRow(fruitName);
			var col:int = getFruitCol(fruitName) - 1;
			
			// Если фрукты в крайнем положении соседняя фрукта равна null
			if (row <= 0 || col <= 0) return "";
			
			return String("f_" + row + "_" + col);
		}
		
		// Взять фрукт правее
		public static function getRightFruit(fruitName:String):String
		{	
			if (!fruitName) return "";
			
			var row:int = getFruitRow(fruitName);
			var col:int = getFruitCol(fruitName) + 1;
			
			// Если фрукты в крайнем положении соседняя фрукта равна null
			if (row <= 0 || col <= 0) return "";
			
			return String("f_" + row + "_" + col);
		}
		
	}
	
}