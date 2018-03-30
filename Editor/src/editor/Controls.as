package editor 
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.net.FileFilter;
	import game.core.Source;
	import mx.containers.ApplicationControlBar;
	import mx.containers.HBox;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.ButtonBar;
	import mx.controls.ComboBox;
	import mx.events.FlexMouseEvent;
	import mx.managers.PopUpManager;
	import mx.containers.TitleWindow;
	
	import user.Robot;
	import editor.Inspector;	
	import game.core.*;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Controls extends ApplicationControlBar 
	{		
		public var btn_new:Button;
		public var btn_open:Button;
		public var btn_save:Button;
		
		public var btn_grid:Button;
		
		public var btn_duplicate:Button;
		public var btn_positione:Button;
		
		public var btn_options:Button;
		public var btn_pack:Button;
		
		public var cmb_layer:ComboBox;
		
		
		public function Controls()
		{			
			btn_new = new Button();
			btn_new.addEventListener(MouseEvent.CLICK, onNewClick);
			btn_new.width = 60;
			btn_new.label = "New";
			
			btn_open = new Button();
			btn_open.addEventListener(MouseEvent.CLICK, onOpenClick);
			btn_open.width = 60;
			btn_open.label = "Open";
			
			btn_save = new Button();
			btn_save.addEventListener(MouseEvent.CLICK, onSaveClick);
			btn_save.width = 60;
			btn_save.label = "Save";
			
			btn_grid = new Button();
			btn_grid.width = 60;
			btn_grid.addEventListener(MouseEvent.CLICK, onGridClick);
			btn_grid.label = "Grid";
			
			cmb_layer = new ComboBox();
			cmb_layer.addEventListener(Event.CHANGE, onLayerChange);
			
			var layer_list:Array = new Array(["Front layer"], ["Game layer"], ["Back layer"]);
			cmb_layer.dataProvider = layer_list;
			
			cmb_layer.selectedIndex = 1;
			
			btn_duplicate = new Button();
			btn_duplicate.addEventListener(MouseEvent.CLICK, onDuplicateClick);
			btn_duplicate.label = "Duplicate";
			
			btn_positione = new Button();
			btn_positione.addEventListener(MouseEvent.CLICK, onPositioneClick);
			btn_positione.label = "Positione";
			
			btn_options = new Button();
			btn_options.addEventListener(MouseEvent.CLICK, onOptionsClick);
			btn_options.label = "Options";
			
			btn_pack = new Button();
			btn_pack.addEventListener(MouseEvent.CLICK, onPackClick);
			btn_pack.width = 60;
			btn_pack.label = "Pack";			
			
			var menu_box:HBox = new HBox();
			menu_box.addElement(btn_new);
			menu_box.addElement(btn_open);
			menu_box.addElement(btn_save);
			menu_box.addElement(btn_grid);
			menu_box.addElement(cmb_layer);
			menu_box.addElement(btn_duplicate);
			menu_box.addElement(btn_positione);
			menu_box.addElement(btn_options);
			menu_box.addElement(btn_pack);
			
			addElement(menu_box);
		}
		
		// Выбор активного слоя
		private function onLayerChange(e:Event):void 
		{
			// Снять выделение с выделенного обьекта
			Main.transformManager.deactivateSprite();
			Main.inspector.nullObject();
			
			switch (cmb_layer.selectedIndex)
			{
				case 0: Game.scene.setActiveLayer(Game.scene.frontLayer);
					break;
				
				case 1: Game.scene.setActiveLayer(Game.scene.gameLayer);
					break;
					
				case 2: Game.scene.setActiveLayer(Game.scene.backLayer);
					break;
			}			
		}
		
		// Окно опций сцены
		private function onOptionsClick(e:MouseEvent):void 
		{			
			var options:TitleWindow = TitleWindow(PopUpManager.createPopUp(this, Options, true));
			
			options.label = "Options";
			options.showCloseButton = true;
			options.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, onOptionsClose);
			
			//PopUpManager.centerPopUp(Main.inspector);
			
			function onOptionsClose(e:FlexMouseEvent):void
			{
				options.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, onOptionsClose);
				PopUpManager.removePopUp(options);
			}			
		}
		
		// Запаковать ресурсы в архив
		private function onPackClick(e:MouseEvent):void
		{
			Editor.packAssets();			
		}
		
		private function onPositioneClick(e:MouseEvent):void 
		{
			
		}
		
		// Дублировать обьект
		private function onDuplicateClick(e:MouseEvent):void 
		{
			
		}
		
		// Сохранить сцену
		private function onSaveClick(e:MouseEvent):void 
		{
			var file:File = new File(Project.projectPath + File.separator + "assets" + File.separator);			
			file.browseForSave("Save scene as...");
			
			file.addEventListener(Event.SELECT, onFileSave);
			
			function onFileSave(e:Event):void
			{
				file.removeEventListener(Event.SELECT, onFileSave);				
				
				Game.saveScene(file);
			}			
		}
		
		// Открыть сцену
		private function onOpenClick(e:MouseEvent):void 
		{
			var file:File = new File(Project.projectPath + File.separator + "assets" + File.separator);
			
			var fileFilter:FileFilter = new FileFilter("Scene file", "*.scn");			
			file.browseForOpen("Load scene...", [fileFilter]);
			
			file.addEventListener(Event.SELECT, onFileSelect);
			
			function onFileSelect(e:Event):void
			{
				file.removeEventListener(Event.SELECT, onFileSelect);				
				
				var fileName:String = file.nativePath.slice(file.nativePath.indexOf("assets") + 7, file.nativePath.length);
			
				Game.scene.addEventListener(SceneEvent.SCENE_LOADED, onSceneLoaded);
				//Game.scene.addEventListener(ProgressEvent.PROGRESS, onSceneLoadingProgress);
				
				Game.loadScene(fileName);
				
				/*function onSceneLoadingProgress(e:ProgressEvent):void
				{
					Game.scene.removeEventListener(ProgressEvent.PROGRESS, onSceneLoadingProgress);
					
					var pcent:Number = e.bytesLoaded / e.bytesTotal * 100;
					
					trace(e.bytesLoaded);
				}*/
				
				function onSceneLoaded(e:SceneEvent):void
				{
					Game.scene.removeEventListener(SceneEvent.SCENE_LOADED, onSceneLoaded);
					
					// Сделать все обьекты трансформируемыми
					for each (var gameObject:GameObject in Game.scene.gameObjects)
					{
						if (gameObject)
						{							
							Main.inspector.createObject(gameObject);
						}						
					}
					
					Main.inspector.updateSceneList();
					Main.inspector.updatePrefabsList();
				}				
			}			
		}
		
		// Новая сцена
		private function onNewClick(e:MouseEvent):void 
		{
			Game.emptyScene();			
			
			Main.inspector.updateSceneList();
			Main.inspector.updatePrefabsList();
			
			Main.inspector.nullObject();
			
			Main.inspector.updateProperties();
		}
		
		// Показать\ Скрыть сетку
		private function onGridClick(e:MouseEvent):void 
		{			
			//if (!Game.scene.grid) Game.scene.onSceneLoaded();
			
			if (Game.scene.grid.enabled) Game.scene.grid.removeGrid();
			else Game.scene.grid.createGrid();
		}
		
	}

}