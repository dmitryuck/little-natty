package editor
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TransformGestureEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	import mx.containers.Accordion;
	import mx.containers.Box;
	import mx.containers.HBox;
	import mx.containers.Panel;
	import mx.containers.TabNavigator;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.Label;
	import mx.controls.List;
	import mx.controls.Text;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.controls.Tree;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.managers.DragManager;
	import spark.components.DropDownList;
	import game.core.GameObject;
	
	import game.core.*;
	import editor.*;

	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Inspector extends Panel
	{
		public var object:PreObject;		
		
		public var tab:TabNavigator;
		
		public var objects:Box;
		public var properties:Box;
		public var prefabs:Box;
		
		public var lbl_name:Label;
		public var lbl_tag:Label;
		public var lbl_type:Label;
		public var lbl_file:Label;
		public var lbl_prefab:Label;
		public var lbl_position:Label;
		public var lbl_x:Label;
		public var lbl_y:Label;
		public var lbl_rotation:Label;
		public var lbl_scale:Label;		
		
		public var chkb_center:CheckBox;
		
		public var cmb_type:ComboBox;		
		public var lst_assets:Tree;
		public var lst_objects:List;
		public var lst_prefabs:List
		
		public var txt_name:TextInput;
		public var txt_tag:TextInput;
		public var txt_x:TextInput;
		public var txt_y:TextInput;
		public var txt_rotation:TextInput;
		public var txt_scale:TextInput;
		
		public var btn_file:Button;		
		public var btn_connect:Button;
		public var btn_revert:Button;
		public var btn_apply:Button;
		
		public var btn_add_prefab:Button;
		public var btn_remove_prefab:Button;
		public var btn_remove_object:Button;
		
		public var classList:Array;
		
		public var objectWaitForConnect:Boolean;
		
		public function Inspector()
		{
			isPopUp = true;
			title = "Inspector";
			x = 570;
			y = 40;
			width = 220;
			height = 480;		
			
			Main.transformManager.addEventListener(TransformEvent.ON_FOCUS, onObjectFocus);
			Main.transformManager.addEventListener(TransformEvent.ON_TRANSFORM, onObjectTransform);

			createTabs();
			
			updateAssetsList();
		}		
		
		// Обьект в процессе трансформации
		private function onObjectTransform(e:TransformEvent):void 
		{
			if (object)
			{
				txt_x.text = object.x.toString();
				txt_y.text = object.y.toString();				
				
				object.rotation = Math.round(object.rotation / 0.01) * 0.01;
				object.scale = Math.round(object.scaleX / 0.01) * 0.01;
				
				txt_rotation.text = object.rotation.toString();
				txt_scale.text = object.scale.toString();
				
				if (Game.scene.grid && Game.scene.grid.enabled)
				{
					var point:Point = Game.scene.grid.getNearestPoint(object.x, object.y);
					
					object.x = point.x;
					object.y = point.y;
					
					// Обновить положение рамки редактирования после перемещения по сетке
					Main.transformManager.updateAfterChange();
				}
			}
		}
		
		// Обьект выделен
		private function onObjectFocus(e:TransformEvent):void 
		{			
			// Загрузка обьекта			
			loadObject(e.targetObject as GameObject);
			tab.selectedIndex = 1;
		}
		
		// Установка типа обьекта
		public function setObjectType():void
		{
			for (var i:int = 0; i < classList.length; i++)
			{
				if (!object.type) cmb_type.selectedIndex = 0; else
				if (object.type == classList[i]) cmb_type.selectedIndex = i;
			}
		}
		
		// Загрузить выделенный обьект
		public function loadObject(object:PreObject):PreObject
		{
			this.object = object;
			
			txt_name.enabled = true;
			txt_tag.enabled = true;
			
			txt_name.text = (object.name != "null") ? object.name : "";
			txt_tag.text = (object.tag != "null") ? object.tag : "";			
			
			// Включить список классов
			cmb_type.enabled = true;			
			
			txt_scale.enabled = true;			
			txt_scale.text = object.scale.toString();
			
			setObjectType();
			
			btn_file.enabled = true;
			btn_file.label = object.fileName;
			
			if (object is GameObject)
			{
				lst_objects.selectedItem = object;
				
				chkb_center.enabled = true;
				GameObject(object).relativeCenter ? chkb_center.selected = true : chkb_center.selected = false;
				
				txt_x.enabled = true;
				txt_y.enabled = true;
				
				txt_x.text = object.x.toString();				
				txt_y.text = object.y.toString();
				
				if (!btn_connect.enabled) btn_connect.enabled = true;
				
				if (GameObject(object).prefab)
				{
					btn_connect.label = "Disconnect";
					btn_apply.enabled = true;
					btn_revert.enabled = true;
				}  else
				{
					btn_connect.label = "Connect";
					btn_apply.enabled = false;
					btn_revert.enabled = false;
				}
				
				txt_rotation.enabled = true;
				txt_rotation.text = object.rotation.toString();
				
				return GameObject(object);
				
			} else if (object is Prefab)
			{
				btn_connect.enabled = false;
				
				chkb_center.enabled = false;
				
				txt_x.text = "";				
				txt_y.text = "";
				
				txt_x.enabled = false;
				txt_y.enabled = false;
				
				btn_connect.label = "Connect";
				btn_apply.enabled = false;
				btn_revert.enabled = false;
				
				txt_rotation.text = "";
				txt_rotation.enabled = false;
				
				return Prefab(object);
			}	
			
			return null;
		}
		
		// Выгрузить загруженный обьект
		public function nullObject():void
		{
			this.object = null;
			
			txt_name.text = "";
			txt_tag.text = "";
			
			txt_name.enabled = false;
			txt_tag.enabled = false;
			
			cmb_type.selectedIndex = 0;
			cmb_type.enabled = false;
			
			btn_file.label = "";
			btn_file.enabled = false;
			
			chkb_center.enabled = false;
			
			btn_connect.enabled = false;
			btn_apply.enabled = false;
			btn_revert.enabled = false;
			
			if (!txt_x.enabled) txt_x.enabled = true;
			if (!txt_y.enabled) txt_y.enabled = true;
			
			txt_x.text = "";
			txt_y.text = "";
			
			txt_x.enabled = false;
			txt_y.enabled = false;
			
			txt_rotation.text = "";
			txt_scale.text = "";
			
			txt_rotation.enabled = false;
			txt_scale.enabled = false;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Update section
		
		// Обновить список обьектов сцены
		public function updateSceneList():void
		{
			var sceneList:Array = new Array();
			
			var i:int = 0;
			for each (var object:GameObject in Game.scene.gameObjects)
			{
				if (object) 
				{
					var name:String;
					if (object.name) name = object.name; else name = "gameObject";
					sceneList[i] = { label:name, data:object };
					
					i++;
				}				
			}
			
			lst_objects.dataProvider = sceneList;
		}

		// Обновить список ассетов
		public function updateAssetsList():void
		{			
			// Заполнение списка ассетов
			var assetsPath:File = new File(Project.projectPath + "assets" + File.separator);
			var assetsListFullPath:Array = Editor.getFilesInDir(assetsPath);
			
			var assetsList:XMLList = new XMLList(<assets/>);
			assetsList.@label = "Assets";
			
			for (var i:int = 0; i < assetsListFullPath.length; i++)
			{
				var file:File = new File(assetsListFullPath[i]);
				
				var fileName:String = file.name;				
				var filePath:String = assetsListFullPath[i].slice(assetsListFullPath[i].indexOf("assets") + 7, assetsListFullPath[i].length);
				
				var xmlPath:XML = null;
				var currentXmlFolder:XML = null; 
				
				var slicedFilePath:String = filePath;			
				
				for (var n:int = 0; n < slicedFilePath.length; n++)
				{
					if (slicedFilePath.charAt(n) == File.separator)
					{
							var label:String = slicedFilePath.slice(0, n);
								
							var xmlFolder:XML = new XML(<folder/>);
							xmlFolder.@label = label;						
								
							if (!xmlPath)
							{
								xmlPath = new XML(<folder/>);								
								xmlPath = xmlFolder;							
								
								for each(var folder:XML in assetsList.folder)
								{									
									if (folder.@label == label)
									{
										currentXmlFolder = new XML(<folder/>);
										currentXmlFolder = folder;
									}
								}
								
								if (!currentXmlFolder)
								{
									currentXmlFolder = new XML(<folder/>);
									currentXmlFolder = xmlFolder;
									
									assetsList.appendChild(xmlPath);
								}								
							} 
							else
							{
								var found:Boolean = false;
								
								for each(var subFolder:XML in currentXmlFolder.folder)
								{									
									if (subFolder.@label == label)
									{										
										currentXmlFolder = subFolder;
										found = true;
									}
								}								
								
								if (!found)
								{
									currentXmlFolder.appendChild(xmlFolder);
									currentXmlFolder = xmlFolder;
								}								
							}
								
							slicedFilePath = slicedFilePath.slice(n + 1, slicedFilePath.length);
							n = 0;
					}
				}				
				
				var xmlFile:XML = new XML(<file/>);				
				xmlFile.@label = fileName;
				xmlFile.@data = filePath;
				
				if (xmlPath)
				{					
					currentXmlFolder.appendChild(xmlFile);					
				} else
				{
					assetsList.appendChild(xmlFile);
				}
			}
			
			lst_assets.dataProvider = assetsList;
		}
		
		// Обновление списка префабов
		public function updatePrefabsList():void
		{
			var prefabsList:Array = new Array();
			
			var i:int = 0;
			for each (var prefab:Prefab in Game.scene.prefabs)
			{
				if (prefab)
				{
					var name:String;
					if (prefab.name) name = prefab.name; else name = "prefab";
					prefabsList[i] = { label:name, data:prefab };
					
					i++;
				}				
			}
			
			lst_prefabs.dataProvider = prefabsList;
		}
		
		// Обновить свойства обьекта
		public function updateProperties():void
		{
			if (object)
			{				
				txt_name.text = (object.name != "null") ? object.name : "";
				txt_tag.text = (object.tag != "null") ? object.tag : "";
				
				setObjectType();
				
				txt_x.text = object.x.toString();
				txt_y.text = object.y.toString();				
				
				txt_rotation.text = object.rotation.toString();
				txt_scale.text = object.scale.toString();
			} else nullObject();
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Создать вкладки
		public function createTabs():void
		{
			createObjects();
			createProperties();
			createPrefabs();
			
			tab = new TabNavigator();
			//tab.autoLayout = true;
			tab.width = 216;
			tab.height = 446;
			
			tab.addElement(objects);
			tab.addElement(properties);
			tab.addElement(prefabs);
			
			addElement(tab);
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Создать вкладку Обьекты
		public function createObjects():void
		{
			objects = new Box();
			objects.label = "Objects";			
			
			btn_remove_object = new Button();
			btn_remove_object.addEventListener(MouseEvent.CLICK, onRemoveObjectClick);
			btn_remove_object.label = "Remove";
			
			var object_box:HBox = new HBox();
			object_box.addElement(btn_remove_object);
			
			lst_objects = new List();
			lst_objects.width = 210;
			lst_objects.height = 340;
			lst_objects.addEventListener(KeyboardEvent.KEY_DOWN, onObjectsListKeyDown);
			lst_objects.addEventListener(MouseEvent.MOUSE_DOWN, onObjectsListMouseDown);
			lst_objects.addEventListener(MouseEvent.MIDDLE_CLICK, onObjectsListMiddleClick);
			
			var scene_box:Box = new Box();			
			scene_box.label = "Scene";
			scene_box.addElement(object_box);
			scene_box.addElement(lst_objects);
			
			lst_assets = new Tree();
			lst_assets.width = 210;
			lst_assets.height = 368;
			lst_assets.dragEnabled = true;
			lst_assets.labelField = "@label";
			lst_assets.addEventListener(MouseEvent.MOUSE_DOWN, onAssetsListMouseDown);
			
			var assets_box:Box = new Box();			
			assets_box.label = "Assets";
			assets_box.addElement(lst_assets);
			
			var acd_objects:Accordion = new Accordion();
			acd_objects.addElement(scene_box);
			acd_objects.addElement(assets_box);
			
			objects.addElement(acd_objects);
		}		
		
		private function onObjectsListMiddleClick(e:MouseEvent):void 
		{
			/*if (e.target is TextField)
			{
				removeObject(GameObject(lst_objects.selectedItem.data));
				updateSceneList();
			}*/
		}
		
		// Выбор обьекта из списка обьектов сцены
		private function onObjectsListMouseDown(e:MouseEvent):void 
		{
			if (lst_objects.selectedItem)
			{				
				loadObject(lst_objects.selectedItem.data);	
				tab.selectedIndex = 1;
				
				// Выделить обьект на сцене
				if (Main.transformManager.getDispObj() != object) Main.transformManager.activateSprite(object);
			}			
		}
		
		// Создать обьект
		public function createObject(object:GameObject):GameObject
		{			
			object.addEventListener(MouseEvent.MOUSE_DOWN, onObjectMouseDown);
			object.addEventListener(MouseEvent.MOUSE_UP, onObjectMouseUp);
			
			Main.transformManager.registerSprite(object);	
			
			updateSceneList();
			return object;
		}
		
		// Удаление обьекта
		public function removeObject(object:GameObject):void
		{			
			object.removeEventListener(MouseEvent.MOUSE_DOWN, onObjectMouseDown);
			object.removeEventListener(MouseEvent.MOUSE_UP, onObjectMouseUp);
			
			Main.transformManager.unRegisterSprite(object);
			
			Game.scene.destroyObject(object);
			
			updateSceneList();
			nullObject();
		}
		
		// Удалить обьект со сцены нажав кнопку удалить
		private function onRemoveObjectClick(e:MouseEvent):void 
		{
			if (lst_objects.selectedItem)
			{				
				removeObject(lst_objects.selectedItem.data);					
			}			
		}		
		
		// Удалить выбранный обьект из списка и сцены
		private function onObjectsListKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.DELETE && lst_objects.selectedItem)
			{
				removeObject(lst_objects.selectedItem.data);
			}
		}		
		
		private function onAssetsListMouseDown(e:MouseEvent):void 
		{
			if (e.target is TextField && lst_assets.selectedItem.@data)
			{
				// Создать обьект с ассета				
				loadObject(createObject(Game.scene.createObject(new Position(0, 0), null, String(lst_assets.selectedItem.@data))));				
				
				Main.game.setFocus();
			}
		}
		
		private function onObjectMouseUp(e:MouseEvent):void 
		{
			if (object)
			{
				if (Game.scene.grid && Game.scene.grid.enabled)
				{
					var point:Point = new Point();
					point = Game.scene.grid.getNearestPoint(object.x, object.y);						
				}					
			}
		}
		
		private function onObjectMouseDown(e:MouseEvent):void 
		{
			
		}		
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Создать вкладку Префабы
		public function createPrefabs():void
		{
			prefabs = new Box();
			prefabs.label = "Prefabs";			
			
			btn_add_prefab = new Button();
			btn_add_prefab.addEventListener(MouseEvent.CLICK, onAddPrefabClick);
			btn_add_prefab.label = "Add";
			
			btn_remove_prefab = new Button();
			btn_remove_prefab.addEventListener(MouseEvent.CLICK, onRemovePrefabClick);
			btn_remove_prefab.label = "Remove";
			
			var prefab_box:HBox = new HBox();
			prefab_box.addElement(btn_add_prefab);
			prefab_box.addElement(btn_remove_prefab);
			
			lst_prefabs = new List();
			lst_prefabs.width = 214;
			lst_prefabs.height = 384;
			lst_prefabs.dragEnabled = true;			
			lst_prefabs.addEventListener(KeyboardEvent.KEY_DOWN, onPrefabsListKeyDown);
			lst_prefabs.addEventListener(MouseEvent.MOUSE_DOWN, onPrefabsListMouseDown);
			
			prefabs.addElement(prefab_box);
			prefabs.addElement(lst_prefabs);
		}		
		
		// Добавить префаб
		private function onAddPrefabClick(e:MouseEvent):void 
		{
			Game.scene.addPrefab();
			updatePrefabsList();
		}
		
		// Удалить выделенный префаб нажав на кнопку Удалить префаб
		private function onRemovePrefabClick(e:MouseEvent):void 
		{
			if (lst_prefabs.selectedItem)
			{
				Game.scene.removePrefab(lst_prefabs.selectedItem.data);
				updatePrefabsList();
				nullObject();
			}			
		}
		
		// Удалить выделенный префаб нажав клавишу DELETE
		private function onPrefabsListKeyDown(e:KeyboardEvent):void 
		{			
			if (e.keyCode == Keyboard.DELETE && lst_prefabs.selectedItem)
			{
				Game.scene.removePrefab(lst_prefabs.selectedItem.data);
				updatePrefabsList();
				nullObject();
			}			
		}		
		
		// Выбор префаба
		private function onPrefabsListMouseDown(e:MouseEvent):void 
		{
			if (lst_prefabs.selectedItem && object is GameObject && objectWaitForConnect)
			{
				GameObject(object).connectToPrefab(Prefab(lst_prefabs.selectedItem.data));
				
				//Alert.show("Object " + (object.name ? object.name : "gameObject") + " was connected to prefab " + lst_prefabs.selectedItem.label);
				
				btn_apply.enabled = true;
				btn_revert.enabled = true;
				
				objectWaitForConnect = false;
				
				tab.selectedIndex = 1;
				
				updateProperties();
			} else if (lst_prefabs.selectedItem && Prefab(lst_prefabs.selectedItem.data).fileName) 
			{				
				// Создать обьект из префаба
				GameObject(loadObject(createObject(Game.scene.createObjectFromPrefab(lst_prefabs.selectedItem.data, new Position(0, 0))))).connectToPrefab(lst_prefabs.selectedItem.data);		
			} else if (lst_prefabs.selectedItem && lst_prefabs.selectedItem.data)
			{
				loadObject(lst_prefabs.selectedItem.data);
			}
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Создать вкладку Свойства
		public function createProperties():void
		{
			properties = new VBox();
			properties.label = "Properties";
			
			// Name
			lbl_name = new Label();
			lbl_name.text = "Name";
			lbl_name.x = 10;
			lbl_name.y = 10;
			
			txt_name = new TextInput();
			txt_name.addEventListener(KeyboardEvent.KEY_DOWN, onNameChange);
			txt_name.width = 80;
			txt_name.x = 50;
			
			var name_box:HBox = new HBox();
			name_box.addElement(lbl_name);
			name_box.addElement(txt_name);
			
			properties.addElement(name_box);
			
			// Tag
			lbl_tag = new Label();
			
			lbl_tag.text = "Tag";
			lbl_tag.x = 10;
			lbl_tag.y = 40;
			
			txt_tag = new TextInput();
			txt_tag.addEventListener(KeyboardEvent.KEY_DOWN, onTagChange);
			txt_tag.width = 80;
			
			var tag_box:HBox = new HBox();
			tag_box.addElement(lbl_tag);
			tag_box.addElement(txt_tag);
			
			properties.addElement(tag_box);
			
			// Type
			lbl_type = new Label();
			lbl_type.text = "Class";
			
			cmb_type = new ComboBox();			
			cmb_type.addEventListener(Event.CHANGE, onTypeChange);			
			
			// Заполнение списка пользовательских классов
			var path:File = new File(Project.projectPath + "src" + File.separator + "user" + File.separator);
			classList = Editor.getFilesInDir(path);				
			
			for (var i:int = 0; i < classList.length; i++)
			{
				var file:File = new File(classList[i]);
				var className:String = file.name.slice(0, file.name.length - 3);
				classList[i] = className;
			}
			
			classList.unshift("");
			cmb_type.dataProvider = classList;			
			
			var type_box:HBox = new HBox();
			type_box.addElement(lbl_type);
			type_box.addElement(cmb_type);
			
			properties.addElement(type_box);
			
			// File
			lbl_file = new Label();
			lbl_file.text = "File";
			
			btn_file = new Button();
			btn_file.addEventListener(MouseEvent.CLICK, onBtnFileClick);
			
			var file_box:HBox = new HBox();
			file_box.addElement(lbl_file);
			file_box.addElement(btn_file);
			
			properties.addElement(file_box);
			
			// Prefab
			lbl_prefab = new Label();
			lbl_prefab.text = "Prefab";
			lbl_prefab.x = 0;
			lbl_prefab.y = 60;
			
			btn_connect = new Button();			
			btn_connect.addEventListener(MouseEvent.CLICK, onBtnConnectClick);
			btn_connect.width = 80;
			btn_connect.label = "Connect";
			
			var prefab_box:HBox = new HBox();
			prefab_box.addElement(lbl_prefab);
			prefab_box.addElement(btn_connect);
			
			properties.addElement(prefab_box);
			
			// Revert/Apply
			btn_revert = new Button();
			btn_revert.addEventListener(MouseEvent.CLICK, onBtnRevertClick);
			btn_revert.label = "Revert";
			btn_revert.width = 80;
			
			btn_apply = new Button();
			btn_apply.addEventListener(MouseEvent.CLICK, onBtnApplyClick);
			btn_apply.label = "Apply";
			btn_apply.width = 80;
			
			var revert_apply_box:HBox = new HBox();
			revert_apply_box.addElement(btn_revert);
			revert_apply_box.addElement(btn_apply);
			
			properties.addElement(revert_apply_box);
			
			// Center
			chkb_center = new CheckBox();
			chkb_center.label = "Relative center";
			chkb_center.selected = true;
			chkb_center.addEventListener(MouseEvent.CLICK, onCenterClick);
			
			var center_box:HBox = new HBox();
			center_box.addElement(chkb_center);
			
			properties.addElement(center_box);
			
			// Position
			lbl_position = new Label();
			lbl_position.text = "Position";
			
			lbl_x = new Label();
			lbl_x.text = "X";
			
			lbl_y = new Label();
			lbl_y.text = "Y";
			
			txt_x = new TextInput();
			txt_x.addEventListener(KeyboardEvent.KEY_DOWN, onXChange);
			txt_x.width = 40;
			
			txt_y = new TextInput();
			txt_y.addEventListener(KeyboardEvent.KEY_DOWN, onYChange);
			txt_y.width = 40;
			
			var position_box:HBox = new HBox();
			position_box.addElement(lbl_position);
			position_box.addElement(lbl_x);
			position_box.addElement(txt_x);
			position_box.addElement(lbl_y);
			position_box.addElement(txt_y);
			
			properties.addElement(position_box);
			
			// Rotation
			lbl_rotation = new Label();
			lbl_rotation.text = "Rotation";
			
			txt_rotation = new TextInput();
			txt_rotation.addEventListener(KeyboardEvent.KEY_DOWN, onRotationChange);
			txt_rotation.width = 80;
			
			var rotation_box:HBox = new HBox();
			rotation_box.addElement(lbl_rotation);
			rotation_box.addElement(txt_rotation);
			
			properties.addElement(rotation_box);
			
			// Scale
			lbl_scale = new Label();
			lbl_scale.text = "Scale";
			
			txt_scale = new TextInput();
			txt_scale.addEventListener(KeyboardEvent.KEY_DOWN, onScaleChange);
			txt_scale.width = 80;
			
			var scale_box:HBox = new HBox();
			scale_box.addElement(lbl_scale);
			scale_box.addElement(txt_scale);
			
			properties.addElement(scale_box);
			
			nullObject();
		}	
		
		// Изменение центра обьекта
		private function onCenterClick(e:MouseEvent):void 
		{
			if (object)
			{
				if (chkb_center.selected) GameObject(object).relativeCenter = true;
				else GameObject(object).relativeCenter = false;
			}
		}
		
		// Выбор файла ресурсов
		private function onBtnFileClick(e:MouseEvent):void 
		{
			var file:File = new File(Project.projectPath + File.separator + "assets" + File.separator);
			file.addEventListener(Event.SELECT, onFileSelect);
			file.browseForOpen("Select source...");
			
			function onFileSelect(e:Event):void
			{
				file.removeEventListener(Event.SELECT, onFileSelect);
				
				var fileName:String = file.nativePath.slice(file.nativePath.indexOf("assets") + 7, file.nativePath.length);
				
				object.fileName = fileName;
				
				if (object is GameObject) GameObject(object).setSource(fileName);
				
				btn_file.label = file.name;
			}
		}
		
		// Применить изменения к префабу
		private function onBtnApplyClick(e:MouseEvent):void 
		{
			if (object is GameObject && GameObject(object).prefab)
			{
				GameObject(object).applyChanges();
			}
		}
		
		// Вернуть изменения соответсввующие префабу
		private function onBtnRevertClick(e:MouseEvent):void 
		{
			if (object is GameObject && GameObject(object).prefab)
			{
				GameObject(object).revertChanges();
				
				// Обновить размер рамки редактирования после применения реверта с префаба
				Main.transformManager.updateAfterChange();
				
				updateProperties();
			}
		}
		
		// Нажата кнопка присоединить префаб 
		private function onBtnConnectClick(e:MouseEvent):void 
		{
			if (object && !GameObject(object).prefab && objectWaitForConnect)
			{
				objectWaitForConnect = false;
				btn_connect.label = "Connect";
			} else if (!GameObject(object).prefab)
			{
				objectWaitForConnect = true;
				btn_connect.label = "Disconnect";
				tab.selectedIndex = 2;
			} else if (GameObject(object).prefab)
			{
				GameObject(object).disconnectFromPrefab();
				btn_connect.label = "Connect";
				btn_apply.enabled = false;
				btn_revert.enabled = false;
			}
		}
		
		// Изменить тип обьекта
		private function onTypeChange(e:Event):void 
		{
			if (object)
			{
				object.type = cmb_type.selectedItem as String;
			}
		}
		
		// Изменить величину скале обьекта
		private function onScaleChange(e:KeyboardEvent):void
		{
			if (object && e.keyCode == Keyboard.ENTER)
			{
				object.scale = Number(txt_scale.text);
				Main.transformManager.updateAfterChange();
				properties.setFocus();
			}
		}
		
		// Изменить ротацию обьекта
		private function onRotationChange(e:KeyboardEvent):void
		{
			if (object is GameObject && e.keyCode == Keyboard.ENTER)
			{
				object.rotation = Number(txt_rotation.text);
				Main.transformManager.updateAfterChange();
				properties.setFocus();
			}
		}
		
		// Изменить положение обьекта по У
		private function onYChange(e:KeyboardEvent):void
		{
			if (object is GameObject && e.keyCode == Keyboard.ENTER)
			{
				object.y = Number(txt_y.text);
				Main.transformManager.updateAfterChange();
				properties.setFocus();
			}
		}
		
		// Изменить положение обьекта по Х
		private function onXChange(e:KeyboardEvent):void
		{
			if (object is GameObject && e.keyCode == Keyboard.ENTER)
			{
				object.x = Number(txt_x.text);
				Main.transformManager.updateAfterChange();
				properties.setFocus();
			}
		}
		
		// Изменить таг обьекта
		private function onTagChange(e:KeyboardEvent):void
		{
			if (object && e.keyCode == Keyboard.ENTER)
			{
				object.tag = txt_tag.text;
				properties.setFocus();
			}
		}
		
		// Изменить имя обьекта
		private function onNameChange(e:KeyboardEvent):void
		{
			if (object && e.keyCode == Keyboard.ENTER)
			{
				object.name = txt_name.text;
				properties.setFocus();
				
				if (object is GameObject) updateSceneList(); else updatePrefabsList();
			}
		}		
	
	}

}