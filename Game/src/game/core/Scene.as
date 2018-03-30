package game.core 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	import flash.utils.*;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;	
	import nape.geom.Vec2;
	import nape.space.Space;
	import nape.util.ShapeDebug;
	
	import user.*;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Scene extends Sprite	
	{
		// name наследуется от Sprite
		public var source:Source;
		public var script:String;

		private var _scale:Number;
		
		public var grid:Grid;
		
		public var backLayer:Layer;
		public var gameLayer:Layer;
		public var frontLayer:Layer;		

		public var activeLayer:Layer;
		
		public var space:Space;	
		public var debug:ShapeDebug;
		
		public var gameObjects:Vector.<GameObject>;
		public var prefabs:Vector.<Prefab>;
		
		public var fileName:String;
		
		public function Scene(fileName:String = null) 
		{
			this.script = "";
			this.fileName = fileName;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);

			source = new Source();
			
			gameObjects = new Vector.<GameObject>;
			prefabs = new Vector.<Prefab>;	
			
			backLayer = new Layer();
			backLayer.name = "backLayer";
			
			gameLayer = new Layer();
			gameLayer.name = "gameLayer";
			
			frontLayer = new Layer();
			frontLayer.name = "frontLayer";
			
			addChild(backLayer);
			addChild(gameLayer);
			addChild(frontLayer);
			
			activeLayer = gameLayer;			
		}
		
		// Имя текущей сцены
		public function getCurrentScene():String
		{
			return name;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// События связанные со сценой
		private function onAddedToStage(e:Event):void
		{			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			addEventListener(Event.RESIZE, onResize);
			addEventListener(SceneEvent.SCENE_LOADED, onCreate);
			
			if (fileName) loadScene(fileName); else dispatchEvent(new SceneEvent(SceneEvent.SCENE_LOADED));
		}
		
		protected function onCreate(e:SceneEvent):void
		{  
			removeEventListener(SceneEvent.SCENE_LOADED, onCreate);	
			
			// Создать сетку
			/*grid = new Grid(this);
			addChildAt(grid, 0);
			
			// Создать мир физики
			space = new Space(new Vec2(0, 80));
			debug = new ShapeDebug(600,600);
			addChild(debug.display);*/
			
			addEventListener(Event.ENTER_FRAME, onUpdate);
		}		
		
		protected function onResize(e:Event):void 
		{			
			grid.removeGrid();
			grid.createGrid();
		}
		
		protected function onDestroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			removeEventListener(Event.ENTER_FRAME, onUpdate);	
			
			//removeEventListener(Event.RESIZE, onResize);
		}		
		
		protected function onUpdate(e:Event):void
		{			
			/*space.step(1 / stage.frameRate);
			
			debug.clear();
			debug.draw(space);
			debug.flush();	*/		
		}	
		
		// Установить активный слой
		public function setActiveLayer(layer:Layer):void
		{			
			activeLayer = layer;			

			/*if (grid) 
			{
				setChildIndex(grid, getChildIndex(activeLayer) - 1);
			}*/
		}
		
		public function getActiveLayer():Layer
		{
			return activeLayer;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Сетка
		public function enableGrid():void
		{
			if (!grid.enabled) grid.createGrid();
		}
		
		public function disableGrid():void
		{
			if (grid.enabled) grid.removeGrid();
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Загрузка сцены, следующая, предидущая
		public function emptyScene():void
		{
			script = "";
			name = "";
			
			for each (var gameObject:GameObject in gameObjects)
			{
				if (gameObject)
				{
					destroyObject(gameObject);
					gameObject = null;
				}
			}
			
			for each (var prefab:Prefab in prefabs)
			{
				if (prefab)
				{
					removePrefab(prefab);
					prefab = null;
				}
			}
			
			backLayer.removeChildren();
			gameLayer.removeChildren();
			frontLayer.removeChildren();			
		}
		
		// Сохранение сцены
		public function saveScene(file:File):void
		{
			var xmlScene:XML =	new XML(<scene />);
			xmlScene.@script = script;
			xmlScene.@name = name.search("instance") != 0 ? name :  "";//setSceneName(file.name);
			
			var xmlObjects:XML = new XML(<objects />);
			
			var xmlFrontLayer:XML = new XML(<frontLayer />);
			var xmlGameLayer:XML = new XML(<gameLayer />);
			var xmlBackLayer:XML = new XML(<backLayer />);
			
			xmlObjects.appendChild(xmlFrontLayer);
			xmlObjects.appendChild(xmlGameLayer);
			xmlObjects.appendChild(xmlBackLayer);
			
			var xmlPrefabs:XML = new XML(<prefabs />);	
			
			// Заменить сепараторы на обратные, используемые в UNIX - "/"
			function replaceSeparators(path:String):String
			{
				function replace(path:String):String
				{
					return path.replace(/\\/, "/");
				}
				
				for (var n:int = 0; n < path.length; n++)
				{
					if (path.charAt(n) == "\\")
					{
						path = replace(path);					
					}				
				}
				
				return path;
			}
				
			// Сохранение обьектов
			for each (var gameObject:GameObject in gameObjects)
			{
				if (gameObject)
				{
					var xmlObject:XML = new XML(<object />);
					
					xmlObject.@name = gameObject.name;
					xmlObject.@tag = gameObject.tag;
					xmlObject.@type = gameObject.type;
					
					// Сохранение центра обьекта
					gameObject.relativeCenter ? xmlObject.@center = "true" : xmlObject.@center = "false";
					
					// Сохранение связанного префаба
					if (gameObject.prefab) xmlObject.@prefab = gameObject.prefab.name; else xmlObject.@prefab = "";									
					
					// Сохранение имени ресурса
					xmlObject.@fileName = replaceSeparators(gameObject.fileName);
					
					// Позиция обьекта
					xmlObject.@xPosition = gameObject.x;
					xmlObject.@yPosition = gameObject.y;
					
					// Ротация, скалирование
					xmlObject.@rotation = gameObject.rotation;
					xmlObject.@scale = gameObject.scale;
					
					// Индекс положения относительно других обьектов
					xmlObject.@index = gameObject.parent.getChildIndex(gameObject);
					
					switch (gameObject.parent.name)
					{
						case "frontLayer": xmlFrontLayer.appendChild(xmlObject);
							break;
						
						case "gameLayer": xmlGameLayer.appendChild(xmlObject);
							break;
							
						case "backLayer": xmlBackLayer.appendChild(xmlObject);
							break;
					}					
				}
			}	
				
			// Сохраниние префабов
			for each (var prefab:Prefab in prefabs)
			{
				if (prefab)
				{
					var xmlPrefab:XML = new XML(<prefab />);
					
					xmlPrefab.@name = prefab.name;					
					xmlPrefab.@tag = prefab.tag;
					xmlPrefab.@type = prefab.type;
					
					xmlPrefab.@fileName = replaceSeparators(prefab.fileName);
					
					xmlPrefab.@scale = prefab.scale;
					
					xmlPrefabs.appendChild(xmlPrefab);
				}
			}
			
			xmlScene.appendChild(xmlObjects);
			xmlScene.appendChild(xmlPrefabs);				
			
			var xmlDocument:XMLDocument = new XMLDocument();
			xmlDocument.parseXML(xmlScene.toXMLString());			
			
			var fileStream:FileStream = new FileStream(); 
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeMultiByte(String(xmlDocument), "iso-8859-1");
			fileStream.close();			
		}		
		
		// Именовать сцену автоматически
		public function setSceneName(fileName:String):String
		{
			var sceneName:String = fileName.slice(0, fileName.length - 4);
			
			for (var i:int = sceneName.length; i > 0; i--)
			{
				if (sceneName.charAt(i) == File.separator || sceneName.charAt(i) == "/")
				{
					sceneName = sceneName.slice(i + 1, sceneName.length);					
					break;
				}
			}
			
			return sceneName;
		}
		
		// Загрузка сцены
		public function loadScene(fileName:String):void
		{
			emptyScene();
			
			source.setSource(fileName);			
			
			/*var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSceneDataLoaded);		
			
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			loaderContext.allowLoadBytesCodeExecution = true;		
			
			loader.loadBytes(source.getSource(), loaderContext);
			
			function onSceneDataLoaded(e:Event):void
			{ 
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onSceneDataLoaded);*/
			
			var xmlBytes:ByteArray = source.getSource();
			if (!xmlBytes) throw new Error("Scene " + fileName + " not found in assets.zip");
				
			var xmlScene:XML = new XML(xmlBytes);
			script = xmlScene.@script;
			name = xmlScene.@name != "" ? xmlScene.@name : setSceneName(fileName);
			
			// Заменить сепараторы на обратные, используемые в Windows - "\"
			function replaceSeparators(path:String):String
			{
				function replace(path:String):String
				{
					return path.replace("/", "\\");
				}
				
				for (var n:int = 0; n < path.length; n++)
				{
					if (path.charAt(n) == "/")
					{
						path = replace(path);					
					}				
				}
				
				return path;
			}
			
			// Считывание префабов
			for each (var prefab:XML in xmlScene.prefabs.*)
			{
				var newPrefab:Prefab = addPrefab(prefab.@type, replaceSeparators(prefab.@fileName), prefab.@name, prefab.@tag);
				
				newPrefab.scale = prefab.@scale;
			}			
			
			// Загрузка обьекта
			function loadObject(object:XML):void
			{
				var type:Class = null;
				
				// Создание экземпляра класса согласно типу в игре
				if (object.@type != "" && Project.isGame()) type = getDefinitionByName("user." + object.@type) as Class;			
				
				var gameObject:GameObject = createObject(new Position(object.@xPosition, object.@yPosition), type, Project.isEditor() ? replaceSeparators(object.@fileName) : object.@fileName, object.@name, object.@tag);
				gameObject.addEventListener(ObjectEvent.OBJECT_LOADED, onObjectLoaded);
				
				// Обьект загружен на сцену
				function onObjectLoaded(e:ObjectEvent):void
				{
					gameObject.removeEventListener(ObjectEvent.OBJECT_LOADED, onObjectLoaded);
					
					// Установка типа обьекта в редакторе
					if (Project.isEditor()) gameObject.type = object.@type;	
					
					// Установка центра обьекта, по умолчанию ценр установлен
					if (object.@center == "false") gameObject.relativeCenter = false;
					
					// Установка ротации и скалирования обьекта
					gameObject.rotation = object.@rotation;
					gameObject.scale = object.@scale;
					
					// Привязка обьекта к префабу
					if (object.@prefab != "")	gameObject.prefab = getPrefab(object.@prefab);	
					
					// Расположение относительно других обьектов
					var index:int = int(object.@index);
					gameObject.parent.setChildIndex(gameObject, index);
					
					// Счетчик загруженных обьектов на сцену
					objectsLoaded += 1;					
					
					if (objectsLoaded == totalObjects)
					{
						setActiveLayer(gameLayer);
						dispatchEvent(new SceneEvent(SceneEvent.SCENE_LOADED));
					}
				}				
			}
			
			var xmlFrontLayer:XMLList = xmlScene.objects.frontLayer.*;
			var frontLayerLength:int = xmlFrontLayer.length();
			
			var xmlGameLayer:XMLList = xmlScene.objects.gameLayer.*;
			var gameLayerLength:int = xmlGameLayer.length();
			
			var xmlBackLayer:XMLList = xmlScene.objects.backLayer.*;
			var backLayerLength:int = xmlBackLayer.length();
			
			var objectsLoaded:int = 0;
			var totalObjects:int = frontLayerLength + gameLayerLength + backLayerLength;				
			
			// Загрузка обьектов Заднего слоя
			setActiveLayer(backLayer);
			
			for (var i:int = 0; i < backLayerLength; i++)
			{
				for each (var object0:XML in xmlBackLayer)
				{
					if (object0.@index == i)
					{
						loadObject(object0);
					}
				}				
			}
			
			// Загрузка обьектов Игрового слоя
			setActiveLayer(gameLayer);
			
			for (var n:int = 0; n < gameLayerLength; n++)
			{
				for each (var object1:XML in xmlGameLayer)
				{
					if (object1.@index == n)
					{
						loadObject(object1);
					}
				}
			}
			
			// Загрузка обьектов Фронтального слоя
			setActiveLayer(frontLayer);
			
			for (var j:int = 0; j < frontLayerLength; j++)
			{
				for each (var object2:XML in xmlFrontLayer)
				{
					if (object2.@index == j)
					{
						loadObject(object2);
					}
				}
			}
			
			//}
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Работа с обьектами
		public function createObject(position:Position,
													   type:Class = null,
													   fileName:String = null,			   
													   name:String = null,
													   tag:String = null):GameObject
		{			
			var gameObject:GameObject = new ((type && Project.isGame()) ? type : GameObject)(fileName, name, tag);			
		
			gameObjects.push(gameObject);
			
			activeLayer.addChild(gameObject);
			
			/*gameObject.position.x = position.x;
			gameObject.position.y = position.y;*/
			
			gameObject.position = position;
			
			return gameObject;
		}		
		
		// Создание обьекта на подобии префаба
		public function createObjectFromPrefab(prefab:Prefab,
																		  position:Position,																  
													                      name:String = null):GameObject
		{
			var type:Class;
			
			if (prefab.type && Project.isGame()) type = getDefinitionByName("user." + prefab.type) as Class;
			
			var gameObject:GameObject = new ((type && Project.isGame()) ? type : GameObject)(prefab.fileName, name, prefab.tag);
			
			gameObjects.push(gameObject);
			
			activeLayer.addChild(gameObject);
			
			/*gameObject.position.x = position.x;
			gameObject.position.y = position.y;*/
			
			gameObject.position = position;
			
			gameObject.scale = prefab.scale;
			
			return gameObject;
		}
		
		// Удаоение обьекта
		public function destroyObject(object:GameObject):void
		{
			if (object)
			{
				object.deactivate();
			
				if (object.body) space.bodies.remove(object.body);			
			
				var i:int = 0;
				for each(var currentObject:GameObject in gameObjects)
				{
					if (currentObject == object) 
					{
						gameObjects[i] = null;
						break;
					}
					i++;
				}
			
				object.parent.removeChild(object);

				object = null;
			}
		}
		
		// Удаление обьектов
		public function destroyObjects(...objects):void
		{
			if (objects[0] is Vector.<GameObject>)
			{
				for each (var objectInVector:GameObject in objects[0])
				{
					if (objectInVector) destroyObject(objectInVector);
				}
			} else
			if (objects[0] is GameObject) 
			{			
				for each (var object:GameObject in objects)
				{
					if (object) destroyObject(object);
				}
			}
		}
		
		// Получить обьект по имени
		public function getObjectByName(name:String):GameObject
		{
			if (!name) return null;
			
			for each(var currentObject:GameObject in gameObjects)
			{
				if (currentObject && currentObject.name == name) return currentObject;				
			}			
			
			return null;
		}
		
		// Получить обьект по тагу
		public function getObjectByTag(tag:String):GameObject
		{
			if (!tag) return null;
			
			for each(var currentObject:GameObject in gameObjects)
			{
				if (currentObject && currentObject.tag == tag) return currentObject;				
			}
			
			return null;
		}
		
		// Получить обьекты по тагу
		public function getTaggedObjects(tag:String):Vector.<GameObject>
		{
			if (!tag) return null;
			
			var vector:Vector.<GameObject> = new Vector.<GameObject>;
			
			for each (var currentObject:GameObject in gameObjects)
			{
				if (currentObject && currentObject.tag == tag) vector.push(currentObject);
			}
			
			if (vector.length > 0) return vector; else return null;
		}		
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Создать префаб
		public function addPrefab(type:String = null,
												   fileName:String = null,
												   name:String = null,
												   tag:String = null):Prefab
		{
			var prefab:Prefab = new Prefab(type, fileName, name, tag);
			
			prefabs.push(prefab);
			
			return prefab;
		}
		
		// Удалить префаб
		public function removePrefab(prefab:Prefab):void
		{
			var i:int = 0;
			for each (var currentPrefab:Prefab in prefabs)
			{				
				if (currentPrefab == prefab)
				{
					prefabs[i] = null;
					break;
				}				
				i++;
			}
			
			// Отсоединить все обьекты от данного префаба
			for each (var gameObject:GameObject in gameObjects)
			{
				if (gameObject && gameObject.prefab == prefab) gameObject.prefab = null;
			}
			
			prefab = null;
		}
		
		// Взять префаб
		public function getPrefab(name:String):Prefab
		{
			for each(var currentPrefab:Prefab in prefabs)
			{
				if (currentPrefab && currentPrefab.name == name) return currentPrefab;				
			}			
			
			return null;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Установка свойств
		public function setResolution(width:int, height:int):void
		{
			
		}		
		
		public function get scale():Number 
		{
			return _scale;
		}
		
		public function set scale(value:Number):void 
		{
			_scale = value;
			this.scaleX = this.scaleY = value;
		}

	}

}