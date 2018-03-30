package game.core 
{	
	import com.flashdynamix.motion.Tweensy;
	import com.flashdynamix.motion.TweensySequence;
	import com.flashdynamix.motion.TweensyTimeline;
	import fl.motion.easing.Linear;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import game.ui.Animation;
	import nape.shape.Shape;
	
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import game.utils.Geom;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	
	public class GameObject extends PreObject
	{
		private var active:Boolean;
		private var _relativeCenter:Boolean;
		
		public var prefab:Prefab;		
		public var group:Group;
		
		public var source:Source;		
		
		public var animationController:AnimationController;
		public var tween:TweensySequence;
		public var body:Body;		
		
		// Обьект отображения текущего игрового обьекта
		public var displayObject:DisplayObject;	
		
		private var loader:Loader;
		
		
		public function GameObject(fileName:String = "", name:String = "", tag:String = "") 
		{
			super(fileName, name, tag);
			
			position = new Position();			
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);			
			
			source = new Source(fileName);			
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Добавление, удаление листенеров
		private function addListeners():void
		{
			addEventListener(Event.ENTER_FRAME, onUpdate);			
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function removeListeners():void
		{
			removeEventListener(Event.ENTER_FRAME, onUpdate);			
			removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// События связанные с обьектом
		protected function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
			
			addEventListener(ObjectEvent.OBJECT_LOADED, onCreate);
			
			if (fileName) loadDisplayObject(); else dispatchEvent(new ObjectEvent(ObjectEvent.OBJECT_LOADED));
		}
		
		protected function onCreate(e:ObjectEvent):void
		{
			removeEventListener(ObjectEvent.OBJECT_LOADED, onCreate);
			addListeners();
		}
		
		protected function onDestroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			removeListeners();
			
			dispatchEvent(new ObjectEvent(ObjectEvent.OBJECT_DESTROYED));
		}
		
		protected function onUpdate(e:Event):void
		{
			
		}
		
		protected function onClick(e:MouseEvent):void
		{		
			
		}		
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Отобразить обьект ресурса
		public function loadDisplayObject():void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDisplayObjectLoaded);
			//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onDisplayObjectProgress);
				
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			loaderContext.allowLoadBytesCodeExecution = true;			
				
			loader.loadBytes(source.getSource(), loaderContext);
		}
		
		// Прцесс загрузки обьекта отображения
		/*private function onDisplayObjectProgress(e:ProgressEvent):void 
		{
			
		}*/
		
		private function onDisplayObjectLoaded(e:Event):void
		{	
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onDisplayObjectLoaded);
			
			// Если тело меняет ресурс, то удалить тело и перерисовать новое
			if (displayObject) removeChild(displayObject);			
			
			switch (source.getSourceType())
			{
				// Загрузка SWF формата
				case Source.SOURCE_TYPE_FLASH:
					if (MovieClip(e.target.content).totalFrames > 1)
					{
						displayObject = addChildAt(e.target.content, 0) as MovieClip;
						MovieClip(displayObject).stop();
					} else displayObject = addChildAt(e.target.content, 0) as Sprite;
					
					displayObject.cacheAsBitmap = true;
					displayObject.cacheAsBitmapMatrix = new Matrix();
				break;
				
				// Загрузка растрового изображения
				case Source.SOURCE_TYPE_RASTER:
					displayObject = addChild(e.target.content) as Bitmap;
				break;
				
				case Source.SOURCE_TYPE_VECTOR:
					//displayObject = addChild(e.target.content) as Sprite;
				break;
				
				default:
					throw new Error("Source type is not a display object!");
				break;
			}
			
			relativeCenter = true;
			
			dispatchEvent(new ObjectEvent(ObjectEvent.OBJECT_LOADED));
		}
		
		public function setCenter():void
		{
			displayObject.x = displayObject.width / 2 * ( -1);
			displayObject.y = displayObject.height / 2 * ( -1);
		}
		
		public function setCorner():void
		{
			displayObject.x = 0;
			displayObject.y = 0;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Управление анимацией
		// Проиграть анимацию
		public function playAnimation(frameLabel:String, loop:Boolean = true, onEnd:Function = null):void
		{
			if (displayObject is MovieClip)
			{				
				if (!animationController) animationController = new AnimationController(MovieClip(displayObject));
				
				if (loop) animationController.playLoop(frameLabel, onEnd); else animationController.play(frameLabel, onEnd);
			}
		}
		
		// Остановить проигрываемую анимацию
		public function stopAnimation():void
		{
			//if (animationController) {
				//trace("works only with trace()");
				animationController.stop();
			//}
		}
		
		// Сделать обьект верхним
		public function sendToFront():void
		{
			this.parent.setChildIndex(this, this.parent.numChildren - 1);
		}
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Движение обьекта		
		public function moveTo(position:Position, duration:Number = 1, ease:Function = null, autoRotation:Boolean = true, onComplete:Function = null, ...nextPosition):void
		{			
			if (!tween) tween = new TweensySequence(); 
			else 
			{
				tween.dispose();
				tween = null;
				tween = new TweensySequence();
			}			
			
			if (nextPosition.length == 0) tween.push(this, { x:position.x, y:position.y, rotation:autoRotation ? Geom.rotateToPoint(this.rotation, this.position, position) : 0 }, duration, ease, 0, 0, null, onComplete);
			else
			{
				var rotation0:Number = autoRotation ? Geom.rotateToPoint(this.rotation, this.position, position) : 0;
				tween.push(this, { x:position.x, y:position.y, rotation:rotation0 }, duration, ease);
				
				var positionLength:int = nextPosition.length;
				
				var rotation:Array = new Array();
				
				for (var i:int = 0; i < positionLength; i++)
				{
					rotation[i] = autoRotation ? Geom.rotateToPoint(i == 0 ? rotation0 : rotation[i - 1], i > 0 ? nextPosition[i - 1] : position, nextPosition[i]) : 0;
					
					if (i < positionLength - 1)
					{
						tween.push(this, { x:nextPosition[i].x, y:nextPosition[i].y, rotation:rotation[i] }, duration, ease);				
					}
					else if (i == positionLength - 1)
					{
						tween.push(this, { x:nextPosition[i].x, y:nextPosition[i].y, rotation:rotation[i] }, duration, ease, 0, 0, null, onComplete);					
					}
				}
			}
			
			tween.start();
		}
		
		// Остановить движение обьекта
		public function stopMove():void
		{
			if (tween) tween.stop();
		}
		
		// Поставить на паузу движение
		public function pauseMove():void
		{
			if (tween) tween.pause();
		}
		
		// Продолжить преостановленное движение
		public function resumeMove():void
		{
			if (tween && tween.paused) tween.resume();
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Установить новый ресурс отображения для обьекта displayObject
		public function setSource(fileName:String):void
		{
			if (source)
			{
				source.setSource(fileName);
			} else {
				source = new Source(fileName);	
			}
			
			this.fileName = fileName;
			
			loadDisplayObject();
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Child - добавление удаление, показ скрытие		
		public function addChildObject(position:Position,
														   type:Class = null,													   
													       fileName:String = "",													   
													       name:String = ""):ChildObject
		{
			var child:ChildObject = new (type ? type : ChildObject)(fileName, name);			
			
			this.addChild(child);
			
			child.position = position;
			
			return child;
		}
		
		// Удалить дочерный обьект
		public function removeChildObject(child:ChildObject):void
		{			
			child.parent.removeChild(child);
			
			child = null;
		}
		
		// Получить дочерный обьект по имени
		public function getChildObjectByName(name:String):ChildObject
		{
			//if (!name) return null;			
			
			return ChildObject(this.getChildByName(name));
		}
		
		// Показать дочерный обьект
		public function showChild(child:ChildObject):void
		{
			if (child && !child.visible) child.visible = true;
		}
		
		// Спрятать дочерный обьект
		public function hideChild(child:ChildObject):void
		{
			if (child && child.visible) child.visible = false;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Управление видимостью обьекта		
		public function showObject():void
		{
			if (displayObject && !displayObject.visible) displayObject.visible = true;
		}
		
		public function hideObject():void
		{
			if (displayObject && displayObject.visible) displayObject.visible = false;
		}		

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Активность игрового обьекта		
		// Активировать обьект
		public function activate():void
		{
			if (!isActive())
			{
				active = true;				
				loadDisplayObject();
				addListeners();
			}
		}
		
		// Деактивировать обьект
		public function deactivate():void
		{
			if (isActive())
			{
				active = false;		
				removeListeners();
				removeChildren();								
				displayObject = null;				
			}
		}		
		
		// Проверка активен ли обьект
		public function isActive():Boolean
		{
			return active;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Работа с префабом
		// Применить изменения ко всем обьектам присоединенным к префабу
		public function applyChanges():void
		{
			with (prefab)
			{
				type = this.type;
				tag = this.tag;				
				
				scale = this.scale;	
				
				fileName = this.fileName;	
				
				update(this);
			}			
		}
		
		// Установить свойства обьекта скопировав их с присоединенного префаба
		public function revertChanges():void
		{
			with (prefab)
			{
				this.type = type;
				this.tag = tag;				
				
				this.scale = scale;
				
				this.fileName = fileName;
				
				this.setSource(fileName);				
			}
		}
		
		// Присоединить обьект к префабу
		public function connectToPrefab(prefab:Prefab):void
		{
			this.prefab = prefab;
			prefab.addToPrefab(this);
		}
		
		// Отсоединить обьект от префаба
		public function disconnectFromPrefab():void
		{			
			prefab.removeFromPrefab(this);
			this.prefab = null;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Добавление, удаление физики с обьекта
		private function addPhysics(bodyType:BodyType):void
		{
			//var polygon:Polygon = new Polygon();
			//var s:Shape = new Shape();
			
			body = new Body(bodyType);
			body.graphic = this;
			body.shapes.add(new Polygon(Polygon.rect(150, 40, 70, 80)));				
			body.align();
			
			body.space = Game.scene.space;
		}
		
		private function removePhysics():void
		{
			Game.scene.space.bodies.remove(body);
			body = null;
		}		
		
		public function get relativeCenter():Boolean 
		{
			return _relativeCenter;
		}
		
		public function set relativeCenter(value:Boolean):void 
		{
			value ? setCenter() : setCorner();			
			
			_relativeCenter = value;
		}
		
	}

}