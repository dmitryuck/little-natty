package game.ui 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import game.core.*;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Component extends Sprite 
	{
		private var _size:Size;
		private var _position:Position;
		
		private var _scale:Number;
		
		public var fileName:String;
		
		public var source:Source;
		
		// Обьект отображения компонента
		private var displayObject:DisplayObject;
		
		private var loader:Loader;
		
		
		public function Component(fileName:String, name:String) 
		{
			this.name = name;
			this.fileName = fileName;
			
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
			//addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function removeListeners():void
		{
			removeEventListener(Event.ENTER_FRAME, onUpdate);			
			//removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// События связанные с обьектом
		protected function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
			
			addEventListener(ComponentEvent.COMPONENT_LOADED, onCreate);
			
			if (fileName) loadDisplayObject(); else dispatchEvent(new ComponentEvent(ComponentEvent.COMPONENT_LOADED));
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		protected function onCreate(e:ComponentEvent):void
		{
			removeEventListener(ComponentEvent.COMPONENT_LOADED, onCreate);
			addListeners();
		}
		
		protected function onDestroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			removeListeners();
		}
		
		protected function onUpdate(e:Event):void
		{
			
		}
		
		/*protected function onClick(e:MouseEvent):void
		{		
			
		}*/
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Отобразить обьект ресурса
		public function loadDisplayObject():void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDisplayObjectLoaded);
				
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			loaderContext.allowLoadBytesCodeExecution = true;			
				
			loader.loadBytes(source.getSource(), loaderContext);
		}
		
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
			
			dispatchEvent(new ComponentEvent(ComponentEvent.COMPONENT_LOADED));
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
		// Установка свойств компонента
		public function get position():Position 
		{
			_position.x = this.x;
			_position.y = this.y;
			
			return _position;
		}
		
		public function set position(value:Position):void 
		{
			this.x = value.x;
			this.y = value.y;
			
			_position = value;
		}
		
		// Размер компонента
		public function get size():Size 
		{
			_size.width = this.width;
			_size.height = this.height;
			
			return _size;
		}
		
		/*public function set size(value:Size):void 
		{
			this.width = value.width;
			this.height = value.height;
			
			_size = value;
		}*/
		
		// Скале компонента
		public function get scale():Number 
		{			
			return this.scaleX;
		}
		
		public function set scale(value:Number):void 
		{			
			this.scaleX = this.scaleY = value;
		}		
	}

}