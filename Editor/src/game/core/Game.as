package game.core
{	
	import flash.filesystem.File;
	import game.ui.*;
	import deng.fzip.FZipEvent;
	import deng.fzip.FZip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.*;
	import flash.display.StageAlign;
    import flash.display.StageScaleMode;
	import mx.core.UIComponent;
	import flash.system.ApplicationDomain;
	import flash.net.*;
	 
	import user.*;

	/**
	 * ...
	 * @author Monkgol
	 */	

	public class Game
	{
		// Архив игровых ресурсов
		[Embed(source = "/../assets/assets.zip",  mimeType="application/octet-stream")]
		public static var Assets:Class;
		
		public static var assets:FZip;
		public static var display:Display;
		public static var camera:Camera;	
		public static var scene:Scene;
		public static var ui:Ui;			
		
		// Опция относится к режиму редактирования а также игровому режиму
		// в режиме игры проверяется не включена ли пауза
		// в режиме редактирования тестируется ли сцена
		public static var isPlaying:Boolean;		
		
		public function Game(parent:Sprite, firstScene:String = "")
		{
			// Установка игрового режима если не установлен режим редактирования в Main.as
			if (!Project.isEditor()) Project.setProject(Project.GAME);			
			
			// Загрузить ресурсы в переменную assets
			if (Project.isGame()) 
			{
				assets = new FZip();
				assets.loadBytes(new Assets() as ByteArray);					
			}
			
			if (firstScene && Project.isGame())
			{
				var xmlScene:XML = new XML(new Source(firstScene).getSource());
				var script:String = xmlScene.@script;
				
				var sceneClass:Class;
				
				if(script != "") sceneClass =  getDefinitionByName("user." + script) as Class;
				
				scene = new (sceneClass ? sceneClass : Scene) (firstScene);
			} else if (Project.isEditor()) scene = new Scene();
			
			ui = new Ui();
			display = new Display(parent);
			camera = new Camera(scene);
			
			display.addChild(scene);
			display.addChild(camera);
			display.addChild(ui);
		}		

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Сохранение игры
		public static function saveGame():void
		{
			
		}
		
		// Загрузка игры
		public static function loadGame():void
		{
			
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Очистка сцены
		public static function emptyScene():void
		{
			if (scene) scene.emptyScene();
		}
		
		// Сохранение сцены
		public static function saveScene(file:File):void
		{			
			if (scene) scene.saveScene(file);
		}
		
		// Загрузка сцены 
		public static function loadScene(fileName:String):void
		{			
			if (Project.isGame())
			{
				var xmlScene:XML = new XML(new Source(fileName).getSource());
				var script:String = xmlScene.@script;
				
				var sceneClass:Class;
					
				if(script != "") sceneClass =  getDefinitionByName("user." + script) as Class;
					
				scene = new (sceneClass ? sceneClass : Scene) (fileName);
			} else if (Project.isEditor()) scene.loadScene(fileName);
		}		
		
		// Просчитать дирректорию, имя и номер сцены
		private static function calculateScene():Array
		{
			var sceneName:String = scene.source.fileName.slice(0, scene.source.fileName.length - 4);
			var sceneDir:String;
			
			for (var i:int = sceneName.length; i > 0; i--)
			{
				if (sceneName.charAt(i) == File.separator)
				{
					sceneDir = sceneName.slice(0, i) + File.separator;
					sceneName = sceneName.slice(i, sceneName.length);					
					break;
				}
			}
			
			var sceneNum:String;
			
			for (var n:int = 0; n < sceneName.length; n++)
			{
				if (sceneName.charAt(n) == "1" ||
					sceneName.charAt(n) == "2" ||
					sceneName.charAt(n) == "3" ||
					sceneName.charAt(n) == "4" ||
					sceneName.charAt(n) == "5" ||
					sceneName.charAt(n) == "6" ||
					sceneName.charAt(n) == "7" ||
					sceneName.charAt(n) == "8" ||
					sceneName.charAt(n) == "9" ||
					sceneName.charAt(n) == "0")
					{
						sceneNum = sceneName.slice(n, sceneName.length);
						sceneName = sceneName.slice(0, n);
					}
			}
			
			return new Array([sceneDir], [sceneName], [sceneNum]);
		}
		
		// Загрузка следующей сцены
		public static function nextScene():void
		{
			var sceneDir:String = calculateScene()[0];
			var sceneName:String = calculateScene()[1];
			var sceneNum:String = calculateScene()[2];			
			
			var nextScene:String =  sceneDir + sceneName + (String(int(sceneNum) + 1)) + ".scn";	
			
			scene.loadScene(nextScene);			
		}
		
		// Загрузка предидущей сцены
		public static function prevScene():void
		{
			var sceneDir:String = calculateScene()[0];
			var sceneName:String = calculateScene()[1];
			var sceneNum:String = calculateScene()[2];			
			
			var prevScene:String = sceneDir + sceneName + (String(int(sceneNum) - 1)) + ".scn";
			
			scene.loadScene(prevScene);
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Загрузка окна
		public static function loadWindow(position:Position, type:Class, fileName:String, name:String):Window
		{
			var window:Window = new (type ? type : Window)(fileName, name);
			
			ui.addChild(window);
			
			window.position = position;
			
			return window;
		}
		
		// Найти окно по имени
		public static function findWindow(name:String):Window
		{
			return ui.getWindowByName(name);
		}
		
		// Удалить окно
		public static function destroyWindow(window:Window):void
		{
			ui.removeChild(window);
		}
		
		// Скрыть окно
		public static function hideWindow(window:Window):void
		{
			window.hideWindow();
		}
		
		// Показать окно
		public static function showWindow(window:Window):void
		{
			window.showWindow();
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Пауза - продолжение игры
		public static function play():void
		{
			isPlaying = true;
		}
		
		// Пауза в игре
		public static function pause():void
		{
			isPlaying = false;
		}
		
		// Продолжить игру
		public static function resume():void
		{
			isPlaying = true;			
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Замедление времени
		public static function timeScale(scale:int):void
		{
			
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Выход из игры
		public static function close():void
		{
			
		}
		
	}
	
}